(* ==================== HERE BE DRAGONS ====================

   This file defines a simple testing framework that you can use to
   test your programs. You don't need to understand any of this code
   to complete your homework.

 *)

(* load the homework *)
#use "hw2.ml";;

(* general-purpose test function *)
let test nm f i o =
  print_string (nm ^ " ... ");
  let msg =
    try
      if f i = o
      then "OK"
      else "FAILED"
    with
    | TODO -> "TODO"
    | e    -> "ERROR: " ^ Printexc.to_string e
  in
  print_string (msg ^ "\n");;

(* Problem 1: intsFromTo *)
test "intsFromTo (-1,3)" intsFromTo (-1,3) [-1; 0; 1; 2; 3];;
test "intsFromTo (-10,10)" intsFromTo (-10,10) [-10; -9; -8; -7; -6;-5 ;-4 ;-3 ;-2 ;-1 ;0 ;1 ;2 ;3 ;4 ;5 ;6 ;7 ;8 ;9; 10];;
test "intsFromTo (0,0)" intsFromTo (0,0) [0];;
test "intsFromTo (10,11)" intsFromTo (10,11) [10;11];;
test "intsFromTo (-1,-1)" intsFromTo (-1,-1) [-1];;
test "intsFromTo (0,7)" intsFromTo (0,7) [0; 1; 2; 3; 4; 5; 6; 7];;

(* Problem 2: count *)
test "count (5,[1;2;3])" count (5,[1;2;3]) 0;;
test "count (5,[1;5;5;0])" count (5,[1;5;5;0]) 2;;
test "count (5,[1])" count (5,[1]) 0;;
test "count (10,[])" count (10,[]) 0;;
test "count (1,[])" count (1,[]) 0;;
test "count (1,[1;1;1;1;1;1])" count (1,[1;1;1;1;1;1]) 6;;
test "count (0,[0])" count (0,[0]) 1;;
test "count (10,[10;10])" count (10,[10;10]) 2;;
(* Problem 3: append *)
test "append ([1;2;3], [4;5;6])" append ([1;2;3], [4;5;6]) [1;2;3;4;5;6];;
test "append ([], [4;5;6])" append ([], [4;5;6]) [4;5;6];;
test "append ([1], [10])" append ([1], [10]) [1;10];;
test "append ([7;5;4], [0;1;2])" append ([7;5;4], [0;1;2]) [7;5;4;0;1;2];;
test "append ([], [])" append ([], []) [];;
test "append ([0], [0;5;4])" append ([0], [0;5;4]) [0;0;5;4];;

(* Problem 4: reverse *)
test "reverse [1;2;3;4]" reverse [1;2;3;4] [4;3;2;1];;

(* Problem 5: fastRev *)
test "fastRev [1;2;3;4]" fastRev [1;2;3;4] [4;3;2;1];;
test "fastRev [1;2;3;4]" fastRev [1;2;3;4] [4;3;2;1];;
test "fastRev [1;2;3;4]" fastRev [1;2;3;4] [4;3;2;1];;
test "fastRev [1;2;3;4]" fastRev [1;2;3;4] [4;3;2;1];;
test "fastRev [1;2;3;4]" fastRev [1;2;3;4] [4;3;2;1];;


(* Problem 6: insort *)
test "insort [3;2;5;1;4]" insort [3;2;5;1;4] [1;2;3;4;5];;
test "insort [1;4]" insort [1;4] [1;4];;
test "insort []" insort [] [];;
test "insort [1;2;3;4;5;6]" insort [1;2;3;4;5;6] [1;2;3;4;5;6];;


(* Problem 7: splitBy *)
test "splitBy (pos, [1;2;-3;-4;5])" splitBy ((fun x -> x >= 0),[1;2;-3;-4;5]) ([1;2;5],[-3;-4]);;
test "splitBy (pos, [0;1;2])" splitBy ((fun x -> x >= 0),[0;1;2]) ([0;1;2],[]);;
test "splitBy (pos, [-4;5])" splitBy ((fun x -> x >= 0),[-4;5]) ([5],[-4]);;


(* Problem 8: update *)
test "update ([1;2;3], 0, add1, 0)" update ([1;2;3], 0, ((+)1), 0) [2;2;3];;
test "update ([1;2;3], 4, add1, 0)" update ([1;2;3], 4, ((+)1), 0) [1;2;3;0;1];;

(* Problem 9: partitionBy *)
let mod3 x = x mod 3 in
let input = (mod3, [2;3;5;0;2]) in
let output = [[3;0]; []; [2;5;2]] in
test "partitionBy (mod3, [2;3;5;0;2])" partitionBy input output;

let mod10 x = x mod 10 in
let input = (mod10, [2;3;5;0;2]) in
let output = [[0]; []; [2;2]; [3]; []; [5]] in
test "partitionBy (mod10, [2;3;5;0;2])" partitionBy input output;;
