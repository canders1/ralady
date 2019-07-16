import sys

"""
Script for turning word-level data into character-level data
"""

def main():
  if len(sys.argv) < 2:
    print("Usage: python convert_to_char.py inputfile outputfile")
    return()
  data = [' '.join(list(l.strip('\n'))) for l in open(sys.argv[1],'r').readlines()]
  with open(sys.argv[2],'w') as of:
    for d in data:
      of.write(d+'\n')
main()
