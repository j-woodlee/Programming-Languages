/* Name: Jake Woodlee

   UID: 962385088

   Others With Whom I Discussed Things:

   Other Resources I Consulted:

*/

/* Rules and advice:

   Your code should never go into an infinite loop.

   Your code need not produce solutions in a particular order, as long
   as it produces all and only correct solutions and produces each
   solution the right number of times.

   Some of these problems are computationally hard (e.g.,
   NP-complete).  For such problems especially, the order in which you
   put subgoals in a rule can make a big difference on running time.
   In general the best strategy is to put the STRONGEST CONSTRAINTS
   EARLIEST, i.e., the constraints that will prune the search space
   the most.

   Use the hw8-tests.pl file to test! Write more tests!
   $ swipl < hw8-tests.pl
 */

/* Problem 1

Define a predicate duplist(L1,L2) that is true if L2 contains every
two copies of each element of L1.

Examples:
$- duplist([1,2,3], [1,1,2,2,3,3]).
true.

$- duplist([a,b,c], X).
X = [a, a, b, b, c, c].

?- duplist(X, [a,a,a,a,c,c,c,c]).
X = [a, a, c, c].
*/

duplist([],[]).
duplist([Hd|Tl1],[Hd,Hd|Tl2]) :- duplist(Tl1,Tl2).


/* Problem 2

Define a predicate sorted(L) that is true if L a list of numbers in
increasing order.

Use the less-than-or-equal predicate  =<  (note the weird order).

?- 1 =< 2.
true.
?- 2 =< 1.
false.

Do not use any other built-in predicates!

?- sorted([1,2,3,4,5]).
true.

?- sorted([1,3,2,4,5]).
false.

*/

sorted([]).
sorted([_]).
sorted([Hd1,Hd2|Tl]) :- Hd1 =< Hd2, sorted([Hd2|Tl]).

/* Problem 3

Define a predicate perm(L1,L2) that is true if L2 is a permutation of L1.

Use the predicate select(X,L1,L2) that is true if L2 can be obtained
by removing one occurrence of X from L1.

$- select(1, [1,2,3], [2,3]).
true.

?- select(1, [1,2,1,3], [1,2,3]).
true.

Hint: By running select backwards, we can insert 1 into different
positions of [a,b,c]:

?- select(1, X, [a,b,c]).
X = [1, a, b, c] ;
X = [a, 1, b, c] ;
X = [a, b, 1, c] ;
X = [a, b, c, 1] ;
false.

Use sorted and perm to define a predicate permsort(L1,L2) that
is true if L2 is a sorted permutation of L1.

?- permsort([3,2,5,1,4], L).
L = [1,2,3,4,5] ;
false.

*/

perm([],[]).
perm([Hd|Tl],L) :- perm(Tl,X), select(Hd,L,X).
permsort(L1,L2) :- perm(L1,L2), sorted(L2).

/* Problem 4

Define a predicate insert(X,L1,L2) that inserts X into the list L1
(assumed to be sorted), with L2 being the resulting list (which should
also be sorted). You do not have to check that L1 or L2 are sorted.
  Do not use any predicates other than =< or >.

Definite another version of insert called insertV2. They should be
true for all the same inputs, but their implementations will be quite
different. insertV2 is true if L1 and L2 are sorted, and L2 contains
one more occurrence of X than L1.
  Use only the predicates sorted and select.

Define a predicate insort(L1,L2) that is true if L2 is a sorted
permutation of L1. Use only insert or insertV2.

*/

insert(X,[],[X]).
insert(X,[Hd1|Tl1],[X,Hd1|Tl1]) :- X =< Hd1.
insert(X,[Hd1|Tl1],[Hd1|Tl2]) :- X > Hd1, insert(X,Tl1,Tl2).

insertV2(X,_,L2) :- select(X,LNew,L2), sorted(LNew), sorted(L2).


