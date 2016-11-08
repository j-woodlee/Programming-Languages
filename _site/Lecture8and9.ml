(*
Last time: user-defined data types.
*)

(*enum-style: a finite number of values in a new type*)
type color = Red | Blue | Green;;

(* struct-style: one constructor, mulitple fields*)
type colorPoint = ColorPoint of (float * float * color);;

(* typedef-style: a new name (alias) for an existing type *)
type colorPoint2 = (float * float * color);;

(* we can combine multiple constructors (enum) and fields *)
type nullableInt = Null | NonNull of int;;

(*
Advantages of modelling nullable values:
  - type system helps keep track of when you need to do null-checking.
*)

let incNullableInt (ni : nullableInt) : nullableInt =
    match ni with
    | Null -> Null
    | NonNull i -> NonNull (i+1)
;;

let doubleNullableInt (ni : nullableInt) : nullableInt =
    match ni with
    | Null -> Null
    | NonNull i -> NonNull (i*2)
;;


let updNullableInt (f : int -> int) (ni : nullableInt) : nullableInt =
    match ni with
    | Null -> Null
    | NonNull i -> NonNull (f i)
;;

let incNullableInt = updNullableInt (fun x -> x+1);;
let dbleNullableInt = updNullableInt (fun x -> x*2);;

(*

Which kind of higher-order function is updNullableInt?
  a) the kind that takes a function as input
  b) the kind that returns a functions as output

  Both!
*)

(* how can we convert a nullableInt to some other type, say string?
    - we need a string for the Null nullableInt
    - we need a function that converts an int to a string
    *)

let string_of_nullableInt ni =
    match ni with
    | Null -> "Null nullableInt"
    | NonNull i -> string_of_int i
;;

let fromNullableInt (ifNull : 'a) (ifNonNull : int -> 'a) (ni : nullableInt) : 'a =
    match ni with
    | Null -> ifNull
    | NonNull i -> ifNonNull i
;;

let string_of_nullableInt = fromNullableInt "Null nullableInt" string_of_int
let int_of_nullableInt = fromNullableInt (-5000) (fun x -> x);;

(* What if we wante a nullableString type?

  We could copy/paste the definition of nullableInt,
  and all of its higher-order functions, and update the field type.

  Bad. Boilerplate.
  Instead, use a polymorphic data type.

*)

type 'a nullable = Null | NonNull of 'a;;

type nullableInt = int nullable;;
type nullableString = string nullable;;

let updNullable f n =
    match n with
    | Null -> Null
    | NonNull x -> NonNull (f x)
;;

let fromNullable ifNull ifNonNull n =
  match n with
  | Null -> ifNull
  | NonNull x -> ifNonNull x
;;

(*
This nullable type is widely used in FP.  In OCaml, it's called option.
Null is called None.
NonNull is called Some.

used for reporting errors, modelling null, etc.

*)

