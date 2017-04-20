from bs4 import BeautifulSoup

soup = BeautifulSoup(open("pdfminer-master/output.xml"), 'xml',from_encoding="utf-8")
print soup.original_encoding
for line in soup.find_all('textline'):
	s = ""
	for l in line.find_all('text'):
		s = s + l.string
	print(s.encode('utf-8'))