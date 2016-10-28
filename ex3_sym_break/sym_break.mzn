include "alldifferent.mzn";
include "increasing.mzn";

% g - number of groups
int: g;
set of int: GROUP = 1..g;

% s - number of members in a group
int: s;
set of int: GROUP_MEMBER = 1..s;

% n - number of people
int: n = g*s;
set of int: PEOPLE = 1..n;

% w - number of weeks
int: w;
set of int: WEEKS = 1..w;

% integer variables xijk taking values in the range [1..n]
%  x[i,j,k] == v means that person v is the j-th member of group i at
% week k
array[GROUP, GROUP_MEMBER, WEEKS] of var PEOPLE: x;

% constraints
% every player plays every week
constraint forall(k in WEEKS) 
                         (alldifferent([x[i,j,k] | j in GROUP_MEMBER, i in GROUP]));
 
% nobody meets more than once
constraint forall(k1,k2 in 1..w where k1<k2)
                   (forall (i1, i2 in GROUP)
                      (forall(j1i1,j2i1 in GROUP_MEMBER where j1i1!=j2i1)
                         (forall(j1i2, j2i2 in GROUP_MEMBER where j1i2!=j2i2)
                        ((x[i1,j1i1,k1] != x[i2,j1i2,k2]) \/ (x[i1,j2i1,k1] != x[i2,j2i2,k2])))));
             
% symmetry break constraints

% we only need to assign consecutive values
% 1, 2, .., n to the variables of the first column.
constraint forall(i in GROUP, j in GROUP_MEMBER) (x[i,j,1]  ==  (i-1)*s + j);
 
% we only need to force the members to be in increasing order
constraint forall(i in GROUP, k in WEEKS)(increasing([x[i,j,k] | j in GROUP_MEMBER]));
 
% for all weeks order the groups in increasing order of their first member
constraint forall(k in WEEKS) (increasing([x[i,1,k] | i in GROUP]));
 
% order the weeks in increasing order of the second member of the first group
constraint increasing ([x[1,2,k] | k in WEEKS]);

solve satisfy;
 
 
output
    [show(x[i, j, k]) ++
     if k mod w == 0 then "\n" else "," endif ++
     if j mod s == 0 then
        if k mod w == 0 then "\n" else "" endif
     else "" endif
     | i in GROUP, j in GROUP_MEMBER, k in WEEKS
    ];

 
 
 
