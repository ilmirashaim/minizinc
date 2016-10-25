include "alldifferent.mzn";
% we will use the following indexes:
% i will refer to a group. Thus, it will range between 0 and g − 1.
int: g;
set of int: GROUP = 1..g;

% j will refer to a member of a group. Thus, it will range between 0
% and s − 1.
int: s;
set of int: GROUP_MEMBER = 1..s;

% people number is n
int: n = g*s;
set of int: PEOPLE = 1..n;

% k will refer to a week. Thus, it will range between 0 and w − 1.
int: w;
set of int: WEEKS = 1..w;

% we define integer variables xijk taking values in the range [0..n−1].
% If xijk ← v, it means that person v is the j-th member of group i at
% week k
array[GROUP, GROUP_MEMBER, WEEKS] of var PEOPLE: x;

% constraints
% every player plays every week
constraint forall(k in WEEKS) 
                         (alldifferent([x[i,j,k] | j in GROUP_MEMBER, i in GROUP]));
 
% nobody meets more than once
constraint forall(k1,k2 in 1..w where k1<k2)
                   (forall (i1, i2 in GROUP)
                      (forall(j1i1,j2i1 in GROUP_MEMBER where j1i1<j2i1)
                         (forall(j1i2, j2i2 in GROUP_MEMBER where j1i2<j2i2)
                        ((x[i1,j1i1,k1] != x[i2,j1i2,k2]) \/ (x[i1,j2i1,k1] != x[i2,j2i2,k2])))));
             
% symmetry break constraints
% we only need to assign consecutive values
% 0, 1, .., n − 1 to the variables of the first column.
constraint forall(i in GROUP, j in 1..s-1) (x[i,j,1] +1==x[i,j+1,1]);
constraint forall(i in 1..g-1) (x[i,s,1] + 1 == x[i+1,1,1]);
 
% we only need to force the members to be in increasing order
constraint forall(i in GROUP, j in 1..s-1, k in WEEKS)(x[i,j,k]<x[i,j+1,k]);
 
% for all weeks order the group in increasing order of their first member
constraint forall(i in 1..g-1, k in WEEKS) (x[i,1,k]<x[i+1,1,k]);
 
% the second elements must be diferent at each week
constraint forall(k in 1..w-1) (x[1,2,k]<x[1,2,k+1]);

solve satisfy;
 
 
output
    [show(x[i, j, k]) ++
     if k mod w == 0 then "\n" else "," endif ++
     if j mod s == 0 /\ k != w+1 then
        if k mod w == 0 then "\n" else "" endif
     else "" endif
     | i in GROUP, j in GROUP_MEMBER, k in WEEKS
    ];

 
 
 
