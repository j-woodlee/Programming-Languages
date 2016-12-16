/*
Evaluation Order.

Evaluation: Turns expressions into values.

In imperative languages, like Python, Java, etc.
    - evaluation produces side effects.

Side effects:
    - I/O effects: reading/writing to files, etc.
    - Memory effects: mutating data structures, assigning to variables,
        reading from mutable state or variables

The order of effects, affects the outcome of the program.

This is determined by the evaluation order.

Example:
    E1(E2,E3,E4)

    evaluate E1 --> V1 (possibly within side effects)
    evaluate E2 --> V2
    evaluate E3 --> V3
    evaluate E4 --> V4

    Then do the call.

This is called *eager evaluation* or *call by value*
    - this is important for understanding programs with side effects.

Evaluating a variable has no effect.
Evaluating a constant (like 1, 2, or 3) has no effect.
*/

/********************* Prolog

Get it: swi-prolog.org

High-level programming language:
    - one view: abstracting away the details of the hardware
    - more general: abstractions in general.

From "how" to "what"
    - describe what the results of computation should be,
      rather than how to get it.

Prolog enables this kind of programming.
    - example: describe what a permutation is.
    - based on this, prolog can:
        - check whether a list is a permutation of another.
        - find a permutation of a list
        - find ALL permutations of a list

    Example:
        nqueens puzzle: arrange n queens on a NxN chessboard so that
        no queen can capture any other.

        - describe what a valid solution is.
        - prolog can automatically check a solution, or find solutions.

The idea is to use *logic* (a subset of first-order logic)
    - declare things that are true (that prolog should consider to be true)
    - declare ways to learn new facts via logical deduction.
        "inference rules".
    - programming is then a process of asking whether something is true
      according to the facts and inference rules. "queries"

Prolog is a purely *symbolic* language.
    - things like prereq, cmsi281 are symbols or "symbolic constants"
    - symbols have no inherent meaning
    - NOT variables
    - all Prolog knows about a symbol is that it's equal to itself, and distinct
      from all other symbols.
    - also called *atoms* in prolog

Atoms like prereq can take parameters.
    - these are called *predicates*
    - i.e. function that returns true or false.

*/
