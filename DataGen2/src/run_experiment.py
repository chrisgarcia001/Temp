from os import sys
from experiment_runner import *

param_path = sys.argv[1]
ex = ProblemExecutor(param_path)
ex.solve_problem_set()