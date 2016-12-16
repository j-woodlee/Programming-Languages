/*SWIPL reference

let rec append(l1,l2) =
    match l1 with
    | [] -> l2
    | hd::tl -> hd :: append(tl,l2)


let rec append(l1,l2) =
    match l1 with
    | [] -> let r = l2 in
            r
    | hd::tl -> let r1 = hd :: append(tl,l2) in
                let r = hd :: r1 in
                r

*/

append([],L2,L2).
append([Hd|Tl], L2, [Hd|R]) :-
    append(Tl,L2,R),
    R = [Hd|R1].

%inline the definitions of R in each case to get:

append([],L2,L2).
append([Hd|Tl], L2, [Hd|R1]) :- append(Tl,L2,R1).

% Running select backward does insertion:

% ?- select(5,L,[1,2,3,4])
% L = [5,1,2,3,4]
%
%
% insert(E,L,R) :- select(E,R,L)

reverse([],[]).
reverse([Hd|Tl], Result) :-
    reverse(Tl,RTl),
    append(RTl,[Hd],Result).
