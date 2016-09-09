(* ==================== HERE BE DRAGONS ====================

   This file define a simple testing framework that you can use to
   test your programs. You don't need to understand any of this code
   to complete your homework.

 *)

(* This declares a new kind of exception, called TODO.  I've put these
   as placeholders below.
 *)

exception TODO;;

(* load the homework *)
#use "hw1.ml";;

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

(* Problem 1: change *)
test "change 37" change 37 [1; 1; 0; 2];;
test "change 38" change 38 [1; 1; 0; 3];;
test "change 0" change 0 [0; 0; 0; 0];;
test "change 50" change 50 [2; 0; 0; 0];;


(* Problem 2: is_perm_123 *)
test "is_perm_123 [4]" is_perm_123 [4] false;;
test "is_perm_123 [123]" is_perm_123 [123] false;;
test "is_perm_123 [1;2;3]" is_perm_123 [1;2;3] true;;
test "is_perm_123 [3;2;3]" is_perm_123 [3;2;3] false;;
test "is_perm_123 [2;3;1]" is_perm_123 [2;3;1] true;;
test "is_perm_123 [-1]" is_perm_123 [-1] false;;

(* Problem 3: string_of_digit *)
test "string_of_digit 5" string_of_digit 5 "5";;

(* Problem 4: my_string_of_int *)
test "my_string_of_int 1234" my_string_of_int 1234 "1234";;
test "my_string_of_int 0" my_string_of_int 0 "0";;
test "my_string_of_int 1" my_string_of_int 1 "1";;
test "my_string_of_int -1" my_string_of_int (-1) "-1";;
test "my_string_of_int -2" my_string_of_int (-2) "-2";;
test "my_string_of_int -9" my_string_of_int (-9) "-9";;
test "my_string_of_int -10" my_string_of_int (-10) "-10";;
test "my_string_of_int 10" my_string_of_int 10 "10";;
test "my_string_of_int 100" my_string_of_int 100 "100";;
test "my_string_of_int 4231" my_string_of_int (4231) "4231";;
test "my_string_of_int 345231" my_string_of_int (345231) "345231";;
test "my_string_of_int -100" my_string_of_int (-100) "-100";;
test "my_string_of_int -50" my_string_of_int (-50) "-50";;
test "my_string_of_int -4231" my_string_of_int (-4231) "-4231";;
test "my_string_of_int -0" my_string_of_int (-0) "0";;
test "my_string_of_int 1234" my_string_of_int 1234 "1234";;

(* Problem 5: any *)
test "any [false;false;true;false]" any [false;false;true;false] true;;
test "any [false]" any [false] false;;
test "any [false;false;true;false;true]" any [false;false;true;false;true] true;;
test "any [true]" any [true] true;;
test "any [false;true]" any [false;true] true;;
test "any [false;false]" any [false;false] false;;
test "any [false;false;false;false;false;false]" any [false;false;false;false;false;false] false;;
test "any []" any [] false;;



(* Problem 6: all *)
test "all [true;true;true]" all [true;true;true] true;;
test "all [true]" all [true] true ;;
test "all [false]" all [false] false;;
test "all []" all [] true;;
test "all [true;true;true;true;true;true;true;true]" all [true;true;true;true;true;true;true;true] true;;
test "all [false;false;false;false]" all [false;false;false;false] false;;
test "all [false;true;false;true;false;true]" all [false;true;false;true;false;true] false ;;


(* Problem 7: add_last_2 *)
test "add_last_2 [1;2;3]" add_last_2 [1;2;3] [1;2;3;5];;
test "add_last_2 []" add_last_2 [] [];;
test "add_last_2 [1;2;3;10;11]" add_last_2 [1;2;3;10;11] [1;2;3;10;11;21];;
test "add_last_2 [0;0;0;0;0;0;0]" add_last_2 [0;0;0;0;0;0;0] [0;0;0;0;0;0;0;0];;
test "add_last_2 [1]" add_last_2 [1] [1;1];;

(* Problem 8: fibs *)
test "fibs 5" fibs 5 [0;1;1;2;3];;
test "fibs 1" fibs 1 [0];;
test "fibs 2" fibs 2 [0;1];;
test "fibs 3" fibs 3 [0;1;1];;
test "fibs 4" fibs 4 [0;1;1;2];;
test "fibs 6" fibs 6 [0;1;1;2;3;5];;
test "fibs 7" fibs 7 [0;1;1;2;3;5;8];;
