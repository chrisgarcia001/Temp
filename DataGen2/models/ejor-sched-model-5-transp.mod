/*********************************************
 * OPL 12.3 Model
 * Author: cgarcia
 * Creation Date: Sep 23, 2016 at 1:48:23 PM
 *********************************************/
 
  execute PARAMS {
   cplex.tilim = 600; // time limit in seconds
 }

 // ------------- I. MODEL INPUTS: --------------------
 int numResourceTypes = ...;
 int numResources = ...;
 int numTasks = ...;
 int numShifts = ...; // For transportation modeling
 
 
 range K = 1..numResourceTypes;
 range R = 1..numResources;
 range T = 1..numTasks;
 range Shifts = 1..numShifts; // For transportation
 
 int r[R][K] = ...;
 int D[K][T] = ...;
 float d[K][K][T] = ...;
 float S[K][T] = ...;
 int y[R][T] = ...;
 float mP[R][T] = ...;
 float mM[R][T] = ...;
 int A[R][T] = ...;
 int u[R][T][T] = ...;
 float L[K][T] = ...;
 float B[R] = ...;
 // Transportation-related inputs:
 float c[T][T] = ...;
 float E[T][Shifts] = ...;  // E[j][h] = 1 iff task j is in shift h. 
 {int} NonDummyT = ...;
 
 // ------------- II. DECISION VARIABLES: ------------
 dvar int+ x[R][T] in 0..1;
 dvar int+ wP[R][T] in 0..1;
 dvar int+ wM[R][T] in 0..1;
 dvar float+ v[K][T];
 dvar float TotalShortageCost;
 dvar float TotalDeviationCost;
 dvar float TotalAllocBenefit;
 // Transportation-related variables: 
 dvar int+ b[R][T][T] in 0..1;
 dvar float TotalTransportationCost;
 
 maximize TotalAllocBenefit - TotalShortageCost - TotalDeviationCost - TotalTransportationCost;
 		  
 constraints {
   forall (i in R, k in T) { 
   	x[i][k] <= A[i][k];                // Constraint 2
   	x[i][k] - y[i][k] <= wP[i][k];     // Constraint 6
   	y[i][k] - x[i][k] <= wM[i][k];     // Constraint 7
   	
   	forall (kp in T) {
   	  x[i][k] + x[i][kp] + u[i][k][kp] <= 2; // Constraint 3
    }   	  
   }    
   
   forall (i in R, k in NonDummyT) {
     x[i][k] <= sum (j in K) (r[i][j] * D[j][k]); // Constraint 9   
   }     
    
   forall (j in K, k in T) {
     D[j][k] - sum (i in R) r[i][j] * x[i][k] <= v[j][k]; // Constraint 5
     sum (i in R) r[i][j] * x[i][k] <= L[j][k];           // Constraint 8
     
     forall (jp in K) {
       // Constraint 4
       sum (i in R) r[i][j] * x[i][k] >= d[j][jp][k] * (sum (i in R) r[i][jp] * x[i][k]);
     }       
   }     
   
   TotalShortageCost == sum (j in K) sum (k in T) (S[j][k] * v[j][k]);
   TotalDeviationCost == sum (i in R) sum (k in T) ((mP[i][k] * wP[i][k]) + (mM[i][k] * wM[i][k]));
   TotalAllocBenefit == sum (i in R) sum (k in T) (B[i] * x[i][k]);
   
   /************* TRANSPORTATION-RELATED CONSTRAINTS BELOW ******************/
   forall (i in R, j in T, k in T) { 
   	   x[i][j] + x[i][k] - 1 <= b[i][j][k];  // Constraint 21
   }
   
   // --- CAUSES CONFLICT - NEEDS DEBUGGING: --------
   forall (i in R, k in Shifts) {
     // E[T][Shifts]
     sum (j in T) E[j][k] * x[i][j] == 1;  // Constraint 22
   }  
   
   TotalTransportationCost == sum (i in R) sum (j in T) sum (k in T) (c[j][k] * b[i][j][k]);  // Constraint 20
 }   
 
// Write the x solution values, so they an be used as y-values
// in future problem modification.
execute DISPLAY {
  writeln();
  write("x = [");
  for(var i = 1; i <= numResources; i ++) {
    write("[");
    for(var k = 1; k <= numTasks; k ++) {
      write(x[i][k]);
      if(k < numTasks) { write(","); }        
    }     
    write("]");   
    if(i < numResources) { write(","); }      
  }   
  write("]");
  writeln();
}  
 