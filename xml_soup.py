from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(open("pdfminer-master/short.xml"), 'xml',from_encoding="utf-8")
chapters = []
intro = 0
for line in soup.find_all('textline'):
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (s.find("....") > -1):
		chapters.append(s.split(".")[0])
start = chapters[0].strip().upper()
prev = ""
for line in soup.find_all('textline'):
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	if (prev.isupper() and s.isupper()):
		s = prev+s
	if (start in s):
		print "Found start!"
	prev = s
	if (s.isupper()==False):
		print(s.encode('utf-8'))
print start