let rec nth (n:int) (l:'a list) : 'a option =
    match (n,l) with
    | (0,[]) -> None
    | (0, hd::_) -> Some hd
    | (_, _::tl) -> nth (n-1) tl
;;

(* Recursive types *)
type 'a myList = Nil | Cons of ('a * 'a myList);;

(* Recursive because myList occurs in its own definition. *)

(* [1;2] = (1::2::[])
  as a myList:
  Cons(1, Cons(2, Nil))

  This is exactly how Ocaml's built-in lists are represented.
  [] and :: are just syntactic sugar (shorthand)
*)

let rec myMap (f : 'a -> 'b) (l : 'a myList) : 'b myList =
    match l with
    |  Nil -> Nil
    | Cons(hd,tl) -> Cons(f hd, myMap f tl)
;;

(*
How would you implement a singly-linked list in C/C++/Java?

class Node {
  int element;
  Node next;
}

Empty lists are usually represented as a null Node.

*)

type 'a node = Node of ('a * ('a node) option);;
type 'a linked_list = ('a node) option;;

let mapLL : (f : 'a -> 'b) (l : 'a linked_list) : 'b linked_list =
    match l with
    | None -> None
    | Some (Node(hd,tl)) -> Some(Node(f hd, mapLL f tl))
;;

(*
Can we convert a linkd_list to a myList?
Can we convert a myList to a linked_list?

Yes! They are effectively the same types.

Nil = None
Cons(hd,tl) = Some(Node(hd,tl))

In fancy math lingo, they are called isomorphic.
  *)

(* Here's a thing *)

type tree = Leaf
            | Node of (tree * int * tree);;

(* This thing is a binary tree *)

let t1 = Node (Leaf, 1, Leaf);;
let t3 = Node (Leaf, 3, Leaf);;
let t123 = Node (t1, 2, t3);;

(* count the number of nodes in a tree *)

let rec size (t : tree) : int =
    match t with
    | Leaf -> 0
    | Node(t1,i,t2) -> size t1 + size t2 + 1
;;

(* Preorder traversal: convert a tree to list in pre-order *)

let rec preorder t : int list =
    match t with
    | Leaf -> []
    | Node(t1,i,t2) -> (i::preorder t1) @ (preorder t2)
;;

let rec inorder t : int list =
    match t with
    | Leaf -> []
    | Node(t1,i,t2) -> (inorder t1) @ (i::inorder t2)
;;


(*
Definition: a binary tree is a binary search tree if:
  for every Node(l,i,r)
    every element in l is less than i
    every element in r is greater than i
*)

(* Insert into a binary search tree *)

let rec insert i t =
    match t with
    | Leaf -> Node (Leaf, i, Leaf)
    | Node(t1,j,t2) -> if i<j then Node(insert i t1,j,t2)
                       else if i > j then Node (t1,j,insert i t2)
                       else t
;;

(* We just implemented a *fast* sort algorithm
   Insert all elements of a list into a BST.
   in-order traversal outputs them in sorted order.
    *)

let rec treeSort : int list -> int list =
(* try implementing this using combineAll to insert all the elements into the BST. Then use in-order
*)
    fun l ->
    let t = combineAll insert Leaf l in
    inorder t
;;

(* Heterogenous lists.


int -> intOrString
string -> intOrString
*)

type intOrString = Int of int | String of string;;

let l = [Int 4; String "hello"; Int (-12)];;


(*
How is this different from heterogenous lists in a dynamicallyl typed language?
This list is still homogeneous.

intOrString is distinct from int and string.  The type system forces us to do a check.

  How do we check whether an intOrString is an int or a string?
  - pattern matching

  Can we use map/applyToEach?
    no, because it preserves the number of elements
  Can we use filter?
    no, because it preserves the type of the elements
  can we use combineAll/fold_right?
    yes
 *)

let rec lInts = combineAll (fun hd tlInts ->
                            match hd with
                            | Int i -> i::tlInts
                            | _ -> tlInts) [] l
;;

(* What if we want a boolOrString, or a boolOrIntOrString?
   Do we have to redefine the user-defined type in each case?
*)

type ('a, 'b) choice2 = C1of2 of 'a | C2of2 of 'b
type ('a,'b,'c) choice3 = C1of3 of 'a | C2of3 of 'b | C3of3 of 'c

(* Scope *)

(*
The key question is to know for each *reference* of a particular name, which *definition*
of that name is currently *in scope*

There are different ways to declare/define a variable, with different scopes.
 *)

 let x = 3;;
 let double n = n * 2;;

 (* x and double are globablly defined. We can reference them for
    the rest of the REPL session or file. *)
(* n is local to double. it's in scope within double's definition,
   and out of scope everywhere else. *)

(*
 Ocaml keeps track of an *environment* in which each expression should be evaluated.  The environment
 maps the names in scope to their *values*

 Some notation for environments.
 {}          empty environment
 {x = 32, y = "foo"} environment containing bindings for x and y 
  *)
