# Do not import anything other than sys and re!
import sys
import re

# this function removes punctuation from a string.
# you should use this before adding a word to the index,
# so that "asdf." and "asdf" and "asdf," are considered to be
# the same word.

def remove_punctuation(s):
  return re.sub(r'[^\w\s]', '', s)

assert(remove_punctuation('asdf.') == 'asdf')
assert(remove_punctuation('asdf,') == 'asdf')
assert(remove_punctuation("?;'.!") == '')

# index is a global dictionary. The keys should be words, and the
# values should be tuples of (filename, line number, position in line).

index = {}

def process_file(file):
    x = open(file, "r")
    for line in x:
        for y in re.finditer(r"\S+", line):
            y.group(0) #word
            y.start() #line
            print(y.start())

process_file("ipsum.txt")

def build_index():
    raise Exception("asdf")

build_index()


# commands

def words(args):
  raise Exception("Implement me: words")

def occurrences(args):
  raise Exception("Implement me: occurrences")

def context(args):
  raise Exception("Implement me: context")

def output(args):
  raise Exception("Implement me: output")

cmds = {
  'words' : words,
  'occurrences' : occurrences,
  'context' : context,
  'output' : output,
  }

def interact():
  # print the prompt line
  print('> ', end='', flush=True)

  for ln in sys.stdin:
    ln = ln.strip().split(' ')
    if ln[0] == 'quit':
      return
    else:
      cmds[ln[0]](ln[1:])

    # print the next prompt line
    print('> ', end='', flush=True)

interact()
