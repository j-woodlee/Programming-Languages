import java.util.*;

/*
Dyanimic dispatch continued

def memoize(f):
    memotble = {}
    def newF(x):
        #x is an input to f
        if x not in memotble:
            memotble[x] = f(x)
        return memotble[x]
    return newF

fibImpl = //some implementation
fib = memoize(fibImpl)//just uses get to get the value from the dictionary


Dyanimic Dispatch

SomeClass obj = ...
obj.foo()

Where is the implementation of foo()?
    - from SomeClass itself.
    - a superclass of SomeClass
        - if obj's class inherits foo from superclass,
          and doesn't override.
    - a subclass of SomeClass
      the subclass overrides


*/
