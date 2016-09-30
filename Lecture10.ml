(* hw4
Problem 1:
all I'll test is the behavior of get/put.
- if no puts for a key, get should return None.
- if some puts for a key, get should return some value.
  The most recent value put for that key.

eval_expr:
    helper function:
      let perform_binop (v1:value) (o:op) (v2:value) : value =
      let perform_ifThenElse (condition:value) (then:expr) (else:expr) : value =
    Errors in eval_expr: value option.
    - undefined variable
    - condition evaluates to a VInt
    - binop gets a VBool operand.
 *)

 (* Scope
    {}   //empty environment
    {x=32, y="hello"} environment with bindings for x, y.

    Evaluation
      let y=4 in y*2  {}  Decl("y",Int 4, Expr(BinOp(Var "y", Mult, Int 2)))
      y*2 {y=8}
      8*2
      16

  Variables refer to the nearest enclosing definition. (Static Scoping)
  Ex:
  *)
  let x = 34 in
    let y = x + 1 in
      let x = x + 32 in
        x+y
;;
(* Which definition does each use refer to?
Ex:
 *)

 let x = 12 in
  let y = (let x = x+1 in x+2) in
    x+y
;;


(* To evaluate a let x = ... in ...
    1) evaluate the definition under the current environment
    2) new environment = extend current with a binding for x
    3) evaluate the body under the new environment
    *)
(* let x = 12 in
  let y = let x = x + 1 in x + 2 in        (* {} *)
  x + y
;;

let y = (let x = x + 1 in x + 2) in   (*  {x = 12} *)
  x + y


let x = x + 1 in x + 2 *)


let x = 45;;
let f y = x + y;;
f 3;; (* 48 *)
let x = 12;;
x;; (* 12 *)
f 3;; (* 48 *)


(*

  let x = 45;; {x=45}
  let f y = x + y;; {x = 45, f = (fun y -> x+y){x=45}}
  The value of the function is itself, paired with the current environment(at the time of its evaluation)
  To evaluate the function application:
    1) evaluate the function. Better be a function value. -> (fun x -> e, fenv)
    2) evaluate the argument. -> v (the actual parameter)
    3) extend fenv with the binding  of its formal parameter (name) bound to v. -> fenv'
    4) evaluate the function body e under fenv'

  x+y {x=45, y=3}

  let x = 12;;
  f 3 {x = 12, f = (fun y->x+y){x=45}}




  *)
