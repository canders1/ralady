import sys
"""
Script for extracting and exporting verse names
"""
infile = sys.argv[1]
lines = open(infile,'r').readlines()
lines = [l.split(',')[0:3] for l in lines]
chapters = {}

for l in lines:
	chapter = ' '.join(l[0:2])
	if chapter in chapters:
		chapters[chapter] = max(chapters[chapter],int(l[2]))
	else:
		chapters[chapter] = int(l[2])

with open(sys.argv[2],'w') as of:
	for c in chapters.keys():
		of.write(c+': '+str(chapters[c])+'\n')