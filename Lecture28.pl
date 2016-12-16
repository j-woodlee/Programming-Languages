/*
How does prolog evaluate queries?

- Fundamental operation: unification.
    - Given two terms t1 and t2, find a *substitution*
        - a mapping from variables to terms
        - such that s(t1) == s(t2)
        - == means "structural equality"
        - the exact same terms syntactically
        - if this succeeds, then s is a *unifier* for t1 and t2.

Prolog's predicate t1 = t2 tests for *unifiability*

unify(X,X).
% unify(X,Y) :- X = Y.

Unification is the way that *all* computation is done in Prolog
- Except for arithmetic

Running a query is based on unification too.
    - e.g. append([1,2,3], [4,5], X)
    - unify with the head of each rule in the database
    - pass the first two terms in as parameters,
    - "return" the third term as the result.

Comma operator:
    logically *and*, but can be used as a sequence (;)
    can model assignment, but single assignment only
    X = 0, X = [1,2] fails.

Unification can deconstruct values, as in OCaml's pattern matching
    [X|Y] = [1,2,3] succeeds with X=1 and Y=[2,3]

Note: not always a *unique* unifier

?- f(X,Y) = f(a,Y).
X = a.

Y can be anything, and Prolog *could* assign some arbitrary value to it.

An important property that makes Prolog work is that
while there is not always a *unique* unifier, there is a
*best* one.
    - A *most general unifier* (MGU)
    - constrains the values as little as possible to get them to unify.
    - s is a MGU for t1 and t2 if any other substitution is more specific.

In the above example,
    [X = a, Y = 0] is more specific than [X=a]

*/

g(X,Y) :- f(X,Y) = f(a,Y), Y=1234

/*
Overall serach algorithm:
    Given a goal to be proven (initially the query).
        - Try to unify the goal with one of the rules.
        - If it succeeds, then replace the goal with the body (conditions)
          of the rule.
        - These conditions become (sub)goals
        - Continue recursively until all the goals have been proven.
*/


/*
Query: p(X).

Goals: [p(X)]

1) Try the first rule: p(f(Y)) = p(X)
    MGU = [X=f(Y)]
    new goals: [q(Y),r(Y)]

2) Need to prove q(Y). Try the second rule: q(h(Z)) = q(Y)
    MGU = [Y=h(Z)]
    new goals: [t(Z), r(h(Z))]
        - note that we substituted for Y in the goal list!

3) Need to prove t(Z). Try the last rule: t(a) = t(Z)
    MGU = [Z=a]
    new goals: [r(h(a))]
4) Need to prove r(h(a)). Try the third rule: r(h(a)) = r(h(a))
    MGU = []
    new goals: []. Done!

This tells us our query is true.
    if we want to return the value of X for which p(X) is true,
    we just need to keep track of a substitution for X
        after 1, we have X=f(Y)
        after 2, we have X=f(h(Z))
        after 3, we have X=f(h(a))

Search.
    - for each (sub)goal, prolog tries to unify against each rule in the DB
        in top-down order.
    - this is a depth-first search strategy.
    If we succeed in proving all the goals, *or* if one of the goals is unprovable, then we backtrack.
*/

/*
Programming paradigms
    - Imperative
    - Functional
    - Object Oriented
    - Logic
    - Multi-Paradigm
    Hallmarks and strengths

Languages
    - OCaml
        + Functional: prefer recursion to iteration
        + First-class funcctions
        + pattern matching
        + immutable data types
        + parametric polymorphism
        

*/
