from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(open("pdfminer-master/short.xml"), 'xml',from_encoding="utf-8")
chapters = ['intro']
introduction = []
books = {}
books['intro'] = introduction
for line in soup.find_all('textline'):
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (s.find("....") > -1):
		chapters.append(s.split(".")[0])
for title in chapters:
	books[title] = []
section = 0
nextsection = chapters[section+1].strip().upper()
prev = ""
for line in soup.find_all('textline'):
	lines = []
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (s.isdigit()):
		print(s.encode('utf-8'))
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
	curBook = books[chapters[section]]
	for w in lines:
		if (nextsection in w):
			section = section+1
			nextsection = chapters[section+1].strip().upper()
		if (w):
			curBook.append(w.encode('utf-8'))
for k in books.keys():
	print(k.encode('utf-8'))
	for h in books[1]:
		print h
