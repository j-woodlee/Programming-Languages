(* ==================== HERE BE DRAGONS ====================

   This file defines a simple testing framework that you can use to
   test your programs. You don't need to understand any of this code
   to complete your homework.

 *)

(* load the homework *)
#use "hw3.ml";;

(* general-purpose test function *)
let test nm f o =
  print_string (nm ^ " ... ");
  let msg =
    try
      if f () = o
      then "OK"
      else "FAILED"
    with
    | TODO -> "TODO"
    | e    -> "ERROR: " ^ Printexc.to_string e
  in
  print_string (msg ^ "\n");;

(* Problem 1: combineAllLeft *)
test "combineAllLeft (-) [1;2;3]" (fun () -> combineAllLeft (-) [1;2;3]) (-4);;

(* Problem 2: length *)
test "length [1;2;3]" (fun() -> length [1;2;3]) 3;;
test "length [0]" (fun() -> length [0]) 1;;
test "length [1;2;3;4;5;1;3;3;1]" (fun() -> length [1;2;3;4;5;1;3;3;1]) 9;;
test "length []" (fun() -> length []) 0;;


(* Problem 3: contains *)
test "contains [1;2;3] 2" (fun() -> contains [1;2;3] 2) true;;
test "contains [1;2;3] 0" (fun() -> contains [1;2;3] 0) false;;
test "contains [1;2;3] 3" (fun() -> contains [1;2;3] 3) true;;
test "contains [] 0" (fun() -> contains [] 0) false;;
test "contains [6;6;6;6;6;6;6] 6" (fun() -> contains [6;6;6;6;6;6;6;6] 6) true;;

(* Problem 5: combineAll *)
test "combineAll ( + ) 0 [1;2;3;4]" (fun() -> combineAll ( + ) 0 [1;2;3;4]) 10;;
test "combineAll ( * ) 1 [1;2;3;4]" (fun() -> combineAll ( * ) 1 [1;2;3;4]) 24;;
test "combineAll ( - ) 0 [1;2;3]"   (fun() -> combineAll ( - ) 0 [1;2;3])   2;;

(* Problem 7: length2 *)
test "length2 []" (fun() -> length2 []) 0;;
test "length2 [1;2;3]" (fun() -> length2 [1;2;3]) 3;;

(* Problem 8: contains2 *)
test "contains2 [] 5" (fun() -> contains2 [] 5) false;;
test "contains2 [1;2;3] 2" (fun() -> contains2 [1;2;3] 2) true;;
test "contains2 [1;2;3] 0" (fun() -> contains2 [1;2;3] 0) false;;

(* Problem 9: map *)
test "map (fun x -> x+1) [1;2;3]" (fun() -> map (fun x -> x+1) [1;2;3]) [2;3;4];;
test "map (fun x -> x^\"!\") [\"ocaml\"; \"is\"; \"fun\"]"
     (fun() -> map (fun x -> x^"!") ["ocaml"; "is"; "fun"])
     ["ocaml!"; "is!"; "fun!"];;

(* Problem 10: filter *)
test "filter (fun x -> x > 0) [-1;2;-3;0;5]"
     (fun() -> filter (fun x -> x > 0) [-1;2;-3;0;5])
     [2;5];;

(* Problem 11: combineAllLeft2 *)
test "combineAllLeft2 ( - ) 0 []" (fun() -> combineAllLeft2 ( - ) 0 []) 0;;
test "combineAllLeft2 ( - ) 0 [1;2;3]" (fun() -> combineAllLeft2 ( - ) 0 [1;2;3]) (-6);;
test "combineAllLeft2 ( ^ ) \"\" [\"ocaml \"; \"is \"; \"fun\"]"
     (fun() -> combineAllLeft2 ( ^ ) "" ["ocaml "; "is "; "fun"])
     "ocaml is fun";;

(* Problem 12: fastRev *)
test "fastRev [1;2;3] = [3;2;1]" (fun() -> fastRev [1;2;3]) [3;2;1];;
