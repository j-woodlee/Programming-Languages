(* ==================== HERE BE DRAGONS ====================

   This file defines a simple testing framework that you can use to
   test your programs. You don't need to understand any of this code
   to complete your homework.

 *)

(* load the homework *)
#use "hw4.ml";;

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

(* Problem 1 *)
test ("let dct = put \"hello\" 5 [] in \n" ^
      "let dct = put \"hi\" 7 dct in \n" ^
      "[get \"hello\" dct; get \"hi\" dct; get \"hey\" dct])")
     (fun () ->
      let dct = put "hello" 5 [] in
      let dct = put "hi" 7 dct in
      [get "hello" dct; get "hi" dct; get "hey" dct])
     [Some 5; Some 7; None]
;;

test ("let dct = put \"hello\" 5 [] in \n" ^
      "let dct = put \"hi\" 7 dct in \n" ^
      "[get \"hello\" dct; get \"hi\" dct; get \"hey\" dct])")
     (fun () ->
      let dct = put "hello" 0 [] in
      let dct = put "hi" 1 dct in
      [get "hello" dct; get "hi" dct; get "hey" dct])
     [Some 0; Some 1; None]
;;

(* Problem 2 *)
test "var_names (Int 5)" (fun () -> var_names (Int 5)) [];;
test "var_names (BinOp (Var \"x\", Plus, Var \"y\"))"
     (fun () -> var_names (BinOp (Var "x", Plus, Var "y")))
     ["x";"y"];;
test "var_names (IfThenElse (Var \"x\", Var \"y\", Var \"x\"))"
     (fun () -> var_names (IfThenElse (Var "x", Var "y", Var "x")))
     ["x";"y";"x"];;

test "undeclared_names (Decl (\"x\", Int 5, Expr (Var \"x\")))"
     (fun () -> undeclared_names (Decl ("x", Int 5, Expr (Var "x"))))
     [];;
test "undeclared_names (Decl (\"x\", Int 5, Expr (Var \"y\")))"
     (fun () -> undeclared_names (Decl ("x", Int 5, Expr (Var "y"))))
     ["y"];;
test "undeclared_names (Decl (\"x\", Var \"x\", Expr (Var \"x\")))"
     (fun () -> undeclared_names (Decl ("x", Var "x", Expr (Var "x"))))
     ["x"];;

(* Problem 3 *)
test "ocaml_of_expr (BinOp (Var \"x\", Plus, Int 5))"
     (fun () -> ocaml_of_expr (BinOp (Var "x", Plus, Int 5)))
     "(x + 5)";;
test "ocaml_of_expr (IfThenElse (Bool true, Var \"x\", Var \"y\"))"
     (fun () -> ocaml_of_expr (IfThenElse (Bool true, Var "x", Var "y")))
     "if true then x else y";;

test "ocaml_of_pgm (Decl (\"x\", Int 5, Expr (Var \"x\")))"
     (fun () -> ocaml_of_pgm (Decl ("x", Int 5, Expr (Var "x"))))
     "let x = 5 in x";;

(* Problem 4 *)
test "tc_expr [] (Int 5)"
     (fun () -> tc_expr [] (Int 5))
     (Some TyInt);;
test "tc_expr [(\"x\",TyInt)] (Var \"x\")"
     (fun () -> tc_expr [("x",TyInt)] (Var "x"))
     (Some TyInt);;
test "tc_expr [] (Var \"x\")"
     (fun () -> tc_expr [] (Var "x"))
     None;;
test "tc_expr [(\"x\",TyInt)] (IfThenElse (BinOp (Int 4, Eq, Var \"x\"), Var \"x\", Int 5))"
     (fun () -> tc_expr [("x",TyInt)] (IfThenElse (BinOp (Int 4, Eq, Var "x"), Var "x", Int 5)))
     (Some TyInt);;

test "tc_expr [(\"x\",TyInt)] (IfThenElse (BinOp (Int 4, Eq, Var \"x\"), Var \"x\", Int 5))"
    (fun () -> tc_expr [("x",TyInt)] (BinOp (Var "x", Eq, Int 5)))
    (Some TyBool);;

test "tc_pgm [] (Decl (\"x\", Int 5, Expr (Var \"x\")))"
     (fun () -> tc_pgm [] (Decl ("x", Int 5, Expr (Var "x"))))
     true;;
test "tc_pgm [] (Decl (\"x\", Int 5, Expr (Var \"y\")))"
     (fun () -> tc_pgm [] (Decl ("x", Int 5, Expr (Var "y"))))
     false;;

(* Problem 5 *)
test "eval_expr [] (BinOp (Int 5, Plus, Int 7))"
     (fun () -> eval_expr [] (BinOp (Int 5, Plus, Int 7)))
     (Some (VInt 12));;
test "eval_expr [(\"x\", VBool true)] (IfThenElse (Var \"x\", Int 1, Int 0))"
     (fun () -> eval_expr [("x", VBool true)] (IfThenElse (Var "x", Int 1, Int 0)))
     (Some (VInt 1));;
test "eval_expr [(\"x\", VBool true)] (IfThenElse (Var \"x\", Int 1, Int 0))"
    (fun () -> eval_expr [("x", VBool false)] (IfThenElse (Var "x", Int 1, Int 0)))
    (Some (VInt 0));;
test "eval_expr [(\"x\", VBool true)] (IfThenElse (Var \"x\", Int 1, Int 0))"
    (fun () -> eval_expr [] (IfThenElse (Var "x", Int 1, Int 0)))
    (None);;
test "eval_expr [(\"x\", VBool true)] (IfThenElse (Var \"x\", Int 1, Int 0))"
    (fun () -> eval_expr [("allen",VInt 69)] (IfThenElse (Var "allen", Int 1, Int 0)))
    (None);;

test "eval_pgm [] (Decl (\"x\", Int 5, Expr (BinOp (Var \"x\", Plus, Var \"x\"))))"
     (fun () -> eval_pgm [] (Decl ("x", Int 5, Expr (BinOp (Var "x", Plus, Var "x")))))
     (Some ([("x", VInt 5)], VInt 10));;
test "eval_pgm [] (Decl (\"x\", Int 5, Expr (BinOp (Var \"x\", Plus, Var \"x\"))))"
    (fun () -> eval_pgm [] (Decl ("x", Int (-1), Expr (BinOp (Var "x", Plus, Var "x")))))
    (Some ([("x", VInt (-1))], VInt (-2)));;
test "eval_pgm [] (Decl (\"x\", Int 5, Expr (BinOp (Var \"x\", Plus, Var \"x\"))))"
    (fun () -> eval_pgm [] (Expr (BinOp (Var "x", Plus, Var "x"))))
    (None);;
