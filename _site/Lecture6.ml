(*
Higher-order functions.
- Give a name to a common pattern of function.
- Argument is a *piece of code* that instantiates the pattern.
  (What is different between two instance of the pattern.)
  By *peice of code*, we mean a function.
- Some examples:
  - Do something to first the component of a pair.
  - Do something to every element of a list.
*)

(* Functions can be returned from other functions *)

(* This is sugar. *)
let returnsAdd () =
    (let add (x,y) = x+y
    in add);;

(* The above is shorthand for: *)
    let returnsAdd () =
        (let add = fun (x,y) -> x+y
         in add);;

(* Since we are just returning add, don't need to give it a name. *)

let returnsAdd () =
    (fun(x,y) -> x+y);;

(* The inner (returned) function can refer to parameters of the
    outer function *)

let incBy m = fun n -> m+n;

let incBy5 = incBy 5;; (* captures m = 5*)
let incBy6 = incBy 6;; (* captures m = 6*)

(* defining m later doesn't affect incBy5 or incBy6 *)
let m = 1;;
incBy5 6;; (* still 11 *)

(* can also capture globally defined names  *)

let x = 1;;
let incByX = fun y -> x+y;;
let x = "hello"

(* can redefine x, incByX's definition of x doesn't change. *)

(* Back to the program of removing boilerplate. *)

let rec removeNegatives = fun l ->
  match l with
  | [] -> []
  | hd::tl -> let newtl = removeNegatives tl in
                    if hd < 0
                    then newtl
                    else hd::newtl
;;

let rec removeBy = fun f -> fun l ->
 match l with
 | [] -> []
 | x::xs -> let xs' = removeEmpties f xs in
                   if f x
                   then xs'
                   else x::xs'
;;

(* Use removeBy to implement removeNegatives and removeEmpties *)
let removeNegatives = removeBy (fun x -> x < 0)
let removeEmpties = removeBy (fun s -> s = "")

(* This idea of removing elements of a list according to some predicate is
commonly used in functional programming.

    OCaml has this built-in: List.filter
    NOTE: Its argument tells which elements to keep.
    *)

    (* sum the elements of a non-empty list *)
let rec sumList = fun l ->
  match l with
  | [x] -> x
  | hd::tl -> hd + sumList tl
;;

let rec prodList = fun l ->
  match l with
  | [x] -> x
  | hd::tl -> hd * prodList tl
;;

let rec combineInts =
  fun (f : int -> (int -> int)) (l : int list) ->
  match l with
  | [x] -> x
  | hd::tl -> let tlCombined = combineInts f tl in
              f hd tlCombined
;;


let sumList = combineInts (fun x y -> x + y);;
let prodList = combineInts (fun x y -> x * y)

let sumList = combineInts ( + );;
let prodList = combineInts ( * );;

(* Concatenate a non-empty list of strings, with intermediate spaces *)
let rec combineAll = fun f l ->
  match l with
  | [x] -> x
  | hd::tl -> let tlCombined = combineAll f tl in
              f hd tlCombined
;;

let rec concatWords = combineAll (fun x y -> x ^ " " ^ y);;

(* combineAll (fun x y -> x - y) [1;2;3];;

  1 - (2 - 3) = 2
  combineAll f [x;y;z]
= f x (combineAll f [y;z])
= f x (f y (combineAll f [z]))
= f x (f y z)

combineAll is right associative.
 *)


 (* Define a left-associative version of combineAll *)

(* hw3: let rec combineAllLeft = fun f l ->
  match l with
  |  *)
