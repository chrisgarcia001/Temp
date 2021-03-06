/*********************************************
 * OPL 12.4 Model
 * Author: chris
 * Creation Date: Dec 26, 2012 at 4:06:10 PM
 *********************************************/
 
 //using CP;
 
 execute PARAMS {
   cplex.tilim = 1200; // time limit in seconds
 }
 
 int numJobs = ...;
 range Jobs = 1..numJobs;
 float profit[Jobs] = ...;
 float ptime[Jobs] = ...;
 float jsize[Jobs] = ...;
 float invcost[Jobs] = ...;
 float A[Jobs] = ...;
 float B[Jobs] = ...; 
 float invlimit = ...;
 
 dvar int+ x[Jobs] in 0..1;
 dvar float+ t[Jobs];
 dvar int+ I[Jobs] in 0..1;
 dvar float+ C[Jobs];
 dvar float+ F[Jobs];
 dvar float G[Jobs];
 dvar int+ O[Jobs][Jobs] in 0..1;

 maximize sum(j in Jobs) ((profit[j] * x[j]) - (invcost[j] * I[j]));
 
 constraints {
   	forall (i,j in Jobs: i != j)  {
   	  (x[i] == 1 && x[j] == 1) => ((C[j] <= t[i]) || (C[i] <= t[j])); // C2
    }   	  
    
    forall (j in Jobs)  {
      C[j] == t[j] + ptime[j];  // C1
      // Below: C3(a) - C3(c) ensure F[j] == F[j] == max(C[j], A[j])
      (F[j] == C[j]) || (F[j] == A[j]); // C3(a)
      F[j] >= C[j];                     // C3(b)
      F[j] >= A[j];                     // C3(c)
      //F[j] == max(C[j], A[j]);  // C3
      G[j] == A[j] - C[j]; //C4
      (x[j] == 1 && C[j] <= A[j]) => I[j] == 1; // C5
      sum(i in Jobs) jsize[i] * O[j][i] <= invlimit; // C7
      (x[j] == 1) => F[j] <= B[j];                   // C8
    }      
    
    forall (i,j in Jobs)  {
      // C6
      (I[i] == 1 && I[j] == 1 && (C[j] <= C[i]) && (C[i] <= C[j] + G[j])) => O[i][j] == 1;
    }      
 }   
  
  
  /*
   constraints {
   	forall (i,j in Jobs: i != j)  {
   	  (x[i] == 1 && x[j] == 1) => ((t[j] + ptime[j] <= t[i]) || (t[i] + ptime[i] <= t[j])); // C1
    }   	  
    
    forall (j in Jobs)  {
      //F[j] == max(t[j] + ptime[j], A[j]);  // C2
      // Below: C2(a) - C2(c) ensure F[j] == max(t[j] + ptime[j], A[j])  
      //(F[j] == t[j] + ptime[j]) || (F[j] == A[j]); // C2(a)
      F[j] >= t[j] + ptime[j];                     // C2(b)
      F[j] >= A[j];                                // C2(c)
      (x[j] == 1 && t[j] + ptime[j] <= A[j]) => I[j] == 1; // C3
      sum(i in Jobs) jsize[j] * O[j][i] <= invlimit; // C5
      (x[j] == 1) => F[j] <= B[j];                   // C8
    }      
    
    forall (i,j in Jobs)  {
      // C4
      (I[i] == 1 && I[j] == 1 && !(t[i] + ptime[i] <= t[j]) && !(t[j] + ptime[j] <= t[i])) => O[i][j] == 1;
    }      
 }   
  */
  