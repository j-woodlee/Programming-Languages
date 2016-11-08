(*

OCaml prefers recursion to loops.

*)

let rec fact n =
    if n = 0
    then 1
    else let m = fact (n-1) in n*m
;;

(*

Evaluation of (fact 3)

fact 3            {}
  fact (n-1)      {n=3}
    fact (n-1)    {n=2}
      fact (n-1)  {n=1}
        fact (n-1){n=0}
          1
        n*m
      n*m
    n*m
  n*m

Evaluator maintains a *stack* of environments.
- Each call pushes a new environment for that call onto the stack.
- Each let/in pushes a new environment for the "in" expression.
- Return from a call or let/in, we pop the top environment off the stack.

fact 3                  [{}] <---- stack of environments
  PUSH {n=3}            [{n=3},{}]
  fact (n-1)
    PUSH {n=2}          [{n=2},{n=3},{}]
      fact (n-1)
        PUSH {n=1}      [{n=1},{n=2},{n=3},{}]
          fact (n-1)
            PUSH {n=1}      [{n=0},{n=1},{n=2},{n=3},{}]
            1
            POP (fact 0)   [{n=1},{n=2},{n=3},{}]
          PUSH {n=1,m=1}   [{n=1,m=1},{n=1},{n=2},{n=3},{}]
          n*m --> 1
          POP (let m)
          POP (fact 1)     [{n=2}, {n=3},{}]
        PUSH {n=2,m=1 }    [{n=2,m=1},{n=2},{n=3},{}]
        n*m --> 2
        POP (let m)
        POP (fact 2)       [{n=3},{}]
    PUSH {n=3,m=2}          [{n=3,m=2},{n=3},{}]
    n*m --> 6
    POP (let m)
    POP (fact 3)            [{}]


- Multiple calls to fact are *active* at the same time.
- eEach call has its own value of *n*
- We need to remember all the things that are different between the active
  calls to fact.
- the *call stack* contains an *activation record* for each *active*
  call that holds the stuff.

C/C++:

int fact(int n) {
    int m = 0;
    if (n==0)
        return 1;
    else {
      m = fact(n-1)
      return n*m;
      }
}

- Similar situation.
- C/C++ have a call stack and activation records too!
- local variables.
  scope: function body.
  lifetime: is until the activation record is popped from the stack.

How big will the stack get to evaluat fact(1000)?
  1001
  Space usage is linear in n.
  Uses a lot of stack space, a limited resource.

A more space-efficient way: loops!

int fact(int n) {
    int result = 1
    while(n>0) {
      result = result * n;
      n = n-1;
    }
    return result;
}

Just 1 activation record now. Regardless of n.
  Constant space usage.

Order of multiplications
  recursive: n * ((n-1) * ((n-2 * ...1)))
  iterative: ((1*n) * (n-1)) * ...

It seems that loops are more space-efficient than recursion.
  - Does that mean imperative programming is more efficient than FP?
*)

let rec fact (r,n) =
    if n = 0
    then r
    else fact (r*n, n-1)
;;

(*

fact (1,3)                    [{}]
PUSH {r=1,n=3}                [{r=1,n=3},{}]
fact(3,2)
PUSH {r=3,n=2}                [{r=3,n=2},{r=1, n=3}, {}]
fact(6,1)
PUSH {r=6,n=1}                [{n=6,n=1},{r=3,n=2},{r=1, n=3}, {}]
fact(6,0)
PUSH {r=6,n=0}                [{n=6,n=0},{n=6,n=1},{r=3,n=2},{r=1, n=3}, {}]
6
POP fact (6,0)
POP fact (6,1)
POP fact (3,2)
POP fact (1,3)

Notice: all the POPs are in a row at the end.
When we make the recursive call, the caller is done.
We can reorder the pushes and pops.

fact(1,3)                     [{}]
PUSH {r=1,n=3}                [{r=1},{n=3},{}]
fact(3,2)
POP fact(1,3)                 [{}]
PUSH {r=3,n=2}                [{r=3,n=2}, {}]
fact(6,1)
POP fact(3,2)
PUSH {r=6,n=1}                [{r=6,n=1},{}]
fact(6,0)
POP
PUSH {r=6,n=0}                [{r=6,n=0},{}]
6
POP fact(6,0)                 [{}]

- This version of fact is *tail recursive*
- A recursive call is called a *tail call* if the caller
  returns the result of the recursive call directly.
- A function is tail recursive if all recursive calls are tail calls.
- This reordering of the pushes and pops is called *tail call optimization*
- Execute a tail recursive function as if it were a loop.
  - In constant amount of stack space.



 *)


 let rec sumList (l : int list) : int =
    match l with
    | [] -> 0
    | x::xs -> x + sumList xs
;;

(*
Is sumList tail recursive?
No.

How can we make it TR?

- Add an accumulator argument

 *)

 let rec sumListTR (sum : int) (l : int list) : int =
      match l with
      | [] -> sum
      | x::xs -> sumListTR (x + sum) (xs)
 ;;


(* DiffList

  diffList [a;b;c;d] = ((a-b) - c) - d

 *)

 let rec diffList (l : int list) : int =
      match l with
      | [] -> 0
      | [x] -> x
      | x::y::xs -> diffList ((x-y)::xs)
;;

(*
Is this tail-recursive?
Yes

Don't always need an extra argument to achieve TR.

List.fold_right is not tail-recursive
List.fold_left is tail-recursive

  *)
