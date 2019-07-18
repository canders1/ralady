import re
import sys

"""
Script for extracting source language chapter names given a list of 
Spanish chapter names and a Zapotec bible text
"""

headings = open(sys.argv[2],'r').readlines()
derv_headings = []
headings = [h.strip('\n') for h in headings]
data = open(sys.argv[1],'r').readlines()
hdict = {}
for h in headings:
	hdict[h] = []
for i,line in enumerate(data):
	for h in headings:
		if h in line:
			hdict[h].append((i,line))
	if re.search('[A-Z\s]{5,100}',line) and not re.search('[a-z]{3,100}',line):
		derv_headings.append((i,line.strip('\n')))

to_del = []
for i in range(1,len(derv_headings)):
	prev = derv_headings[i-1]
	curr = derv_headings[i]
	if curr[0] - prev[0] == 1:
		new_heading = prev[1] + ' ' + curr[1]
		derv_headings[i] = (curr[0],new_heading)
		to_del.append(i-1)
derv_headings = [h for i,h in enumerate(derv_headings) if i not in to_del]
for h in derv_headings:
	print(h[1].strip(' '))



