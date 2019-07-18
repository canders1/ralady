import sys

def main():
	src = sys.argv[1]
	outfile = sys.argv[2]
	lines = open(src,'r').readlines()
	lines = [l.strip('\n') for l in lines]
	currBook = "BEGIN"
	currChapter = "BEGIN"
	currVerse = "BEGIN"
	verses = []
	for l in lines:
		segs = l.split('>')
		segs = [x for x in segs if x !='']
		if len(segs) == 1: #Found a heading
			taglist = segs[0].strip('\t').split(' ')
			kind = taglist[0].strip('<')
			if kind == "BIBLEBOOK":
				if len(taglist) == 4:
					currBook = taglist[2].split('=')[1].strip('"') + ' ' + taglist[3].strip('"')
				else:
					currBook = taglist[2].split('=')[1].strip('"')
				print(currBook)
			elif kind == "CHAPTER":
				currChapter = taglist[1].split('=')[1].strip('"')
		elif len(segs) == 2: #Found a verse
			taglist = segs[0].strip(' ').split(' ')
			kind = taglist[0].split('<')[1]
			if kind == 'VERS':
				verse = segs[0].split('=')[1].strip('"')
				text = segs[1].split('<')[0]
				newline = ','.join([currBook,currChapter,verse,text])
				verses.append(newline)
	with open(outfile+'.csv','w') as of:
		for v in verses:
			of.write(v+'\n')

main()