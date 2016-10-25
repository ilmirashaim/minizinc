include "globals.mzn";
% g - number of groups
int: g;
set of int: GROUP = 1..g;

% s - number of members in a group
int: s;
%set of int: GROUP_MEMBER = 1..s;

% n - number of people
int: n = g*s;
set of int: PEOPLE = 1..n;

% w - number of weeks
int: w;
set of int: WEEKS = 1..w;

% integer variables xij taking values in the range [1..g]
% xij == g means that person i is the j-th week plays at group g
array[PEOPLE,WEEKS] of var GROUP: x;


% constraints
% number of members in a group == s
constraint forall(j in WEEKS, k in GROUP)
                (exactly(s, [x[i,j] | i in PEOPLE], k));
                %(sum(i in PEOPLE)(bool2int(x[i,j]==k)) == s);
                
% every player plays every week
% comes naturally from data structure
 
% nobody meets more than once
constraint forall(i1,i2 in PEOPLE where i1<i2)
                 (sum(j in WEEKS) (bool2int(x[i1,j]==x[i2,j])) <= 1);


% symmetry breaking constraints

% players permutations
% in-group permutations
% the first week has consecutive groups 1,2,...,g
constraint forall(i in PEOPLE)  (x[i,1] == (((i-1) div s)+1));

% group permutations 
% week permutations 
% groups should appear in increasing order
constraint  forall(i in 1..s-1) (x[i,2] <x[i+1,2]);

% the first group for the first person is 1 for every week
constraint forall(j in WEEKS) (x[1,j] == 1);
solve satisfy;
 
 
output
   [show(x[i, j]) ++
    if j mod w == 0 then "\n" else "," endif
   | i in PEOPLE, j in WEEKS
  ];