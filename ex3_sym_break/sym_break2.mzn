include "partition_set.mzn";
include "globals.mzn";
include "lex_greater.mzn";
% include "coercion.mzn";
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

 %x[i,j] is the set of people that form group i in week j
array[GROUP,WEEKS] of var set of PEOPLE: x;


% constraints
% number of members in a group == s
constraint forall(i in GROUP, j in WEEKS)
                (card(x[i,j]) == s);
                
% every player plays every week
% constraint forall(j in WEEKS)
%               (card(array_union([x[i,j] | i in GROUP])) == n);
constraint  forall(j in WEEKS) (partition_set([x[i,j] | i in GROUP], PEOPLE));
 
% nobody meets more than once
constraint forall(p1,p2 in PEOPLE where p1<p2)
              (sum(j in WEEKS, i in GROUP) (bool2int(card(x[i,j] intersect {p1,p2}) == 2)) <= 1);
                
% symmetry breaking constraints

% players permutations
% in-group permutations
% first week should have consecutive order in group
constraint forall (i in GROUP) (x[i,1] == ((i-1)*s+1)..i*s);

% group permutations 
% week permutations 
% for all weeks order the groups in increasing order of their first member
% first members
% constraint forall(j in WEEKS, i in 1..g-1)(min([k | k in x[i,j]]) < min([k | k in x[i+1,j]]));
constraint forall(j in WEEKS)(decreasing([x[i,j] | i in GROUP]));

% order the weeks in increasing order of the second member of the first group
% constraint forall(j in 1..w-1) ([k | k in x[1,j]][2] < [k | k in x[1,j+1]][2]);
constraint (decreasing([x[1,j] | j in WEEKS]));              
solve satisfy;

output
% [show(bool2int(([k | k in x[1,j]][2] < [k | k in x[1,j+1]][2]))) | j in 1..w-1]
    [show(x[i, j]) ++
     if j mod w == 0 then "\n" else "," endif
     | i in GROUP, j in WEEKS
    ];


