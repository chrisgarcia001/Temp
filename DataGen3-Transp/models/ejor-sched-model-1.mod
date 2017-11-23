/*********************************************
 * OPL 12.3 Model
 * Author: cgarcia
 * Creation Date: Sep 23, 2016 at 1:48:23 PM
 *********************************************/

 int numResourceTypes = ...;
 int numResources = ...;
 int numTasks = ...;
 
 range K = 1..numResourceTypes;
 range R = 1..numResources;
 range T = 1..numTasks;
 int r[R][K] = ...;
 int D[K][T] = ...;
 float d[K][K][T] = ...;
 float S[K][T] = ...;
 int y[R][T] = ...;
 float mP[R][T] = ...;
 float mM[R][T] = ...;
 int A[R][T] = ...;
 int u[R][T][T] = ...;
 
 dvar int+ x[R][T] in 0..1;
 dvar int+ wP[R][T] in 0..1;
 dvar int+ wM[R][T] in 0..1;
 
 minimize (sum (j in K) sum (k in T) S[j][k] * D[j][k]) - 
 		  (sum (i in R) sum(j in K) sum (k in T) S[j][k] * r[i][j] * x[i][k]) +
 		  (sum (i in R) sum (k in T) ((mP[i][k] * wP[i][k]) + (mM[i][k] * wM[i][k])));
 		  
 constraints {
   forall (i in R, k in T) { 
   	x[i][k] <= A[i][k];                // Constraint 2
   	x[i][k] - y[i][k] <= wP[i][k];     // Constraint 6
   	y[i][k] - x[i][k] <= wM[i][k];     // Constraint 7
   	
   	forall (kp in T) {
   	  x[i][k] + x[i][kp] + u[i][k][kp] <= 2; // Constraint 3
    }   	  
   }    
    
   forall (j in K, k in T) {
     sum (i in R) r[i][j] * x[i][k] <= D[j][k]; // Constraint 5
     
     forall (jp in K) {
       // Constraint 4
       sum (i in R) r[i][j] * x[i][k] >= d[j][jp][k] * (sum (i in R) r[i][jp] * x[i][k]);
     }       
   }     
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
 