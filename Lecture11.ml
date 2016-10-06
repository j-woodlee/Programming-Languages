(*

Takeaways from HW4/HW5:
 - understand a language by implementing it.
 - Functional languages are really good at this:
  - OCaml's user-defined types are good for representing syntax.
  - Pattern matching, recursion are good for lots of operations on syntax


Last time:
  static scoping.
  - what does it mean?
  - each variable reference refers to its *nearest* enclosing definition
    in the source code.
  - what if there is no nearest enclosing definition?
    that's an unbound variable error.

  - let x = E1 in E2
      the definition "e = E1" encloses E2.

  - (fun x -> E)
      the formal parameter x encloses E.

  - To implement static scoping with functions, we use closures.
    A closure is the value of a function.
    It stores the environment from the time the function was evaluated
    The environment contains the statically-scoped bindings.
    We use it to evaluate the function body.  It gives values to variables in the function body.

    let x = 45 in
    let f = (fun y -> x + y) in
    f x

evaluates to (in 1 step):
  - evaluate the definition of x, extend the current environment,
    evaluate the body in the extended environment.

    let f = (fun y -> x + y) in  Current env: {x=45}
    f x

evaluates to:
  - value of f is the closure (fun y -> x + y){x=45}

    let x = 7 in current env: {f = (fun y -> x + y){x=45}, x = 45}
    f x

evaluates to:
    - evaluate the expression "f". The value must be a closure
      extract the environment from the closure
      extend it with the binding for the formal parameter
          "formal parameter : value of actual parameter"
      evaluate the body under the extended environment

    - value of f is (fun y -> x + y){x=45}
    - formal parameter is "y"
    - actual parameter is the value of "x" under {f = (fun y -> x + y){x=45}}
    - updated environment is {x=45,y=45}

    result is:
    x + y under {x=45,y=45}
After evaluating the function body, discard the extended environment

  result is:
  90
*)

(*
    Static scoping is required for passing arguments one-by-one,
    instead of all at once in a tuple.

    Name for passing arguments 1-by-1: Currying

    Named after Stephen Curry.
      Wait. I mean Haskell Curry. A famous logician.
      The programming language Haskell is named after him.

    environment: {}

    let add x y = x + y in
    let addTwo = add 2 in

Evaluates to:

    environment: {add = (fun x -> fun y -> x + y){}}

    let addTwo = add 2 in
    let x = 12 in
    addTwo x

Next: evaluate (add 2)
  1. evaluate "add" to the closure (fun x -> fun y -> x+y){}
  2. evaluate the actual parameter 2.
  3. extend the closure environment with formal=actual
  4. evaluate the function body under the extended environment
     (fun y -> x+y) under {x=2}
  5. the value is (fun y -> x+y){x=2}

Go back to evaluating the let. Extend the current environment
  {add = (fun x -> fun y -> x+y){}}
With the value of the definition of addTwo:
    Env: {add = (fun x -> fun y -> x + y){},
          addTwo = (fun y -> (x+y)){x=2}, x=12}
    addTwo x

  Evaluates to:
    1. Evaluate addTwo to the closure (fun y -> x + y){x=2}
    2. evaluate the actual parameter x to its value 12.
    3.extend the closure environment with formal = actual
    4. evaluate the function body under the extended environment
        ()
    5. the value is 14


Good exam questions:
 - trace the evaluation steps for an expression involving functions,
  let/in, etc.
 - what is a closure?
 - what is currying?
 - why does currying require static scoping?
 - why is steph curry so good?

 Consider the environment:

    Env: {add = (fun x -> fun y -> x +y){},
          addTwo = (fun y -> x+y){x=2},
          x=12}

We have two bindings for x.
One is currently in scope: x = 12
the other is out of scope in the current expression, but
in scope for the body of addTwo

So there is a concept of *lifetiime* of variable bindings.
- how long the binding is in scope somewhere

In this environment, x is out of scope, but still live.
      {add = (fun x -> fun y -> x+y){},
      addTwo = (fun y -> x+y){x=2}}

In this environment, x = 12 in in scope, x = 2 is out of scope, but live.

      {add = (fun x -> fun y -> x+y){},
        addTwo = (fun y -> x+y){x=2},
      x=12}

A variable definition (x = .. ) can be in scope oro out of scope.
A variable is in scope if it has a definition that is in scope.
A variable is live if it has a live definition.

Good exam questions:
- which variables are in scope after evaluating some expression?
- which are live?

let x = 1 in
let x = x+1 in
x

When we evaluate (x+1), x = 1 is live and in-scope
When we evaluate (x+2), x =2 is live and in-scope, x = 1 is dead and out of scope

let x = 1 in
let f = fun y -> x + y in
let x = x + 1 in
x+2

when we evaluate
*)
