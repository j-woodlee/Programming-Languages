(*
HW1 Due friday 9/9
Office: Doolan 220
REPL: Good for programming on the fly

Pattern Matching:
*)

let rec factorial n =
  if n = 0
  then 1
  else n * factorial (n-1);;

let rec factorialMatch n =
    match n with
    | 0 -> 1
    | _ -> n * factorialMatch (n-1)
;;

(*

Patterns:
  P ::= num | _

Pattern Matching is "good style" in ocaml
- preferred to if-then-else
- declarative: focus on "what" (the pattern) over
  "how" (how to match)
- match expressions are easier to read and understand
- the interpereter can do fancy static analysis
    static analysis: any checking of the program before it is run

not is a built in function
*)


let not1 b = if b then false else true;;

let not2 b =
    match b with
    | true -> false
    | false -> true
;;

let not3 b = not b;;

let rec parity n =
    match n with
    | 0 -> "even"
    | 1 -> "odd"
    | _ -> parity (n-2)
;;

(*Lists
  In imperative languages, arrays are the most commonly used built-in data structure.  They play well with loops.

  Instead of arrays, we're going to use lists in OCaml since
  Lists play well with recursion
  Lists are defined by induction.contents
  - base case: empy list []
  - inductive case: "cons" operator E1::E2
  *)
let l0 = [];;
let l1 = 1::l0;;
[1;2;3];;
["hi"; "bytes"];;
l0;;
let x = [4;5];;
let y = (1+2)::x;;


let rec sumList lst =
    match lst with
    | [] -> 0 (* lst = [] *)
    | hd::tl -> hd + sumList(tl) (*arbitrary names*) (* lst = hd::tl *)
;;

(*
Three new kinds of pattern:

nil pattern []
cons pattern P1::P2
variable/name pattern
  hd, tl

nil pattern matches one value: []

cons pattern matches P1::P2 matches _any_ cons
cell V1::V2 (V1 and V2 are values), if
P1 matches V1 and P2 matches V2

variable/name pattern matches any value (just like _)
AND it assigns that name to the

*)

let is123 lst =
    match lst with
    | 1::(2::(3::[])) -> true
    | _ -> false
;;

(*
is123 (1::(2::(3::(4::[]))));;

1. is (1::(2::(3::(4::[])))) a cons value?
2. match 1 and 1. matches
3. match (2::(3::(4::[]))) with (1::(2::(3::[]))) etc.

*)
