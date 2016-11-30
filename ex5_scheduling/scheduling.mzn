% courses
int: c;
set of int: COURSES = 1..c;

% groups
int: g;
set of int: GROUPS = 1..g;

% theory lecture rooms
int: nt;
set of int: THEORY_ROOMS= 1..nt;

% lab lecture rooms
int: nl;
set of int: LAB_ROOMS= 1..nl;

% number of professors for each course
array[1..c] of int: NT;

% days
int: d;
set of int: DAYS = 1..d;

% hours
int: ini;
int: end;
set of int: HOURS= ini..end-1;

array[DAYS] of string: WEEK_DAYS; 

% solution
array[COURSES, GROUPS] of var DAYS: lab_days;
array[COURSES, GROUPS] of var HOURS: lab_hours;
array[COURSES, GROUPS] of var DAYS: t_days;
array[COURSES, GROUPS] of var HOURS: t_hours;


% constraints
% For every course and group, its two lectures have to be scheduled on
% different days and the lab has to be scheduled after the theory
constraint forall(i in COURSES) (
                    forall(j in GROUPS)(
                        lab_days[i,j] > t_days[i,j]
                    )
                 ); 
% At every time slot, there must be enough lecture rooms and lecturers
% available for the scheduled lectures
constraint forall(k in DAYS)(
                    forall(h in HOURS)(
                       sum(i in COURSES, j in GROUPS) (lab_days[i,j] == k /\ lab_hours[i,j]==h) <=nl
                    )  
                );
                
constraint forall(k in DAYS)(
                    forall(h in HOURS)(
                       sum(i in COURSES, j in GROUPS) (t_days[i,j] == k /\ t_hours[i,j]==h) <=nt
                    )  
                );
constraint forall(k in DAYS)(
                    forall(h in HOURS)(
                       forall(i in COURSES)(
                          sum(j in GROUPS) (t_days[i,j] == k /\ t_hours[i,j]==h) +
                          sum(j in GROUPS) (lab_days[i,j] == k /\ lab_hours[i,j]==h) <=NT[i]
                       )
                    )  
                );
                                
% For every group there cannot be any
% overlapping among its lectures           
constraint forall(j in GROUPS)(
                    forall(i1,i2 in COURSES where i1<i2)(
                          lab_hours[i1,j] != lab_hours[i2,j] \/ lab_days[i1,j] != lab_days[i2,j]    
                     )
                ); 

       
solve satisfy;    

output
   [if i mod c == 1 then "group " ++ show(j)  ++ ": " else "" endif  ++ 
      show(WEEK_DAYS[t_days[i, j]]) ++ show(t_hours[i, j])++ "/" ++
      show(WEEK_DAYS[lab_days[i, j]]) ++ show(lab_hours[i, j]) ++
   if i mod c == 0 then "\n" else "  " endif
   |  j in GROUPS, i in COURSES
  ];

