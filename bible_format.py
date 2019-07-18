import re
import sys

def align(a, b):
	#String-alignment function
    best, best_x = 0, 0
    for x in range(len(a)):
        s = sum(i==j for (i,j) in zip(a[x:],b[:-x]))
        if s > best:
            best, best_x = s, x
    return best_x

def clean_text(text):
	#Clean up text by merging chapter headings, removing blank lines
	text = [t.strip("\n") for t in text]
	text = [t for t in text if t.replace(' ','')!='']
	lines = ["START"]
	for i in range(1,len(text)):
		prev = lines[-1]
		curr = text[i]
		if re.search('[A-Z\s]{5,100}',prev) and re.search('[A-Z\s]{5,100}',curr):
			joint = prev + curr
			lines[-1] = joint
		else:
			lines.append(curr)
	return(lines[1:])

def export_lines(lines,pref):
	#Export cleaned text
	with open(pref+'_lines.txt','w') as of:
		for l in lines:
			of.write(l+'\n')

def clean_line(line):
	dlist = ["\u200b","\x0c","\x03"]
	slist = ["\u2009"]
	for r in dlist:
		line = line.replace(r,'')
	for s in slist:
		line = line.replace(s,' ')
	line = re.sub('[0-9]{3}','',line)
	return(line)

def chunk_chapters(book,keyword):
	chapters = []
	curr = []
	start_pref = keyword + " 1"
	curr_pref = start_pref
	for i,line in enumerate(book):
		line = clean_line(line)
		print(line)
		if keyword in line and line[-1].isdigit():
			verses = chunk_verses(curr)
			for v in verses:
				chapters.append((curr_pref,v[1]))
			curr_pref = line
			print(curr_pref)
			curr = []
		else:
			curr.append(line)
	verses = chunk_verses(curr)
	for v in verses:
		chapters.append((curr_pref,v[1]))
	return chapters

def chunk_verses(chapter):
	chapters = []
	verses = []
	inds = []
	curr = ""
	words = ' '.join(chapter).split(' ')
	print(words)
	for w in words:
		#print(w)
		if w.isdigit():
			break
	print(w)
	curr_pref = int(w) - 1
	for i,line in enumerate(chapter):
		print("LINE")
		print(line)
		if str(curr_pref+1) in line:
			halves = line.split(str(curr_pref+1))
			curr = curr + ' ' + halves[0]
			verses.append([curr_pref,curr.strip(' ')])
			inds.append(curr_pref)
			curr_pref = curr_pref+1
			curr = halves[1]
		elif re.search('^[1] ',line):
			print("Starting anew")
			print(line)
			halves = line.split("1")
			curr = curr + ' ' + halves[0]
			verses.append([curr_pref,curr.strip(' ')])
			inds.append(curr_pref)
			chapters.append((inds,verses))
			verses = []
			inds = []
			curr_pref = 1
			curr = halves[1]
		else:
			curr = curr + ' ' + line
	verses.append([curr_pref,curr.strip(' ')])
	inds.append(curr_pref)
	chapters.append((inds,verses))
	for c in chapters:
		inds = c[0]
		assert inds == sorted(inds)
	return chapters


def export_csv(bookdict,pref):
	with open(pref+"_messy.csv",'w') as of:
		for k in bookdict.keys():
			chapters = bookdict[k]
			for c in chapters:
				name = c[0]
				verses = c[1]
				for v in verses:
					if v != '':
						print(v)
						num = v[0]
						line = v[1]
						row = ','.join([k,name,str(num),line])
						of.write(row+'\n')

def main():
	pref = sys.argv[4]
	headings = open(sys.argv[3],'r').readlines()
	headings = [h.strip('\n') for h in headings]
	bookkeys = {}
	booknames = open(sys.argv[2],'r').readlines()

	booknames = [b.strip('\n').split('\t') for b in booknames]
	for b in booknames:
		bookkeys[b[0].strip(' ')] = b[1]
	data = open(sys.argv[1],'r').readlines()
	lines = clean_text(data)
	export_lines(lines,pref)

	enddict = {}
	strictdict = {}
	for h in headings:
		#print(h)
		enddict[h] = []
		strictdict[h] = []
	for i,line in enumerate(lines):
		#print(line)
		for h in headings:
			if h in line: #try to lazy-align headings and lines
				strictdict[h].append((i,line))
			else:
				mid = int(len(h)/2)
				if h[mid-10:mid] in line:
					enddict[h].append((i,line))
	for h in enddict.keys(): 
		if len(strictdict[h]) == 0:
			if len(enddict[h]) == 0:   #No matches
				print("Uh oh! Adjust heading search parameters for "+h+"!")
			else:                      #Too many matches, have to do string-alignment
				print("trying to align")
				best = ((-1,""),-1)
				for pair in enddict[h]:
					score = align(h,pair[1])
					if score >= best[1]:
						best = (pair,score)
				strictdict[h].append(best[0])
	chnames = []
	chstarts = []
	for h in strictdict.keys():
		chnames.append(h)
		chstarts.append(strictdict[h][0][0])
	assert chstarts == sorted(chstarts)

	chunkdict = {}
	for i,c in enumerate(chnames):
		if i == len(chnames)-1:
			chunkdict[c] = lines[chstarts[i]+1:]
		else:
			chunkdict[c] = lines[chstarts[i]+1:chstarts[i+1]]
	print("chunkkeys")
	for b in chunkdict.keys():
		print(b)
		#if 'DE DIDXZAAC XTE JESUCRIST NI BCUAA SAN MATEO' in b:
		btext = chunkdict[b]
		bkey = bookkeys[b]
		chapters = chunk_chapters(btext,bkey)
		chunkdict[b] = chapters
	export_csv(chunkdict,pref)

main()