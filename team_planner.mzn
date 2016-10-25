include "globals.mzn";
% number of missions
int: m;
set of int: MISSION = 1..m;
% number of people
int: n;
set of int: WORKER = 1..n;

% lower and upper bounds for number of people for each mission
array[1..m] of int: lm;
array[1..m] of int: um; 

% lower and upper bounds for number of missions for each pearson
array[1..n] of int: lp;
array[1..n] of int: up; 

% array where 1 is in element (i,j) if worker i is in mission j
array[WORKER, MISSION] of var 0..1: x;

% we have 3 constraints
% first - each pair of missions should have only 1 person in intersection
constraint forall (i ,j in MISSION where i<j) (sum(k in WORKER) (bool2int(x[i,k] == x[j,k])) ==1);
  
 % second - each person should have at least lp, at most up missions 
constraint forall(i in WORKER)  (global_cardinality_low_up([x[i,j] | j in MISSION], [1], [lp[i]], [up[i]]));

% third - each mission should have at least lm, at most um people
constraint forall(j in MISSION)  (global_cardinality_low_up([x[i,j] | i in WORKER], [1], [lm[j]], [um[j]]));

solve satisfy;