Write a Python program that builds an index of one or more files, and
then lets the user interactively query the index to look up the
occurrences of words, print out a particular occurrence, or output the
entire index.

Interactive commands:
  words <prefix>
    -- Prints all the words in the index that start with with <prefix>.
    -- If <prefix> is empty, print all the words.
    
  occurrences <word>
    -- Print the occurrences of a word. The occurrences should be ordered
    -- first by filename (alphabetically), then by line number, then by
    -- position within the line. Each occurrence should be numbered, to make
    -- it easy to refer to it in the "context" command. Each occurrence should
    -- be listed on its own line, indented two spaces.

  context <word> <n>
    -- Print the line of the nth occurrence of a word, with the word
    -- underlined. Underline it by writing another line below, which is blank
    -- except for a ^ under each character of the word. See below for an
    -- example.

  output
    -- Print the entire index to standard output (sys.stdout). The index
    -- should be output in alphabetical order. Print each word on its own
    -- line, and then followed by its occurrences as for the occurrences command.

  quit
    -- Exit the program


Note: The index should be case-insensitive. You can achieve this by
converting all words to lower case (when building the index). Use the
method lower() on strings.

  For example, the commands "words a" and "words A" should always have
  the same response.

Example session:

$ python3 index.py lorem.txt ipsum.txt 
> words a
a
ac
accumsan
adipiscing
aenean
aliquam
aliquet
amet
ante
arcu
at
auctor
augue
> words al
aliquam
aliquet
> words AL
aliquam
aliquet
> occurrences aliquam
  (0) File lorem.txt, Line 18, Character 39
  (1) File lorem.txt, Line 22, Character 61
  (2) File lorem.txt, Line 25, Character 61
  (3) File lorem.txt, Line 35, Character 0
  (4) File lorem.txt, Line 38, Character 57
  (5) File lorem.txt, Line 48, Character 56
  (6) File ipsum.txt, Line 8, Character 33
  (7) File ipsum.txt, Line 22, Character 22
  (8) File ipsum.txt, Line 40, Character 22
  (9) File ipsum.txt, Line 49, Character 38
> context aliquam 7
nisl. Nulla facilisi. Aliquam sagittis accumsan elit id ultrices. Duis
                      ^^^^^^^
> words m
maecenas
magna
malesuada
massa
mattis
mauris
maximus
metus
mi
molestie
mollis
morbi
> occurrences maximus
  (0) File lorem.txt, Line 28, Character 8
  (1) File lorem.txt, Line 30, Character 17
  (2) File lorem.txt, Line 36, Character 32
  (3) File ipsum.txt, Line 48, Character 63
> context maximus 3
laoreet. Etiam scelerisque commodo purus, sit amet tempor nisl maximus
                                                               ^^^^^^^
> context maximus 2
enim elementum fermentum. Morbi maximus, risus vel tincidunt accumsan,
                                ^^^^^^^
> output
a
  (0) File lorem.txt, Line 4, Character 39
  (1) File lorem.txt, Line 6, Character 56
  (2) File lorem.txt, Line 9, Character 50
  (3) File lorem.txt, Line 10, Character 37
  (4) File lorem.txt, Line 17, Character 41
  (5) File lorem.txt, Line 18, Character 65
  (6) File lorem.txt, Line 21, Character 65
  (7) File lorem.txt, Line 24, Character 0
  (8) File lorem.txt, Line 32, Character 34
  (9) File lorem.txt, Line 47, Character 46
  (10) File ipsum.txt, Line 8, Character 50
  (11) File ipsum.txt, Line 13, Character 37
  (12) File ipsum.txt, Line 21, Character 40
  (13) File ipsum.txt, Line 23, Character 52
  (14) File ipsum.txt, Line 28, Character 36
  (15) File ipsum.txt, Line 30, Character 54
  (16) File ipsum.txt, Line 40, Character 41
  (17) File ipsum.txt, Line 47, Character 45
  (18) File ipsum.txt, Line 50, Character 63
ac
  (0) File lorem.txt, Line 17, Character 48
  (1) File lorem.txt, Line 26, Character 13
  (2) File lorem.txt, Line 30, Character 44
  (3) File lorem.txt, Line 32, Character 64
  (4) File lorem.txt, Line 39, Character 20
  (5) File lorem.txt, Line 45, Character 19
  (6) File lorem.txt, Line 48, Character 15
  (7) File lorem.txt, Line 50, Character 27
  (8) File ipsum.txt, Line 1, Character 64
  (9) File ipsum.txt, Line 3, Character 28
  (10) File ipsum.txt, Line 5, Character 49
  (11) File ipsum.txt, Line 7, Character 15
  (12) File ipsum.txt, Line 9, Character 38
  (13) File ipsum.txt, Line 16, Character 6
  (14) File ipsum.txt, Line 28, Character 7
  (15) File ipsum.txt, Line 29, Character 9
  (16) File ipsum.txt, Line 31, Character 35
  (17) File ipsum.txt, Line 34, Character 9
  (18) File ipsum.txt, Line 39, Character 0
  (19) File ipsum.txt, Line 47, Character 17

...... BUNCH OF LINES ELIDED ........

viverra
  (0) File lorem.txt, Line 3, Character 18
  (1) File lorem.txt, Line 5, Character 60
volutpat
  (0) File ipsum.txt, Line 21, Character 42
  (1) File ipsum.txt, Line 45, Character 58
vulputate
  (0) File lorem.txt, Line 16, Character 0
  (1) File lorem.txt, Line 46, Character 51
  (2) File lorem.txt, Line 49, Character 19
  (3) File ipsum.txt, Line 19, Character 9
  (4) File ipsum.txt, Line 40, Character 44
> quit
$


