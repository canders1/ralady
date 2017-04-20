from bs4 import BeautifulSoup

soup = BeautifulSoup(open("short.xml"), 'xml',from_encoding="utf-8")
print soup.original_encoding
print(soup)