import sys

src_headings = [l.strip('\n') for l in open(sys.argv[1],'r').readlines()]
sp_headings = [l.strip('\n') for l in open(sys.argv[2],'r').readlines()]
assert(len(src_headings)==len(sp_headings))
with open(sys.argv[3]+'_comb_headings.txt','w') as of:
  for i,s in enumerate(src_headings):
    of.write(s+'\t'+sp_headings[i]+'\n')
