(* Name:
   Email:
   Student ID:

   Others With Whom I Discussed Things:

   Other Resources I Consulted:

*)

exception TODO;;

(* READ THIS FIRST!

   For this homework you will implement more higher-order functions,
   continuing with our theme this week of removing boilerplate code.

   Similar story to homeworks 1 and 2. Replace "raise TODO" in each
   problem with an OCaml expression. Use the testing script
   hw2-tester.ml to test your solutions. You should do more testing,
   as I will use additional test cases for grading.

   You can run `ocaml hw3-tester.ml` now (everything will be marked
   TODO).  I recommend you TEST EARLY AND OFTEN as you work on each
   problem.

   Homeworks should be completed individually. Do not show your code
   to another student, or look at another student's code. You may
   discuss the problems at a conceptual level (independently of OCaml
   particulars) with another student, or discuss OCaml particulars
   independently of particular homework problems. If you get stuck,
   email me or come to office hours.

 *)


(* Problem 1

   Without using any built-in ocaml functions, define a recursive
   function combineAllLeft. This is like the function combineAll we
   implemented in class Thursday, except it associates the elements to
   the left. You can assume the input list is non-empty.

   combineAllLeft (-) [1;2;3] = (1 - 2) - 3 = -4

   You may use a helper function if you want to, but its not needed.

 *)

let rec combineAllLeft (f : 'a -> 'a -> 'a) (l : 'a list) : 'a =
  match l with
  | [x] -> x
  | hd::tl -> let tlCombined = combineAll f tl in
              f hd tlCombined
;;

(* Problem 2

   Without using any built-in functions or helper functions, write a
   recursive function to compute the length of a list. It should
   handle lists of any size. You can assume the list is not empty.

   Example:
     length [1;2;3] = 3

 *)

let rec length (l : 'a list) : int =
  match l with
  | [] -> 0
  | [x] -> 1
  | hd::tl -> 1 + length tl
;;

(* Problem 3

   Without using any built-in functions or helper functions, write a
   recursive function that tests if a value is contained in a
   list. You can assume the list is not empty.

   Example:
     contains [1;2;3] 2 = true
     contains [1;2;3] 0 = false

 *)

let rec contains (l : 'a list) (e : 'a) : bool =
  match l with
  | [] -> false
  | hd::tl -> if hd=e then true else contains tl e
;;

(* Problem 4

   Can we use combineAll or combineAllLeft to implement length or
   contains? If yes, give implementations of each in this comment. If
   not, explain why not.


 *)

(* Problem 5

   Implement a version of combineAll (from lecture 6) that can handle
   empty lists as well. It should work with lists of any type. The
   second argument is the return value when the input list is the
   empty list. Do not use any built-in functions or helper functions.

   Examples:
     combineAll ( + ) 0 [1;2;3;4] = 10
     combineAll ( * ) 1 [1;2;3;4] = 24
     combineAll ( - ) 0 [1;2;3]   = 2

 *)

let rec combineAll (f : 'a -> 'a -> 'a) (r : 'a) (l : 'a list) : 'a =
  raise TODO
;;

(* Problem 6

   Remove the type annotations from combineAll. That is, replace the
   line:

   let rec combineAll (f : 'a -> 'a -> 'a) (r : 'a) (l : 'a list) : 'a =

   with:

   let rec combineAll f r l =

   When you load this into ocaml, it should infer the following type
   for combineAll:

   ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b

   What is the difference between this type and the type of combineAll
   with the type annotations? In particular, what can we do with the
   new type that we couldn't do with the old type? Give your answer in
   this comment.

 *)

(* Problem 7

   Use the new version of combineAll to implement length. Do not use
   any built-in functions other than +. This version should handle
   empty lists as well. Your solution should be a single call to
   combineAll. That is, something of the form:

   let length2 (l : 'a list) : int = combineAll ...

   Examples:
     length2 [] = 0
     length2 [1;2;3] = 3
 *)

let length2 (l : 'a list) : int =
  raise TODO
;;

(* Problem 8

   Use the new version of combineAll to implement contains. This
   version of contains should handle empty lists. Do not use any
   built-in functions other than =. Your solution should be a single
   call to combineAll.

   Examples:
     contains2 [] 5 = false
     contains2 [1;2;3] 2 = true
     contains2 [1;2;3] 0 = false
 *)

let contains2 (l : 'a list) (e : 'a) : bool =
  raise TODO
;;

(* Problem 9

   In Lecture 5 we implemented the function "map" that applies a
   function to each element of list. This generalized the functions
   incList and exclaimList. It turns out that combineAll generalizes
   map! Use combineAll to implement map. Do not use any built-in
   functions. Your solution should be a single call to combineAll.

   Examples:
     map (fun x -> x+1) [1;2;3]  =  [2;3;4]
     map (fun x -> x^"!") ["ocaml"; "is"; "fun"] = ["ocaml!"; "is!"; "fun!"]

 *)

let map (f : 'a -> 'b) (l : 'a list) : 'b list =
  raise TODO
;;

(* Problem 10

   In Lecture 5 we also implemented the function "removeBy" that
   removes the elements from a list for which some input predicate
   returns true. OCaml's built-in function List.filter is similar,
   except that it removes the elements for which the predicate returns
   false. It turns out that combineAll generalizes filter too. Use
   combineAll to implement filter. Do not use any built-in
   functions. Your solution should be a single call to combineAll.

   Example:
     filter (fun x -> x > 0) [-1;2;-3;0;5] = [2;5]

 *)

let filter (f : 'a -> bool) (l : 'a list) : 'a list =
  raise TODO
;;

(* Problem 11

   Implement a left-associative version of combineAll. In other words,
   implement a version of combineAllLeft that works on empty lists. Do
   not use any helper functions or built-in functions.

   Hint: pay attention to the types!

   Examples:
     combineAllLeft2 ( - ) 0 []        = 0
     combineAllLeft2 ( - ) 0 [1;2;3]   = -6
     combineAllLeft2 ( ^ ) "" ["ocaml "; "is "; "fun"] = "ocaml is fun"

   Hint: consider the difference between:

     combineAllLeft2 ( - ) 0 [1;2;3]   = -6
     combineAllLeft ( - ) [1;2;3]      = -4

 *)

let rec combineAllLeft2 (f : 'b -> 'a -> 'b) (r : 'b) (l : 'a list) : 'b =
  raise TODO
;;

(* Problem 12

   Re-implement fastRev using a single call to combineAllLeft2. It
   should be as fast as your implementation of fastRev in hw2. Do not
   use @, or any recursive helper functions.

   Example:
     fastRev [1;2;3] = [3;2;1]

 *)

let fastRev (l : 'a list) : 'a list =
  raise TODO
;;
