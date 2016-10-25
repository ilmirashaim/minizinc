% number of missions
int: m;
set of int: MISSION = 1..m;
% number of people
int: n;
set of int: WORKER = 1..n;

% lower and upper bounds for number of people for each mission
array[MISSION] of 1..n: lm;
array[MISSION] of 1..n: um; 

% lower and upper bounds for number of missions for each pearson
array[WORKER] of 1..m: lp;
array[WORKER] of 1..m: up; 

%precompute cardinalities of sets for each mission
array[MISSION] of var 1..n: x_card = [card(x[j]) | j in MISSION];

%precompute number of missions for each person
array[WORKER] of var 1..m: missions_for_worker = [sum(j in MISSION)(card(x[j] intersect {i})) | i in WORKER];

% arrays for each mission which contains ids of people who are participating in this mission
% each row - separate mission
array[MISSION] of var set of WORKER: x;

% we have 3 constraints
% first - each pair of missions should have only 1 person in intersection
constraint forall (i,j in MISSION where i<j) (card(x[i] intersect x[j]) == 1);
  
 % second - each person should have at least lp, at most up missions 
constraint forall(i in WORKER) (missions_for_worker[i] >=lp[i] /\ missions_for_worker[i] <=up[i]);

% third - each mission should have at least lm, at most um people
constraint forall(j in MISSION) (x_card[j] >=lm[j] /\ x_card[j] <=um[j]);

solve satisfy;