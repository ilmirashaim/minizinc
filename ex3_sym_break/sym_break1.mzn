include "globals.mzn";
% g - number of groups
int: g;
set of int: GROUP = 1..g;

% s - number of members in a group
int: s;

% n - number of people
int: n = g*s;
set of int: PEOPLE = 1..n;

% w - number of weeks
int: w;
set of int: WEEKS = 1..w;

% integer variables xij taking values in the range [1..g]
% x[i,j] == g means that person i is the j-th week plays at group g
array[PEOPLE,WEEKS] of var GROUP: x;


% constraints
% number of members in a group == s
constraint forall(j in WEEKS)
                (global_cardinality( [x[i,j] | i in PEOPLE], GROUP, [s|k in GROUP]));
                
% every player plays every week
% comes naturally from data structure
 
% nobody meets more than once
constraint forall(j1,j2 in WEEKS where j1<j2)
                    (forall(i1,i2 in PEOPLE where i1<i2)
                       (x[i1,j1]==x[i2,j1] -> x[i1,j2] != x[i2,j2]));


% symmetry breaking constraints

% the first week has consecutive groups 1,2,...,g
constraint forall(i in PEOPLE)  (x[i,1] == (((i-1) div s)+1));

% groups should appear in increasing order
constraint forall (j in WEEKS) (
                  forall(k in 1..g-1)      
                    (value_precede(k, k+1, [x[i,j]| i in PEOPLE]) )
                );

% the weeks should be orderd by increasing order of the second member of the first group
constraint increasing ([arg_min([if x[i,j]==1 then i else n+1 endif | i in 2..n]) | j in WEEKS]);

solve satisfy;
 
output
   [show(x[i, j]) ++
    if j mod w == 0 then "\n" else "," endif
   | i in PEOPLE, j in WEEKS
  ];
