include "alldifferent.mzn";
include "globals.mzn";
%number of suits
int: s;
set of int: SUITS=1..s;

%number of cards in each suit
int: m;
set of int: CARDS_NUM=1..m;

%number of cards
int: n = s*m;
set of int: CARDS = 1..n;

%number of piles
int: npiles = (n div 3);
%input
array[1..npiles, 1..3] of CARDS: layout;

%solution/stack
array[1..n] of var CARDS: x;
array[1..n] of var CARDS: y;

array[1..n] of var 0..m-1: a;

%array of tuples for table constraint
array[1..m*s*s*2, 1..2] of CARDS:tbl;

%constraints
constraint x[1] == 1;

constraint inverse(x,y);

% table constraint
% to place card in stack must has a rank higher or lower than the top card on the stack by 1.
constraint forall(i in 1..n-1) (
	table([x[i], x[i+1]], tbl) 
	);

%the order of placing cards in stack (each time next card is taken from top of pile)
constraint forall(i in 1..npiles)
                    (y[layout[i,1]] < y[layout[i,2]] /\ y[layout[i,2]] < y[layout[i,3]]);

solve satisfy;

output
    [show(x[i]) ++ 
    " "| i in 1..n] ;
