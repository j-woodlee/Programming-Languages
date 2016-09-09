(*

    More about tuples
*)

let tup = (1, "hi", 2.0, 4+5)

let (x,y,z,w) = tup;;
let ((x,y), h::t) = ((1,2), [3;4])

(*

New cases for our grammar:

E::= ... | (E1, E2, ..., En)
P::= ... | (P1, P2, ..., Pn)

*)

();; (*unit*)

let double x = x*2;;
let add (x,y) = x+y;;
let swap (x,y) = (y,x);;

let x = print_string "hello\n"

let randDigit () = Random.int 10



(*
Example: zip

zip ([1;2;3], [4;5;6]) = [(1,4); (2,5); (3,6)]

*)

let rec zip args =
    match args with
    | (_ , []) -> []
    | ([], _) -> []
    | (h1::t1 , h2::t2) -> (h1,h2) :: zip (t1, t2)
;;

(*Can we implement zip with 2 cases only?*)

(*Example: unzip

unzip [(1,4);(2,5);(3,6)] = ([1;2;3], [4;5;6])

*)

let rec unzip args =
    match args with
    | []      -> ([],[])
    | [(x,y)] -> ([x],[y])
    | (x1,y1)::(x2,y2)::rest ->
      let (xs,ys) = unzip rest in (x1 :: x2 :: xs, y1 :: y2 :: ys)

(*Simplify*)

let rec unzip args =
    match args with
    | []      -> ([],[])
    | (x,y)::rest ->
      let (xs,ys) = unzip rest in
      (x :: xs, y :: ys)

(*
Index

index (3, [1;2;3;4;5]) = 2
index (6, [1;2;3;4;5]) = -1

*)

let rec index (x,l) =
    match l with
    | [] -> -1
    | hd::tl -> if hd=x then 0 else 1 + index(x,tl)
;;

(* Fixing the 6 case *)

let rec index (x,l) =
  let rec helper (i,l) =
      match l with
      | [] -> -1
      | hd::tl -> if hd=x then i else index(i+1, tl)
  in helper (0, l)
;;

(*A bit simpler*)

let index (x,l) =
  let rec helper (i,l) =
      match l with
      | [] -> -1
      | hd::_ when hd=x -> i
      | _::tl if  -> helper (i+1, tl)
  in helper (0, l)
;;

(* Equality *)

[1;2;3] = (1::2::3::[]);;

(*Functions

Functions are *first-class* -- they are just data.
Can be treated like any other value -- ints, lists,

*)

let twice (f, x) = f (f x);;

let square x = x * x;;
