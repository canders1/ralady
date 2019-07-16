import sys

"""
Script for formatting paired Bible text data
"""

def number_split(w):
	if w.replace('‑','').replace('-','').isnumeric():
		return(' '.join(list(w)))
	return(w)

def lex_punctuation(line):
	space_list = "; , . ( ) \" ? ! : - “ ¡ — ‑".split(' ')
	for s in space_list:
		line = line.replace(s,' '+s+' ')
	sp = line.split(' ')
	words = [s for s in sp if s !='']
	words = [number_split(w) for w in words]
	line = ' '.join(words)
	return(line)

def main():
  if len(sys.argv) < 5:
    print("Usage: python format_data.py src.csv tgt.csv output_src output_tgt")
    return()
  src_data = open(sys.argv[1],'r').readlines()
  src = [s.split(',') for s in src_data]
  tgt_data = open(sys.argv[2],'r').readlines()
  tgt = [t.split(',') for t in tgt_data]
  src_verses = []
  tgt_verses = []

  for i,s in enumerate(src):
  	t = tgt[i]
  	s_chapter = s[1].split(' ')[-1]
  	t_chapter = t[1]
  	s_verse = s[2]
  	t_verse = t[2]
  	if t_verse != s_verse:
  		print("Misalignment at "+s[1]+":"+s_verse+", "+t[0]+" "+t_chapter+":"+t_verse+" !")
  		print("Fix before proceeding...")
  		return()
  	src_verses.append(lex_punctuation(','.join(s[3:])))
  	tgt_verses.append(lex_punctuation(','.join(t[3:])))

  assert(len(src_verses)==len(tgt_verses))
  with open(sys.argv[3],'w') as osf:
  	for s in src_verses:
  		osf.write(s)
  with open(sys.argv[4],'w') as otf:
  	for t in tgt_verses:
  		otf.write(t)

main()