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

def main():
	soup = BeautifulSoup(open("pdfminer-master/short.xml"), 'xml',from_encoding="utf-8")
	books = {}
	titles = get_titles(soup)
	text = build_text(soup)
	introEnd = first_substring(text,titles[-1])
	books[titles[0]] = text[0:introEnd+1]
	body = text[introEnd+1:-1]
	#for b in body:
		#print(b.encode('utf-8'))
	for t in range(1,len(titles)-1):
		#print t
		secTitle = titles[t].strip().upper()
		nextTitle = titles[t+1].strip().upper()
		nextStart = first_substring(body,nextTitle)
		if (nextStart > 0):
			while (body[nextStart-1].isupper()):
				nextStart = nextStart-1
			books[secTitle] = body[0:nextStart]
			body = body[nextStart:-1]
		print(secTitle.encode('utf-8'))
	books[titles[-1].strip().upper()] = body
	for b in books.keys():
		print(b.encode('utf-8'))
		print len(books[b])





def first_substring(strings, substring):
    return next((i for i, string in enumerate(strings) if substring in string), -1)

def get_titles(soup):
	titles = ['intro']
	for line in soup.find_all('textline'): #Search first for book names
		s = ""
		for l in line.find_all('text'):
			s = s + l.string
		if (s.find("....") > -1):
			titles.append(s.split(".")[0]) #Append to list of titles
	return titles

def build_text(soup):
	lines = []
	for line in soup.find_all('textline'):
		s = ""
		for l in line.find_all('text'):
			s = s + l.string
		lines.append(s)
	return lines

main()


"""
b = books[titles[1]]
cs = b.keys()
for c in cs:
	ch = b[c]
	vs = ch.keys()
	for v in vs:
		print ch[v]
"""