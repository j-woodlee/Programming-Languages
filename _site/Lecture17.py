"""

Higher order functions in Python.
- Currying
- Closures
- Mutation

"""
def plus(x,y):
    return x + y

# unlike OCaml, currying doesn't happen automatically, however we can do manual currying

def plus(x):
    def plusX(y):
        return x+y
    return plusX

def plus(x):
    return lambda y: x+y

# combination of first-class functions and mutation.

# a simple way of modeling objects:
# an object is some data and some associated operations on that data.

def Counter():
    n = 0
    def f(cmd):
        if cmd == "get":
            return n
        else:
            raise "Unknown method"
    return f

def Counter():
    n = 0
    def callMethod(methodName):
        if methodName == "get":
            return n
        else:
            raise "Unknown method"
    return callMethod

def Counter(m):
    n = m
    def callMethod(methodName):
        if methodName == "get":
            return n
        elif methodName == "inc":
            n+=1
        else:
            raise "Unknown method"
    return callMethod

# Error! Subtle interaction between mutation and closures in python
# Rule: if a function assigns to a variable, it can't be a closure
# variable
# - Closures are immutable in Python.
#

def Counter(m):
    state = {'n' : m}
    def callMethod(methodName):
        if methodName == "get":
            return state['n']
        elif methodName == "inc":
            state['n'] += 1
        else:
            raise "Unknown method"
    return callMethod

# Works!
# Even though closures are immutable, they can refer to mutable data


"""
    Closure { n = 5 } --> Closure { n = 6 } CANT DO THIS!

    Closure { state = {'n':5 }} --> Closure { state = {'n':6 }}

Subtle interaction between closures and mutation.
- This is a design choice that Python made

Example: JS

function Counter () {
    var c = 0;
    return function(methodName) {
            switch(methodName) {
            case "get":
                return c;
            case "inc":
                c+=1;
                break;
            default:
                throw new Error("unkown method");
        }
    }
}
"""

# We can do similarly in Python

def Counter(m):
    state = {'n' : m}
    def inc():
        state['n'] += 1
    return (lambda : state['n'], inc)

c = Counter(5)

"""

This idea is idiomatic in JS, for:
- objects
- libraries.
Closure (mutable in particular) can provide *modularity*
- hiding implementation details
- closure variables are used in objects as *private* field/members
- closure variables are used in libraries as *internals*
    - state, helper functions, ... that should be hidden from clients
Why?
- JS has no other way to enforce the abstraction boundaries of objects
    and/or libraries.
- Closure variables can't be accessed from outside the closure.

Not idiomatic for python.(not widely used)
Instead, python uses a *convention* for privacy.
Decorate your private names with a "__" prefix
Signals/warns your clients that this is private

"""

class Counter:
    def __init__(self):
        self.__n = 0
    def get(self):
        return self.__n
    def inc(self):
        self.__n += 1
    def __reset(self):
        self.__n = 0

"""
So modularity in Python is *encouraged* but not *enforced*

If we want true privacy, we can use a closure object.

"""

def Counter():
    private = {'n' : 0}
    class Impl:
        def __init__(self):
            private['n'] = 0
        def get(self):
            return private['n']
        def inc(self):
            private['n'] += 1
        def __reset(self):
            private['n'] = 0
return Impl()

# We can make reset private too by storing it in private


def Counter():
    private = {}
    class Impl:
        def __init__(self):
            private['n'] = 0
            def __reset(self):
                private['n'] = 0
            private['reset'] = reset
        def get(self):
            return private['n']
        def inc(self):
            private['n'] += 1
return Impl()

# private --> reset --> private --> reset --> private --> reset --> ...
