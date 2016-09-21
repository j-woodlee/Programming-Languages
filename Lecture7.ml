(*

Next tuesday: quiz 1.
- 35 minutes.  12pm to 12:35pm.
- Topics
  - Everything up till this thursday is fair game.
  - Functional programming concepts
    - Recursion over loops (iteration)
    - Can't update (reassign) variables.
    - Higher-order functions. Functions are data (first-class).
  - OCaml.  Mainly reading. Maybe some small writing.
  - Local vs global let
  - Pattern matching
  - Recursive Functions
  - first-class Functions
  - Lists and tuples
  - Rebinding names vs updating variables


Last week: Higher-order functions.
- Working with pairs.
- patterns for working with lists.
  - apply a function to eahc element of alist
  - select some of the elements of a list
  - combine all the elmeents into an aggregate value
- demonstrate the power of first-class functions
  - Reduces boilerplate code, making programs:
    - less tedious to write
    - easier to read
    - easier to maintain and evolve.
- These ideas scale gracefully
  - More interesting and complex forms of boilerplate
  - other kinds of languages, including imperative and OO
  - especially good for distributed and parallel programming
   - parallel: utilizing mulitple cores on a single CPU(or mulitple CPUs on a single machine)
   - distributed: utilizing multiple machines on a network
   - Java8 parallel stream API: automatically distributes map/filter/reduce
     over multiple cores.
   - map and reduce are at the core of Google's distributed computing infrastructure.  It's called Map/Reduce
     Open source version called Hadoop.
- Operations similar to map, filter, and reduce are the fundamental operations for
  query languages.

 *)


(*
- So far, we've used Ocaml's built in types (tuple, lists, ints, strings, ...)
- This is sufficient for anything, but there are better ways.

- Abstract data types: are a new type, with some associated operations.
  - The internals of the type are hidden from the user.
  - Forces the clients to use the interface (operations provided).
  - Clients have to follow the original intent of the type.
    - can maintain some *invariants* in the operations.
  - Allows us to ignore the implentation details. Think at a high level.
  - Manages complexity
    - of a large code base
    - of developing in a large team
  - Key idea: information hiding.

- User-defined types:
  - C: struct, enum, union
  - Java/C++: classes/objects

- Ocaml supports similar ideas, but different in several ways.
  - They're designed to be compataible with other features of OCaml.
    - They support pattern matching.
    - they promote immutability
*)

(* Enum-like *)

type sign = Pos | Neg | Zero;;


(*

Pos, Neg, Zero are the three values of type sign, can't add anymore values.
Rules:
- type names like "sign" begin with a lower case letter.
- the values (called constructors) begin with an upper-case letter.

What can we do with these things?
- compare them for equality
- Hint: they are first-class values
- pattern match.
*)

let signToInt s =
  match s with
  | Pos -> 1
  | Neg -> -1
  | Zero -> 0
;;

(*
Exhaustiveness and redundancy checks work for User-defined types too!

*)

(*
constructors can have associated fields too
*)

type point = Cartesian of (float * float);;

(* Syntax: <ConstructorName. of <type>

point is distinct from (float * float).
- you can't use one where the other is expected.


 *)

let negate (p : point) : point =
    match p with
    | Cartesian (x,y) -> Cartesian(-. x, -. y)(* -. is the subtract operator on floats *)
;;

let negate (p : point) : point =
    let Cartesian (x,y) = p in
    Cartesian (-. x, -.y)
    (* -. is the subtract operator on floats *)
;;

let negate (p : point) : point =
    Cartesian (-. x, -.y)
;;


(* This is like a struct in C, except there are no field names.

What's the C equivalent to this:

*)

type point1 = float * float;;

(* introduces type alias, a new name for another type.

equivalent in C: typedef

*)

(*
Recall: Ocaml does not have null pointers.
- this is a good thing. null pointers are the bane of imperative programming
- why do languages like C/C++/Java/Python/JS/... have something like null?
  - Tony Hoare invented the concept of a null or nothing or undefined value
    is included in every type. In his language called Algol (predecessor of C) in 1960s

    Square x = null;
    Triangle x = null;

  - It's been included in just about every imperative lanuage since.
  - Caused untol many bugs.
    - They can crash program, or worse
    - These bugs are subtle, and difficult to diagnose and fix.
  - Tony Hoare calls this his "billion dollar mistake"
  - Can we live without nullable pointers/references?

*)

type nullableInt = Null | NonNull of int;;

(*Increment a nullableInt*)
let incNullableInt n =
    match n with
    | Null -> Null
    | NonNull m -> NonNull (m+1)
;;

(*
Is this any better than nullable references/pointers?

- the types nullableInt and int are distinct.
- you can use + on a nullableInt.
- the type checker forces you to match.

*)

let addNullables m n =
    match m,n with
    | NonNull j, NonNull k -> NonNull (j+k)
    | _,_ -> Null
(* *)

let n = Null;;
let m = NonNull (4+7);;

(*

 *)
