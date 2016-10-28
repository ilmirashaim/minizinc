include "partition_set.mzn";
include "globals.mzn";

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
constraint  forall(j in WEEKS) (partition_set([x[i,j] | i in GROUP], PEOPLE));
 
% nobody meets more than once
constraint forall(j1,j2 in WEEKS where j1<j2)
                 (forall(i1,i2 in GROUP)
                    (card(x[i1,j1] intersect x[i2,j2])< 2));
                
% symmetry breaking constraints

% first week should have consecutive order in group
constraint forall (i in GROUP) (x[i,1] == ((i-1)*s+1)..i*s);

% for all weeks order the groups in increasing order of their first member
constraint forall(j in WEEKS)(decreasing([x[i,j] | i in GROUP]));

% order the weeks in increasing order of the second member of the first group
constraint (decreasing([x[1,j] | j in WEEKS]));              
solve satisfy;

output
    [show(x[i, j]) ++
     if j mod w == 0 then "\n" else "," endif
     | i in GROUP, j in WEEKS
    ];


