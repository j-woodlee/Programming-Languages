(* Pattern Matching
  match E with
  | P1 -> E1
  | P2 -> E2
  | ...
  | Pn -> En

  1. evaluate E to some value, V
  2. match V against the patterns, in top to bottom order
  3. If V matches P1, then evaluate E1.  The value of E1 is the value of the whole thing. Otherwise,
    continue to the next pattern.
  4. If V matches no patterns, we get a pattern match error.  The match expression has no value.

  Patterns we've seen so far:

  P ::= _      (wildcard, matches every value)
      | []     (nil pattern, matches "nil" [])
      | P1::P2 (cons pattern, matches non-empy lists if the first element matches P1, and the rest of the list matches P2)
      | X  (variable name pattern, matches all values)
      | C  (constants)
  C ::= 0| 1 | 2 | 123 | ...
      | true | false
      | [] | ...

  X ::= <variable names>

Global vs Local let:
  let X = E;; is a global or top-level expression.
              can be used at the REPL, or in a file outside of any other expression.
              After 0 or more other top-level expressions.

  let X = E1 in E2
                  is a local expression (or just an expression).
                  can be used anywere an expression is expected
                  the binding of x is only available in (or local to) E2

Global expressions
                  G ::= let X = E;; (global let declaration)
                      | let X1 X2 = E;; (global function declaration)
                      | let rec X1 X2 = E;; (global recursive function declaration)
                      | #use "foo.ml";; (evaluate the file foo.ml)
                      | E;;
                      | G G   (sequence of global expressions)

(local expressions)
E ::= E OP E (binary operations)
    | E E    (function application)
    | C (constants)
    | X (variables)
    | match E1 with
      '|' P1 -> E1
      '|' P2 -> E2
      '|' ...
      '|' Pn -> En
    | []
    | let X = E1 in E2
    | if E1 then E2 else E3


OP ::= + | - | * | / | mod | ^ | ...


*)

match 5+7 with
| x -> x*x;;

let x = 5+7 in x*x;;

let (x::y::z::[]) = [1;2;3] in x+y+z;;

let [x;y;z] = [1;2;3] in x+y+z;;


let y = (let x = 5+7 in x+3)


(*
Write a function that returns every other element of a list.
    everyOther [1;2;3;4;5] = [1;3;5]

*)

(*OCaml's type "int list" is analogous to Java's "List<Integer>"
  A list of integer values.
*)

let rec everyOther (l : int list) : int list =
  match l with
  | [] -> []
  | (hd::[]) (* [hd] *) -> (hd::[]) (* l, [hd] *)
  | (x::_::tl) -> x::everyOther tl
;;


(*another common data type: tuples
*)

let tup = (1, "hi", 2.0, 4+5);;

(*
tuples are sequences of values like lists.

lists have unbounded size and fixed element type
tuples have bounded size and unfixed element type
*)
