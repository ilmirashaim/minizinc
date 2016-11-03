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

%constraints
constraint x[1] == 1;

constraint alldifferent(x);

%table constraint
%to place card in stack must has a rank higher or lower than the top card on the stack by 1.
constraint forall(i in 1..n-1) (
	x[i] mod m == (x[i+1] mod m) +1 \/ 
	x[i] mod m == (x[i+1] mod m) - 1 \/
	(x[i] mod m == m-1 /\ x[i+1] mod m ==0) \/
	(x[i+1] mod m == m-1 /\ x[i] mod m ==0)
	);

%the order of placing cards in stack (each time next card is taken from top of pile)
constraint forall(i in 1..npiles)(
	value_precede(layout[i,1],layout[i,2], x) /\
	value_precede(layout[i,2],layout[i,3], x)
);

solve satisfy;

output
    [show(x[i]) ++ 
    " "| i in 1..n];
