from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(open("pdfminer-master/short.xml"), 'xml',from_encoding="utf-8")
chapters = []
intro = 0
pat = re.compile('.*\.\.\..*')
for line in soup.find_all('textline'):
	s = ""
	prev = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (pat.match(s)):
		chapters.append(s.split(".")[0])
	prev = s
start = chapters[0].upper()
startpat = re.compile('(\w+) '+start)
for line in soup.find_all('textline'):
	s = ""
	prev = ""
	for l in line.find_all('text'):
		s = s + l.string
	print(s.encode('utf-8'))
	print '(\w+) '+start
	if (startpat.match(s)):
		print "Found start!"
	prev = s
	#print(s.encode('utf-8'))
print start