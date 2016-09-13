(* Name:
   Email:
   Student ID:

   Others With Whom I Discussed Things:

   Other Resources I Consulted:

*)

exception TODO;;

(* READ THIS FIRST!

   For this homework you will implement more recursive functions, this
   time with multiple arguments, helper functions, and higher-order
   functions.

   Similar story to homework 1. Replace "raise TODO" in each problem
   with an OCaml expression. Use the testing script hw2-tester.ml to
   test your solutions. You should do more testing, as I will use
   additional test cases for grading.

   You can run `ocaml hw2-tester.ml` now (everything will be marked
   TODO).  I recommend you TEST EARLY AND OFTEN as you work on each
   problem.

   Homeworks should be completed individually. Do not show your code
   to another student, or look at another student's code. You may
   discuss the problems at a conceptual level (independently of OCaml
   particulars) with another student, or discuss OCaml particulars
   independently of particular homework problems. If you get stuck,
   email me or come to office hours.

 *)


(* Problem 1

   Write a recursive function intsFromTo of type (int,int) -> int
   list. intsFromTo (m,n) should return the integers between m and n
   (inclusive).

   Example:
     # intsFromTo (-1,3)
     - : int list = [-1;0;1;2;3]
 *)

let rec intsFromTo ((m,n) : int * int) : int list =
  raise TODO
;;

(* Problem 2

   Write a recursive function to get the number of occurrences of an
   element in a list.

   Examples:
     # count (5,[1;2;3])
     - : int = 0
     # count (5,[1;5;5;0])
     - : int = 2
 *)

let rec count ((v,l) : ('a * 'a list)) : int =
  raise TODO
;;

(* Problem 3

   Write a recursive function that appends one list to the front of
   another.  Note: ocaml has a built-in operator @ that does
   this. Don't use it. :)

   Example:
     append ([1;2;3],[4;5;6]) = [1;2;3;4;5;6]

 *)

let rec append ((l1,l2) : ('a list * 'a list)) : 'a list =
  raise TODO
;;

(* Problem 4
   Use append or @ to write a recursive function that reverses the elements
   in a list.

   Example:
     # reverse [1;2;3;4]
     - : int list = [4;3;2;1]
 *)

let rec reverse (l : 'a list) : 'a list =
  raise TODO
;;

(* Problem 5

   Due to all the calls to append, the naive algorithm for reversing a
   list takes time that is quadratic in the size of the argument list.
   In this problem, you will implement a more efficient algorithm for
   reversing a list: your solution should only take linear time. Call
   this function fastRev. The key to fastRev is that it builds the
   reversed list as we recurse over the input list, rather than as we
   return from each recursive call.  This is similar to how an
   iterative version of list reversal, as implemented in a language
   like C, would naturally work.

   To get the right behavior, your fastRev function should use a local
   helper function revHelper to do most of the work.  The helper
   function should take two arguments: (1) the suffix of the input
   list that remains to be reversed; (2) the reversal of the first
   part of the input list.  The helper function should return the
   complete reversed list.  Therefore the reversal of an input list l
   can be performed via the invocation revHelper(l, []).  I've already
   provided this setup for you, so all you have to do is provide the
   implementation of revHelper (which is defined as a nested function
   within fastRev) and invoke it as listed above.  The call (fastRev
   (intsFromTo(0, 10000))) should be noticeably faster than (reverse
   (intsFromTo(0, 10000))).

   Example:
     # fastRev [1;2;3;4]
     - : int list = [4;3;2;1]

 *)

let fastRev (l : 'a list) : 'a list =
  let rec revHelper (remain, sofar) =
    raise TODO
  in revHelper(l, [])
;;

(* Problem 6

   Implement insertion sort for lists of integers. The key is to use
   the helper function insert, which takes an integer and a sorted
   list of integers and "inserts" the int into the correct position of
   the list. The word "insert" implies that we're mutating the list,
   which is impossible in OCaml. Instead, insert returns a new list.

   Example:
     insert (3,[1;2;4;5]) = [1;2;3;4;5]

     insort [3;2;5;1;4] = [1;2;3;4;5]

 *)

let rec insort (l : int list) : int list =
  let rec insert(e,l) =
    raise TODO
  in
    raise TODO
;;

(* Problem 7

   Write a higher-order function splitBy that splits a list of
   elements into two lists. It uses an input function to determine
   which of the two result lists each element should be included in.
   If the function returns true for the element, it should be included
   in the first list. Otherwise it should be included in the second
   list. The order of elements in the result lists should be the same
   as in the input list. So if element x comes before element y in the
   input list, and they are in the same result list, then x should
   come before y in the result list.

   Example:
     # let pos x = x >= 0 in
       splitBy (pos, [1;2;-3;-4;5])
     - : int list * int list = ([1;2;5], [-3;-4])
 *)


let rec splitBy ((f,l) : ('a -> bool) * ('a list)) : ('a list * 'a list) =
  raise TODO
;;


(* Problem 8

   Define a function update that takes four arguments: a list, the
   index of an element in that list to be updated, a function used to
   update that element, and a default value. The default value is used
   when there is no element for the index (i.e. the length of the list
   is less than or equal to the index).

   Examples:
     # let add1 x = x + 1 in
       update ([1;2;3], 0, add1, 0)
     - : int list = [2;2;3]

     # let add1 x = x + 1 in
       update ([1;2;3], 4, add1, 0)
     - : int list = [1;2;3;0;1]

   In the first example, we use add1 to increment the first element of
   the list (index 0). In the second example, we want to increment the
   fifth element (index 4), but the list only has 3 elements. So we
   extend the list with two default elements, and then increment the
   last element.

 *)

let rec update ((l,n,f,default) : 'a list * int * ('a -> 'a) * 'a) =
  raise TODO
;;

(* Problem 9

   Use update to generalize splitBy to return an arbitrary number of
   lists (instead of just two) -- i.e. a list of list. This time the
   function will return a positive integer instead of a boolean. That
   integer indicates which list that element should be included in. As
   in the previous problem, the order of elements within the result
   lists should be preserved.

   Example:
     let mod3 x = x mod 3 in
     partitionBy (mod3, [2;3;5;0;2]) = [[3;0]; []; [2;5;2]]

   The number of lists you return should be one more that the maximum
   value of the input function on the elements of the input list. In
   the example above, the maximum value of mod3 on [2;3;5;0;2] is 2,
   so the result list has 3 elements.

   Example:
     let mod10 x = x mod 10 in
     partitionBy (mod10, [2;3;5;0;2]) = [[0]; []; [2;2]; [3]; []; [5]]

   In this example, the maximum value of mod10 on [2;3;5;0;2] is 5, so
   partitionBy returns 6 lists. Note the empty lists for indices 1 and
   4, which are not returned by mod10 for any of its inputs.

 *)

let rec partitionBy ((f,l) : ('a -> int) * ('a list)) : ('a list) list =
  raise TODO
;;
