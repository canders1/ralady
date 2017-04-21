from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(open("pdfminer-master/output.xml"), 'xml',from_encoding="utf-8")
chapters = []
for line in soup.find_all('textline'):
	s = ""
	prev = ""
	for l in line.find_all('text'):
		s = s + l.string
	pat = re.compile('.*\.\.\..*')
	if (pat.match(s)):
		chapters.append(s.split(".")[0])
	prev = s
	print(s.encode('utf-8'))
print chapters