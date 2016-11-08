(*
Midterm topics:
  - OCaml: pattern matching, recursion, 1st class functions, higher order functions,
    user defined types.
  - Syntax and grammar
  - Variables: scoping, lifetime
  - Typing: static vs dynamic, strong vs weak, automatic conversion
  - Hallmarks of functional programming
  - List functions map, filter, fold_right
  - Things from today.

This is a *big idea*. Look for these in the notes.

Last time:
  Weak typing:
    - The programmer is smarter than the type checker.
    - Types are just a suggestion.  We can work around them.
    - Ex: convert an int to a pointer.
      - corrupt the heap
      - corrupt the call stack
      - adversart(virus or hacker) can take control of our system

  Strong typing:
    - Types are enforced.

  Most languages (static and dynamic) have strong typing.
    - Exceptions: C/C++

  Auto conversion:
    - Often conflated with eak typing.
    - pro: avoiding dynamic type errors.
           convenient (converting between numeric types)
    - cons: WAT
            conversion heuristics are heuristics.
            it's hard to devise a general rule that always works
    - middle ground: user-controlled conversions (scala)
     - tools(IDE) can help show what's going on.

Back to typing (static typing in particular):
  - type checking vs type inference.
    - type checking requires user annotations
      - e.g. Java, C, C++.
      - pro: type errors are easier to understand
              type annotations are "checked documentation"
      - con: writing the type annotations is tedious
    - type inference does not require annotations (or requires fewer)
      - e.g. OCaml, Scala, Haskell
      - pro: less tedium
      - con: sometimes more confusing type errors.
    - middle ground: (scala)
      - require *some* annotations, but not all.
      - annotate inputs to functions, but not locals.

static/strong/check: Java
static/strong/infer: OCaml
static/weak/check: C/C++

dynamic/strong: List, JS, Python, Prolog,...
dynamic/weak:
  - essentially "untyped".  assembly language
  - "use the contents of this register as a memory address"
  - "use the contents of this register as an integer"
  - "use the contents of this register as a float"

dynamic/strong/infor: ?
dynamic/strong/check: ?
  None! the distinction between inference/checking is for statically typed languages.
*)

(*
Modules and modularity.

Example: List.map, List.fold_right
  - List is a module.
  - Modules provide *namespaces*
    Allows for two parts of a program to use the same name in different ways.
  - Set.map and List.map
    "Inside" the Set module, "map" refers to Set.map
  - We can refer to names in the module scope from outside.
    That's what List.map is doing.
  - Modules provide something more (and more important) than namespaces
    - modularity
    - separate interface from implementation.
    - encapsulation
  - How do we separate interface from implementation in an OO language?
    - use classes.
    - can ahve an "interface" or "abstract class" that defines the interface
    - concrete class is the implementation.
    - the internals of the class can be *private*, or hidden
*)

(*
  Example: component for tracking word counts.
  Data structure to store the data. Dictionary.
  We'll have some operations for incrementing the count,
  or getting the count
*)

type word_counts = (string*int) list;;

let empty = [];;

let rec incr w wcs =
    match wcs with
    | [] -> [(w,1)]
    | (w1,c)::tl ->
      if w = w1
      then (w1,c+1):: tl
      else (w1,c) :: incr w tl
;;

let rec get w wcs =
    match wcs with
    | [] -> 0
    | (w1,c)::tl ->
      if w = w1
      then c
      else get w tl
;;

let wcs = incr "hi" (incr "hi" empty);;

(*
Problem: the names word_counts, empy, incr, get could be used elsewhere in the program.

Limits the ability to use the component

Solution: use a module to put the names into a separate namespace.

*)

module WordCount =
  struct
      type word_counts = (string*int) list;;

      let empty = [];;

      let rec incr w wcs =
          match wcs with
          | [] -> [(w,1)]
          | (w1,c)::tl ->
            if w = w1
            then (w1,c+1):: tl
            else (w1,c) :: incr w tl
      ;;

      let rec get w wcs =
          match wcs with
          | [] -> 0
          | (w1,c)::tl ->
            if w = w1
            then c
            else get w tl
      ;;

  end

;;

let wcs = WordCount.incr "hi" (WordCount.incr "hi" WordCount.empty)

(*
In general, a module can contain *any kind of declaration*.
  - functions, types, exception, etc.
*)

(*
A new problem:
  - let's be the client of the WordCOunt now.
  - we want to get the word with the max count
 *)

 let rec max_wc wcs =
      match wcs with
      | [] -> None
      | (w,c)::tl ->
        (match max_wc tl with
          | None -> Some(w,c)
          | Some (w1,c1) ->
          Some(if c1>c then (w1,c1) else (w,c))
          )
;;

(*

- We're still the client.
- We notice that WordCount is super slow.
- We complain to the author.
  - They nicely agree to upgrade to use a hash table.
- Now max_wc breaks, so we can't use the better version!
- We are angry, and we cancel that paypal tip.
- Now the author is also angry, so they put a trojan into their component.

- Diagnosis: the client was tightly-coupled to the internals of the component.
  - The author can't upgrade their component.
  - The author is responsible, but ham-strung.

- We want the author to have the flexibility to change their design over time
  - To make something more efficient
  - To add new features

- Why not just always write efficient code?
  - Why not just always program in assembly language?
  - There's a trade off between efficiency  and clarity, ability to maintain it, fix bugs, add features, etc.
  - "premature optimization"
    - we don't know twhat needs to be fast until we start using the program.
  - leads to britlle code: hard to mainatin, easy to break, hard to fix.
  - better to "optimize" for clarity, simplicity, flexibility

- We want to separate the interface of the component from its implementation
  - what is an interface?
    - everything the client needs to know about the component in order to use it.
    - in particular: what the author will not change, vs what might change.
    - includes documentation, test cases, etc.

- Divide and Conquer.
  - break a large/complex problem into multiple smaller/simpler problems
    that can be solved *independently*. repeat
  - canonical example: sorting
  - what about programming?
    - break the work into separate modules/components
    - they can be developed/tested/etc. independently, *in parallel*
      - by different developers.
    - code reuse. libraries, application frameworks, open source projects.
*)
