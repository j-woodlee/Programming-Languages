(*
Types.

What is a type?
  - a set of values
  - the values of a particular type support some operations
  - a value is the result of running (or evaluating) an expression successfully
    (if no errors occur, and the evaluation terminates)

  Examples:
    - int is the set of 32 bit integers.
      - operations: +, -, *, /, mod, -, <, >
    - int list: is the set of lists of ints.
      - [], [1;2;3], etc.
      - ops: ::, pattern match, =
    - int * bool : pairs of an int and a bool
      - (1,true), (0, false), ...
      - op: pattern match
    - int -> bool: the set of functions from ints to bools
      - (fun x -> x > 0)
      - ops: apply (or call) a function with an argument

Several dimensions on which we can compare type systems.

Statically vs Dynamically typed languages
- close:
  - static: variables always hold values of the same type
  - dynamic: variables can hold values of different over time
  - in staticaly-typed OO languages (with subtyping):
      Object o = new Integer(5); // o holds an Integer
      o = "hello"; // o holds a String

- In statically typed languages, a type is a set of expressions,
  not just values.
  Ex: 1 + 3 has a type int
  Ex: x     has a type in a statically typed language

- *Static* means that we can type check without running the program

What if we have some expression
  x + 5
   that statically type checks because x has a static type int,
   and then we evaluate x and its values is [true;false]?

A static type system also *guarantees* that:
  if an expression e has some type T, then its value (when we run the program)
  *MUST* have type T.
  - note every expression has a value:
    - something that crashes the program,
    - goes into an infinite loop
    - raises an exception, etc.
  - caveat: *weakly* typed languages

If an expression can't be given a type statically (at compile time),
an error is signalled
  - 1 + [true;false]

Advantatges of Static type checking:
  - that certain kinds of errors can't happen when we run the program. (type erros)
  - enforces user-defined abstractions (information hiding)
    - allows the implementer of the abstraction (data structure, library, etc.)
      the freedom to redesign/reimplement.
  - efficiency
    - no need for runtime typechecking
    - optimized code for certains types

Disadvantages:
  - just run it.
  - no cryptic type error messages
  - often errors are reported from the fix.
  - can reject programs that are actually fine (static type checking is conservative).

      if false then 1+false else false

  - can require unnatural workarounds, code duplication (boilerplate!)
  - heterogeneous lists.
    - in python: [1,True,3.5,("hello",7)]
    - in OCaml:

      type intOrBoolOrFloatOrPairOfStringAndInt = Int of int | Bool of bool | ...
        - what operations are supported on intOrBoolOrFloatOrPairOfStringAndInt?
          - ops: =, pattern match
      pattern match to access fields, effectively adding dynamic type checking to
      the type system requires/warns us to do that.
      downside: we have to do it ourselves

- Python:
l = [1,True,3.5,("hello",7)]

def negate(x):
  return -x

map(negate,l)

def negate2(e):
  if type(e) == int:
    return -e
  elif type(e) == bool:
    return not e
  else:
    return e


- OCaml

type things = Int of int
              | Bool of bool
              | Float of float
              | Pair of (string * int)
;;

let negate e =
    match e with
    | Int i -> Int (-i)
    | Bool b -> Bool (not b)
    | _ -> e
;;

List.map negate [Int 1; Bool true; Float 3.5; Pair ("hello", 7)]

- Similar ideas, but more work in OCaml.
- but you get some help from the type checker.
  - exhaustiveness, ect.

- Ocaml's type system is limited in the errors it can detect
  - some errors still occur at runtime
  - pattern match failure
  - divide by zero,
  - uncaught exception

  - Some more powerful type systems can catch more of these,
    but at increased cost

Dynamic type checking:
  - types are not explicit in the program. No type annotations.
    instead types are carried along with values.
  - types are checked *on demand*
  - only checks the types of *values*, not *expressions*

  2 + False

  (1+2)(5, true)
    - evaluate the function position expression, check that its a function

  - dynamic type errors can be hard to debug. why did this value
    get into this spot?

  - How functions are type checked.
    - in  a dynamic system, the function body is re-checked every
      time it's called
    - in a static system, the function is checked once and for all.

        - if we have a function, what do we know about it?
        - in a dynamic lanuage, don't know much.
        - in a statically-typed languag , the type tells us a lot:
          int -> float -> bool

          expr -> val

        - static types help us think in *abstractions*.

- Often, dynamic type checking is good for:
  - exploration
  - rapid iteration,
  - small projects, small teams

- Static type checking is good for:
  - large projects, large teams
  - critical software
  - tooling
  example: Facebook
    Hack: statically typed variant of PHP
    Flow: static type checker for Javascript
    Hack and Flow are implmented in OCaml

- All projects start small. No brand new projects are critical.
- Makes sense to use dynamic type checking at the beginning
  of the project, and migrate toward static type checking.

  * Gradual typing *
  - spectrum between dynamic and static.
  - Ex: racket(scheme(lisp)), typescript (Microsoft)

*)
