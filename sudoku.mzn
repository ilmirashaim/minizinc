include "alldifferent.mzn";

%parameters
int: n; % the size of small square
int: N = n*n; %the size of big square
array[1..N, 1..N] of 0..N: start;
array[1..N, 1..N] of var 1..N: field;

%constraints
constraint forall(i in 1..N) (alldifferent([field[i,j] | j in 1..N]));
constraint forall(j in 1..N) (alldifferent([field[i,j] | i in 1..N]));
constraint forall(k,l in 0..n-1) (alldifferent([field[i+k*n,j+l*n] | i,j in 1..n]));

constraint forall ([field[i,j]=start[i,j] | i,j in 1..N  where start[i,j] !=0]);

%solver
solve satisfy;
%output field;