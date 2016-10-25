include "alldifferent.mzn";
int: n;
int: N=n*n;

array[1..n*n, 1..(n-1)*n] of string: horizontal;
array[1..(n-1)*n, 1..n*n] of string: vertical;

array[1..n*n, 1..n*n] of var 1..N: field;

constraint forall(i in 1..N) (alldifferent([field[i,j] | j in 1..N]));
constraint forall(j in 1..N) (alldifferent([field[i,j] | i in 1..N]));
constraint forall(k,l in 0..n-1) (alldifferent([field[i+k*n,j+l*n] | i,j in 1..n]));

constraint forall ([field[i,j]>field[i,j+1]  | i,j in 1..n*n where (j mod n !=0 /\ horizontal[i,j-(j div n)]==">" )]);
constraint forall ([field[i,j]<field[i,j+1]  | i,j in 1..n*n where (j mod n !=0 /\ horizontal[i,j-(j div n)]=="<" )]);
constraint forall ([field[i,j]<field[i+1,j]  | i,j in 1..n*n where (i mod n !=0 /\ vertical[i-(i div n),j]=="^" )]);
constraint forall ([field[i,j]>field[i+1,j]  | i,j in 1..n*n where (i mod n !=0 /\ vertical[i-(i div n),j]=="v" )]);

solve satisfy;
