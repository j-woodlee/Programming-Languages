"""
OCaml pros and cons:
pros:
    - simple, clean, relatively straightforward
    - not too difficult to express an idea, once you have it
    - requires forethought (also a con)
    - pattern matching
    - type inference
    - immutability

cons:
    - requires forethought
    - parser is not very smart
    - lots of nested scopes can get confusing
    - immutability is sometimes a pain

    FP idioms are becoming mainstream:
    - JS, Java, C++, Swift, rust, scala all combine
      imperative and FP concepts.

Python:
 - efficient  (programmer effort). expressiveness
 - very expressive libraries.
    - both official and third-party
    - good documentation
    - FFI (foreign function interface)
 - high level language
 - intuitive syntax
    - avoids unpleasant syntax
    - for x in l:
    - whitespace-aware syntax
        - pro and con
        - can be error-prone

Python is a scripting language.
    - usually interpreted - doesn't need to be compiled.
    - other JS, Ruby, Perl, bash, lua, VBScript...
    - usually for interacting with some larger system
        - web browser
        - web server (PHP)
        - OS command line interface (bash, python, perl)
        - games (lua)
        - excel (VBscript)
    - usually dynamically typed
    - usually good for writing smaller programs
        - good for:
            - manipulating text
            - files I/O
            - file systems
            - invoking other programs
    - "rapid prototyping"
        - pro: explore the problem you are trying to solve
        - con: often just end up supporting a protoype long term
    - scripting languages tend to be messy
        - lots of features
            - from many paradigms
            - pro: many ways to tackle a problem
            - con: features tend ot interact in suprising ways
    - Function/imperative/OO
        - we'll focus on imperative and functional
        - key point: FP with side effects
            - reassign variables
            - mutate data structures
            - IO
        - this is increasing widely used
"""

# Tuples
(1,"hi")
tup = (1,"hi")
# tuples in python are
# except: indexing

# lists vs tuples:
# tuples immutable, lists
l = [1,'hi',3,4]

# if statements vs expressions
# a function or method body is a sequence of statments
# at the same level of indentation
# 123 is an expressions
# foo() is an expression
# expressions can be used where statments are expected
# the arguments to a function are expressions. can't be statements
#
# if statements:
#  > if cond_expr:
#  >   then_stmtn
#  > else:
#  >    else_stmt

# if expressions:
#     then_expr if cond_expr
#     then_expr if cond_expr else else_expr
#     then_expr if cond_expr (else None) if you leave off the else branch
