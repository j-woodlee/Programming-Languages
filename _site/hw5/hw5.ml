(* Name: Jake Woodlee
   Email: jwoodlee@lion.lmu.edu
   Student ID: 962385088

   Others With Whom I Discussed Things:

   Other Resources I Consulted:

*)

exception TODO;;

(* Extending the calculator language from HW4 with functions and local
   variables. This will give you a better working knowledge of static
   scoping, by implementing it.

   Remember the rules of evaluation with static scoping:
     1) To evaluate a let/in, first evaluate the definition under
        the current environment, then extend the current environment
        with the new binding, then evaluate the body (after the in)
        under the extended environment.

     2) To evaluate a function, build a closure with the function's
        formal parameter (argument name), body, and the current
        environment.

     3) To evaluate a function application, evaluate the function to
        a closure. Then evaluate the actual parameter. Extend the closure's
        environment with a binding of the formal parameter to the actual
        parameter. Then evaluate the function body under the extended environment.

   Try to keep in mind how this implements static scoping. The idea is
   each variable expression refers to its *nearest enclosing*
   declaration. There are two cases:

     1) The declaration of a formal parameter of a function encloses the
        body of the function.

     2) The declaration of a let/in encloses its body (after the in).

   The evaluator maintains the following *invariant*: the environment
   contains a binding for the nearest enclosing declaration of each
   variable currently in scope.

   A function closure records the current environment, so that as we
   pass it around, it still has access to the correct bindings.

 *)

(* Dictionaries. I'll provide this for you. *)

type ('k, 'v) dict = ('k * 'v) list;;

(* This definition of put "shadows" any previous entry for the input
   key: it's still there, but the new entry will be returned.
 *)
let put k v d = (k,v)::d;;

let rec get k d =
  match d with
    [] -> None
  | (k',v)::_ when k = k' -> Some v
  | _::d' -> get k d'
;;

(* The operators are the same as in HW4. *)

type op = Plus | Minus | Times | Eq | Gt;;

(* We extended the expressions with local variables (let/in), functions,
   and function applications.

   Examples:

   |---------------------+-----------------------------------------------|
   | Expression          | Representation                                |
   |=====================+===============================================|
   | (fun x -> x + 1)    | Fun ("x", BinOp (Var "x", Plus, Int 1))       |
   |---------------------+-----------------------------------------------|
   | f x y               | FunApp(FunApp (Var "f", Var "x"), Var "y")   |
   |---------------------+-----------------------------------------------|
   | let x = 1 in x      | LetIn("x", Int 1, Var "x")                    |
   |---------------------+-----------------------------------------------|
 *)

type expr = Int of int
          | Bool of bool
          | Var of string
          | BinOp of (expr * op * expr)
          | IfThenElse of (expr * expr * expr)
          | LetIn of (string * expr * expr)
          | Fun of (string * expr)
          | FunApp of (expr * expr)

(* We have one new form of value: a function value or closure. It
   consists of the formal parameter (the name of the parameter), the
   function body (an expression), and the defining environment -- the
   current environment at the time when the evaluator created the closure.
 *)

type value = VInt of int
           | VBool of bool
           | VClosure of (string * expr * (string,value) dict);; (* why not put env here? *)

type env = (string,value) dict;;

(* Extend your expression evaluator from HW4 to handle local
   variables, functions and function applications.

   Examples:

   - OCaml : (fun x -> x + 1)

     eval [("y", VBool false)] (Fun ("x", BinOp (Var "x", Plus, Int 1)))
      = Some (VClosure ("x", BinOp (Var "x", Plus, Int 1), [("y", VBool false)]))

   - OCaml : (fun x -> x + 1) 2

     eval [] (FunApp (Fun ("x", BinOp (Var "x", Plus, Int 1)), Int 2)) = Some (VInt 3)

   - OCaml : let f = (fun x -> y) in            (* Error: y is not in scope *)
             let y = 1 in
             f y

     eval [] (LetIn ("f", Fun ("x", Var "y"),
               LetIn ("y", Int 1,
                FunApp (Var "f", Var "y"))))
      = None

   - OCaml : let x = 1 in
             let y = x + 1 in
             let z = let x = x + y in x + 1 in
             x + y + z

     eval []
       (LetIn ("x", Int 1,
         LetIn ("y", BinOp (Var "x", Plus, Int 1),
          LetIn ("z", LetIn ("x", BinOp(Var "x", Plus, Var "y"), BinOp(Var "x", Plus, Int 1)),
           BinOp (BinOp (Var "x", Plus, Var "y"), Plus, Var "z")))))
      = Some (VInt 7)

   - OCaml : let x = 1 in
             let f = fun y -> y + x in
             let x = 2 in
             f x

     eval []
       (LetIn ("x", Int 1,
         LetIn ("f", Fun ("y", BinOp (Var "x", Plus, Var "y")),
          LetIn ("x", Int 2,
           FunApp (Var "f", Var "x")))))
      = Some (VInt 3)

   - OCaml : let f = fun x -> fun y -> x + y in
             let add1 = (let x = 1 in f x) in
             let x = 2 in
             add1 x

     eval []
       (LetIn ("f", Fun ("x", Fun ("y", BinOp (Var "x", Plus, Var "y"))),
         LetIn ("add1", LetIn ("x", Int 1, FunApp (Var "f", Var "x")),
          LetIn ("x", Int 2,
           FunApp (Var "add1", Var "x")))))
      = Some (VInt 3)

   - OCaml : 5 7    (* Type error... trying to use 5 as a function. *)

     eval [] (FunApp (Int 5, Int 7)) = None

   - OCaml : f 5    (* Error: Unbound value f *)

     eval [] (FunApp (Var "f", Int 5)) = None

   - OCaml : let x = (let y = 1 in y + 1) in
             x + y                              (* Error: Unbound value y *)

     eval [] (LetIn ("x", LetIn ("y", Int 1, BinOp (Var "y", Plus, Int 1)),
              BinOp (Var "x", Plus, Var "y")))
      = None
 *)

let evalOp (i : int) (o : op) (j : int) : value =
  match o with
  | Plus -> VInt (i+j)
  | Minus -> VInt (i-j)
  | Times -> VInt (i*j)
  | Eq -> VBool (i=j)
  | Gt -> VBool (i>j)
;;

(* You should always evaluate subexpressions before matching on
   them. I've partially implemented one of the HW4 cases to give an
   example.
    *)

let rec eval (env : env) (e : expr) : value option =
  match e with
  | Int x -> Some (VInt x)
  | Bool x -> Some (VBool x)
  | Var x -> get x env
  | BinOp(e1,o,e2) ->
     (match (eval env e1, eval env e2) with
      | (Some (VInt i), Some (VInt j)) -> Some (evalOp i o j)
      | _                              -> None)
  | IfThenElse(e1,e2,e3) -> (match eval env e1 with
                             | Some(VBool x) -> if x then eval env e2 else eval env e3
                             | _ -> None)
  | LetIn(str,e1,e2) -> (match eval env e1 with
                         | Some v -> let env' = put str v env in
                                            eval env' e2
                         | None -> None)
  | Fun(str,e1) -> Some(VClosure(str,e1,env))
  | FunApp(e1,e2) -> (match eval env e1 with
                      | Some(VClosure(str,expr,enviro)) -> (match eval env e2 with
                                                          | Some(v) -> let env' = put str v enviro in
                                                                      eval env' expr
                                                          | _ -> None
                                                          )
                      | _ -> None
                      )
;;
