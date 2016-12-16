% usage: $ swipl < hw8-tests.pl

consult(hw8).

write('Problem 1 tests'). % prints an extra true.

duplist([1,2,3], [1,1,2,2,3,3]).

duplist([1,1,3,2], [1,1,1,1,3,3,2,2]).

write('Problem 2 tests').

sorted([1,2,3,4,5]).

write('Problem 3 tests').

perm([1,5,3,2,4], [1,2,3,4,5]).

permsort([1,5,3,2,4], [1,2,3,4,5]).

write('Problem 4 tests').

insert(3, [1,2,4,5], [1,2,3,4,5]).

% insert does not require input lists to be sorted.
insert(3, [2,1,5,4], [2,1,3,5,4]).

insertV2(3, [1,2,4,5], [1,2,3,4,5]).

insort([1,5,3,2,4], [1,2,3,4,5]).

write('Problem 6 tests').

perform(world([x],[],[],none),             % initial world
        pickup(stack1),                    % action
        world([],[],[],x)).                % final world

perform(world([],[],[],x),                 % initial world
        putdown(stack2),                   % action
        world([],[x],[],none)).            % final world

blocksworld(world([x],[],[],none),              % initial world
            [pickup(stack1),putdown(stack2)],   % actions
            world([],[x],[],none)).             % final world

write('Problem 7 tests').

% insert new entries at the end.
put(1,hello,[[2,two]],[[2,two],[1,hello]]).  

put(1,hello,[[1,one],[2,two]],[[1,hello],[2,two]]).

get(1,[[2,two],[1,hello]],hello).

setof(K, get(K,[[2,hello],[1,hello]],hello), L), perm(L,[1,2]).

write('Problem 8 tests').

eval(geq(intconst(1),intconst(0)), [], boolval(true)).

eval(var(x), [[x,intval(5)]], intval(5)).

eval(if(boolconst(true), intconst(1), intconst(2)), [], intval(1)).

eval(funcall(function(x,if(geq(var(x),intconst(0)),intconst(1),intconst(0))), intconst(34)), [], intval(1)).

