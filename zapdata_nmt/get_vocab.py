import sys

"""
Script for generating a vocabulary from a text file
"""

def main():
  if len(sys.argv) < 3:
    print("Usage: python format_data.py src.lang lang")
    return()
  src_data = open(sys.argv[1],'r').readlines()
  words = [w for l in src_data for w in l.strip('\n').split(' ')]
  vocab = set(words)
  with open('vocab.'+sys.argv[2],'w') as of:
  	of.write("<unk>\n<s>\n</s>\n")
  	for w in vocab:
  		of.write(w+'\n')

main()