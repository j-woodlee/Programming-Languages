(*
    First-class functions.
    - you can treat them like any other type of value.
    - assign them to variables
    - pass them as arguments to other functions
    - return them from other functions
    - store them in lists, tuples, etc.

Higher-order function is a function that takes another functions as its input

HOFs are good for:
  - expressiveness
    - "get more done with less code"
    - makes it easier to read and write code
  - reduction of boilerplate

*)

let inc x = x+1;;

(* Anonymous funcitons *)
let inc = (fun x -> x+1);;

(*
let inc x = x+1;;
is just an abbreviation for
let inc = (fun x -> x+1);;

*)

(*
Define a function that adds 1 to the first component of a pair of ints
*)

let incFirst = fun p ->
  match p with
    | (x,y) -> (x+1,y)
;;

(* Define a function that appends "!" to the first component of a pair of strings *)

let exclaimFirst = fun p ->
  match p with
  | (x,y) -> (x ^ "!", y)
;;

(* Boilerplate! How can we get rid of it?

  Higher order function!

  Parameter: what to do to the first component

*)

let applyToFirst = fun (f, p) ->
  match p with
  | (x,y) -> (f x, y)
;;

(*Define incFirst and exclaimFirst using applyToFirst*)
let incFirst = fun p -> applyToFirst((fun x -> x+1), p);;
let exclaimFirst = fun p -> applyToFirst((fun x -> x^"!"), p);;

(*  Passing multiple arguments.
*)

let add = fun (x,y) -> x+y;;

(* Using higher-order functions: the ability to return one function from anothe. *)

let add = fun x -> (fun y -> x+y);;

let inc = add 1;;

(*
    let inc = (fun x -> (fun y -> x + y)) 1
            = (fun y -> 1 + y)
*)


(* Let's use higher-order functions to simplify applyToFirst*)

let applyToFirst = fun f -> fun p ->
  match p with
  | (x,y) -> (f x, y)
;;

(* Doing this allows us to pass the arguments to applyToFirst one at a time.

*)

let incFirst = fun p -> applyToFirst (fun x -> x+1) p;;
(*                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ <- This is a function*)

let incFirst = applyToFirst (fun x -> x+1);;
let exclaimFirst = applyToFirst (fun x -> x^"!");;

(* This style of functions taking arguments one-at-a-time is preferred in ocaml.
    It has syntactic support:

    Instead of this: (fun x -> fun y -> x+y)
    we can write:    (fun x y -> x+y)
    *)

let f = applyToFirst (String.length);;

(* Example: define incList that adds 1 to each element of a list of ints. *)


let rec incList = fun l ->
  match l with
  | [] -> []
  | hd::tl -> (hd+1) :: incList tl
;;

(* Define exclaimList that appends "!" to each string in a list of strings. *)


let rec exclaimList = fun l ->
  match l with
  | [] -> []
  | hd::tl -> (hd^"!") :: exclaimList tl
;;

(* Boilerplate! How can we remove it? *)

let rec applyToEach = fun f l ->
  match l with
  | [] -> []
  | hd::tl -> (f hd) :: applyToEach f tl
;;

let incList = applyToEach (fun x -> x+1);;
let exclaimList = applyToEach (fun x -> x^"!");;

(*
  applyToEach is usually called map (List.map)
  similar to "forEach" in other languages, but map returns a new list
*)

(* Increment each int in a list of lists of ints.
  JavaScript:
    var l = [[1,2,3], [4,5,6], [7,8,9]];
  for(var i=0; i < ls.length; i++) {
    for(var j = 0; j < ls[i].length; j++) {
      ls[i][j]++;
    }
  }

  Let's do this in OCaml.
*)
map = applyToEach;;
let l = [[1;2;3];[4;5;6];[7;8;9]];;
let incListList = map (map(fun x -> x + 1));;
