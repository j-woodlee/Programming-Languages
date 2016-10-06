(* ==================== HERE BE DRAGONS ====================

   This file defines a simple testing framework that you can use to
   test your programs. You don't need to understand any of this code
   to complete your homework.

 *)

(* load the homework *)
#use "hw5.ml";;
  
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

test
  "eval [(\"y\", VBool false)] (Fun (\"x\", BinOp (Var \"x\", Plus, Int 1))) \n"
  (fun () ->
   eval [("y", VBool false)] (Fun ("x", BinOp (Var "x", Plus, Int 1))))
  (Some (VClosure ("x", BinOp (Var "x", Plus, Int 1), [("y", VBool false)])))
;;

test  
  ("eval [] (LetIn (\"f\", Fun (\"x\", Var \"y\"), \n" ^
   "          LetIn (\"y\", Int 1,\n" ^
   "           FunApp (Var \"f\", Var \"y\"))))\n")
  (fun () ->
   eval [] (LetIn ("f", Fun ("x", Var "y"), 
             LetIn ("y", Int 1,
              FunApp (Var "f", Var "y")))))
  None
;;
  
test ("eval [] \n" ^
      " (LetIn (\"x\", Int 1,\n" ^
      "   LetIn (\"y\", BinOp (Var \"x\", Plus, Int 1),\n" ^
      "   LetIn (\"z\", LetIn (\"x\", BinOp(Var \"x\", Plus, Var \"y\"), BinOp(Var \"x\", Plus, Int 1)), \n" ^
      "     BinOp (BinOp (Var \"x\", Plus, Var \"y\"), Plus, Var \"z\")))))\n")
     (fun () ->
      eval [] 
       (LetIn ("x", Int 1,
         LetIn ("y", BinOp (Var "x", Plus, Int 1),
          LetIn ("z", LetIn ("x", BinOp(Var "x", Plus, Var "y"), BinOp(Var "x", Plus, Int 1)),
                 BinOp (BinOp (Var "x", Plus, Var "y"), Plus, Var "z"))))))
     (Some (VInt 7))
;;
  
test
  ("eval []\n " ^
   " (LetIn (\"x\", Int 1, \n" ^
   "   LetIn (\"f\", Fun (\"y\", BinOp (Var \"x\", Plus, Var \"y\")), \n" ^
   "    LetIn (\"x\", Int 2, \n" ^
   "     FunApp (Var \"f\", Var \"x\"))))) \n")
  (fun () ->
   eval []
    (LetIn ("x", Int 1,
      LetIn ("f", Fun ("y", BinOp (Var "x", Plus, Var "y")),
       LetIn ("x", Int 2,
        FunApp (Var "f", Var "x"))))))
  (Some (VInt 3))
;;

test
  ("eval []" ^
   " (LetIn (\"f\", Fun (\"x\", Fun (\"y\", BinOp (Var \"x\", Plus, Var \"y\"))), \n" ^
   "   LetIn (\"add1\", LetIn (\"x\", Int 1, FunApp (Var \"f\", Var \"x\")), \n " ^
   "    LetIn (\"x\", Int 2, " ^
   "     FunApp (Var \"add1\", Var \"x\")))))\n")
  (fun () ->
   eval []
     (LetIn ("f", Fun ("x", Fun ("y", BinOp (Var "x", Plus, Var "y"))),
       LetIn ("add1", LetIn ("x", Int 1, FunApp (Var "f", Var "x")),
        LetIn ("x", Int 2,
         FunApp (Var "add1", Var "x")))))) 
  (Some (VInt 3))
;;   

test
  "eval [] (FunApp (Int 5, Int 7))\n"
  (fun () -> eval [] (FunApp (Int 5, Int 7)))
  None
;;
  
test
  "eval [] (FunApp (Var \"f\", Int 5))\n"
  (fun () ->
   eval [] (FunApp (Var "f", Int 5)))
  None
;;  

test
  ("eval [] (LetIn (\"x\", LetIn (\"y\", Int 1, BinOp (Var \"y\", Plus, Int 1)), \n" ^
   "         BinOp (Var \"x\", Plus, Var \"y\")))\n")
  (fun () ->
   eval [] (LetIn ("x", LetIn ("y", Int 1, BinOp (Var "y", Plus, Int 1)),
            BinOp (Var "x", Plus, Var "y"))))
  None     
 