insort([],[]).
insort([Hd1|Tl1],L1) :- insort(Tl1,L2), insert(Hd1,L2,L1).


/* Problem 5

Compare the time it takes prolog to find 1 solution for each of:

?- permsort([5,3,6,2,7,4,5,4,1,2,8,6],L).

vs

?- insort([5,3,6,2,7,4,5,4,1,2,8,6],L).

Which is faster? Why?

Insort is much faster.  Permsort creates all the permutations of a list and then sorts it, whereas insort
builds a sorted list from an empty list.  So permsort has to build tons of lists, whereas insort only has to build one.

*/




/* Problem 6

In this problem, you will write a Prolog program to solve a form of
the "blocks world" problem, which is a famous planning problem from
artificial intelligence.  Imagine you have three stacks of blocks in a
particular configuration, and the goal is to move blocks around so
that the three stacks end up in some other configuration.  You have a
robot that knows how to do two kinds of actions.  First, the robot can
pick up the top block from a stack, as long as that stack is nonempty
and the robot's mechanical hand is free.  Second, the robot can place
a block from its hand on to a stack.

Implement a predicate blocksworld(Start, Actions, Goal). Start and
Goal describe configurations (states) of the world, and Actions is a
list of actions. blocksworld(Start, Actions, Goal) should be true if
the robot can move from the Start state to the Goal state by following
the list of Actions.

We will represent blocks as single-letter atoms like a,b,c, etc.

We will represent a world as a relation world(S1,S2,S3,H) that has
four components: three lists of blocks S1, S2, and S2 that represent
the three stacks, and a component H that represents the contents of
the mechanical hand.  That last component H either contains a single
block or the atom none, to represent the fact that the hand is empty.

Some example configurations of the world:

  world([a,b,c],[],[d],none)
    - The first stack contains blocks a,b,c (a is at the top).
    - The second stack is empty.
    - The third stack contains the block d.
    - The hand is empty.

  world([],[],[],a)
    - The stacks are all empty.
    - The hand contains the block a.

There are two kinds of actions: pickup(S) and putdown(S). In each
action, S must be one of the atoms stack1, stack2, or stack3, which
identifies which stack to pickup from or putdown to. For example,
pickup(stack1) instructs the robot to pickup from stack1, and
putdown(stack2) instructs it to put down the currently held block on stack2.

First define a predicate perform(Start,Action,Goal), which defines the
effect of a single action on the configuration.  Use this to define
the predicate blocksworld(Start, Actions, Goal).

Once you've defined perform and blocksworld, you can ask for the
solutions:

?- length(Actions,L), blocksworld(world([a,b,c],[],[],none), Actions, world([],[],[a,b,c],none)).

Actions = [pickup(stack1),putdown(stack2),pickup(stack1),putdown(stack2),pickup(stack1),putdown(stack3),pickup(stack2),putdown(stack3),pickup(stack2),putdown(stack3)]
L = 10 ?

Notice how I use length to limit the size of the resulting list of
actions. The effect of this is that Prolog will search for a solution
consisting of 0 actions, then 1 action, then 2 actions, etc.  This is
necessary to do when you test your code, in order to prevent Prolog
from getting stuck down infinite paths (e.g., continually picking up
and putting down the same block).

*/

perform(world([Hd|Tl],S2,S3,none), pickup(stack1), world(Tl,S2,S3,Hd)).
perform(world(S1,[Hd|Tl],S3,none), pickup(stack2), world(S1,Tl,S3,Hd)).
perform(world(S1,S2,[Hd|Tl],none), pickup(stack3), world(S1,S2,Tl,Hd)).
perform(world(S1,S2,S3,Hd), putdown(stack1), world([Hd|S1],S2,S3,none)).
perform(world(S1,S2,S3,Hd), putdown(stack2), world(S1,[Hd|S2],S3,none)).
perform(world(S1,S2,S3,Hd), putdown(stack3), world(S1,S2,[Hd|S3],none)).

