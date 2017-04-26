"""
Parses the San Juan Guelavia Zapotec bible; or more generally, any book with the structure below:
+Introductory material, including a table of contents, where book names are identified by lines containing four periods
 Example: John ......... 109
+Books with titles in CAPS and chapters that are numbered:
 Example: 
 JOHN
 1 In the beginning was the word.
"""
from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(open("pdfminer-master/short.xml"), 'xml',from_encoding="utf-8")
titles = ['intro']
introduction = []
books = {}
books['intro'] = introduction
for line in soup.find_all('textline'):
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (s.find("....") > -1):
		titles.append(s.split(".")[0])
for title in titles:
	books[title] = {}
section = 0
nextsection = titles[section+1].strip().upper()
prev = ""
verse = 0
chapter = 1
for line in soup.find_all('textline'):
	lines = []
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	q = re.search('\(.*:.*\)',s)
	t = re.search(titles[section].strip(),s.strip())
	if ((not s.strip().isdigit()) and (not q) and not t):
		if (s.isupper()):
			if (prev.isupper()):
				prev = prev+s
			else:
				prev = s
		elif (prev.isupper()):
			lines.append(prev)
			lines.append(s)
			prev = s
		else:
			lines.append(s)
			prev = s
		curBook = books[titles[section]]
		for w in lines:
			if (nextsection in w):
				section = section+1
				nextsection = titles[section+1].strip().upper()
			if (section > 0):
				n = re.findall(('[0-9]+'),w)
				if n:
					for x in n:
						if (int(x)==verse+1):
							#print "Found a verse!"
							verse=verse+1
						else:
							#print "Found next chapter!"
							verse=1
							chapter = chapter+1
					#print verse
					#print chapter
					#print(s.encode('utf-8'))
			if (w):
				if chapter not in curBook:
					curBook[chapter] = {}
				c = curBook[chapter]
				if verse not in c:
					c[verse] = []
				v = c[verse]
				v.append(w.encode('utf-8'))
#for k in books.keys():
	#print(k.encode('utf-8'))
b = books[titles[1]]
cs = b.keys()
for c in cs:
	ch = b[c]
	vs = ch.keys()
	for v in vs:
		print ch[v]
