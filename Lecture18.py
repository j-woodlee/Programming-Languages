"""
HW6 is simple database query language
- file format is CSV
- one table. the CSV file
- the queries are simple. map and fold

Use python3!

"""

import sys

for fname in sys.argv[1:]:
    #open the file
    f = open(fname)

    #iterate over the lines of the file
    for ln in f:
        print(ln[:-1])

    f.close()

"""
Loops, iterators, and yield

Map doesn't return a list.
Returns a generator
- avoids allocating the entire list up front
- generate each element on demand
- can lead to subtle behaviors
    - possible that not every element is generated
    - watch out for side effects

We can define our own generators using the yield keyword

"""

def trace(x):
    print("generating " + str(x))
    return x

def myGen():
    print("calling myGen")
    yield 1
    yield "hey"
    yield False

"""
- myGen is called a *generator* in python
- it's a kind of *iterator*, which is what the for loop is looking for.
- An iterator is any object that has:
    - an __iter__ method
        - begins a new iteration
        - a list has an __iter__method
    - a __next__ method
        - provides the next value in the iterations
        - when no more values, raise StopIteration
"""

def intsFrom(n):
    while(true):
        yield n
        n+=1

#generator representation: like list comprehensions, but for generators
# (x*2 for x in intsFrom(1))

class myGen:
    def __init__(self):
        self.n = 0
    def __iter__(self):
        return self
    def __next__(self):
        print("calling __next__")
        self.n += 1
        if self.n > 5:
            raise StopIteration
        return self.n
"""
Note: there is no Iterator interface
Python's typing discipline is called "Duck typing"
    - if it walks like a duck and quacks like a duck, then it is
    - if an object has the methods expected of an iterator, its an iterator.


Python's iterator interface makes for loops extensible.
- Java, C++, Scala also have iterable, etc. for similar idea
- not as seamlessly integrated into that language as in python
- fancy generator expressions that are unique to python

"""