blocksworld(Start,[],Goal) :- Start = Goal.
blocksworld(Start,[Hd|Tl],Goal) :- perform(Start,Hd,Y),blocksworld(Y,Tl,Goal).


/* Problem 7

  Let's implement everyone's favorite data structure: dictionaries!
  We'll represent a dictionary as a list of pairs, where each pair is
  represented as a two-element list.

  Implement a predicate put(K,V,OldDict,NewDict) that is true if NewDict is
  the dictionary that results from mapping key K to value V in
  dictionary OldDict.

  If the key K is already mapped in OldDict, then put should
  (conceptually) replace it with the new key.  In other words, a
  dictionary should have at most one entry for a given key.

  The tests assume that new entries (for keys that were not in
  OldDict) will be the last element of NewDict.

  Also implement a predicate get(K,D,V) that succeeds if K is mapped
  to V in D.

  This being Prolog, these predicates are much cooler than the
  versions we implemented in other languages, because they can be used
  to answer a wide variety of queries.  For example, get can not only
  get the value associated with a key but also get all keys associated
  with a particular value and also iterate over all key-value pairs in
  the dictionary.  Some examples:

?- put(1,hello,[[2,two]],D).

D = [[2,two],[1,hello]] ?

?- put(1,hello,[[1,one],[2,two]],D).

D = [[1,hello],[2,two]] ?

?- put(1,hello,D,[[2,two],[1,hello]]).

D = [[2,two]] ? ;

D = [[2,two],[1,_]] ? ;

?- get(1,[[2,two],[1,hello]],V).

V = hello ?

?- get(K,[[2,hello],[1,hello]],hello).

K = 2 ? ;

K = 1 ? ;

?- get(K,[[2,two],[1,hello]],V).

K = 2
V = two ? ;

K = 1
V = hello ? ;

*/
put(K, V, [], [[K,V]]).
put(K, V, [[K,_]|D], [[K,V]|D]).
put(K, V, [[K0,V0]|D], [[K0,V0]|D0]) :- \+(K=K0), put(K, V, D, D0).

get(K, [[K,V]|_], V).
get(K,[[_,_]|D], V) :- get(K, D, V).




/* Problem 8

Implement a Prolog predicate eval(E,Env,V) that is true if the
expression E has value V under environment Env.  To represent
expressions we will use parse trees defined by the following grammar:

E ::= intconst(I) | boolconst(B) | var(X) |
      geq(E1,E2) | if(E1, E2, E3) |
      function(X, E) | funcall(E1, E2)

V ::= intval(I) | boolval(B) | funval(X,E,Env)

Being Prolog, you also get limited forms of other kinds of
functionality.  For example, you can give a program containing
variables and have Prolog find an appropriate environment for
evaluating it.  Or more interesting, you can give a result value and
have Prolog generate programs that will evaluate to that value!

The pattern is the same as in our other interpreters: always recursively
evaluate subexpressions first.

I've provided two cases for eval for you.

*/

eval(intconst(I), _, intval(I)).
eval(boolconst(B), _, boolval(B)).
eval(var(X),Env,V) :- get(X,Env,V).
eval(geq(E1,E2),Env,boolval(true)) :- eval(E1,Env,intval(I1)), eval(E2,Env,intval(I2)), I1 >= I2.
eval(geq(E1,E2),Env,boolval(false)) :- eval(E1,Env,intval(I1)), eval(E2,Env,intval(I2)), I1 < I2.
eval(if(E1,E2,E3),Env,V2) :- eval(E1,Env,boolval(true)), eval(E2,Env,V2).
eval(if(E1,E2,E3),Env,V3) :- eval(E1,Env,boolval(false)), eval(E3,Env,V3).
eval(function(X,E),Env,funval(X,E,Env)).
eval(funcall(E1,E2),Env,V) :- eval(E1,Env,funval(X,E,Env1)), eval(E2,Env,V2), put(X,V2,Env1,Env2), eval(E,Env2,V).
