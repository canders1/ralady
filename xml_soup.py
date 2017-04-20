from bs4 import BeautifulSoup

soup = BeautifulSoup(open("pdfminer-master/output.xml"), 'xml')
print(soup.prettify())