import sys
from collections import defaultdict

f = sys.argv[1]
lines = file(f,"r").readlines()
wc = defaultdict(float)
for l in lines:
	wrds = l.split(" ")
	for w in wrds:
		n = wc[w]
		wc[w] = n+1.0
top = []
for i in range(0,int(sys.argv[2])):
	top.append(("",0))
for k,v in wc.items():
	if v > top[0][1]:
		for j in range(len(top)-1,0,-1):
			if v >= top[j][1]:
				top.pop(0)
				top.insert(j,(k,v))
				break
for t in top[::-1]:
	print t[0], " : ", t[1]