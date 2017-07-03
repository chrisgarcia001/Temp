from os import sys
sys.path.insert(0, '../src/')

from experiment_runner import *

def mpp(matrix):
	for row in matrix:
		print(row)
	
#params = {'tasks per shift':3, 'shifts per day':2, 'days in horizon':3, 'min shifts off between tasks':1}

params = read_params('./params/params-3.csv', True)
dg = DataGenerator(params)

print('Task Conflict Matrix')
mpp(dg.build_task_conflict_matrix())

print('\nShortage Cost Matrix')
mpp(dg.build_shortage_weight_matrix())

print('\nResource-Type Matrix')
mpp(dg.build_resource_type_matrix())

print('\nAvailability Matrix')
mpp(dg.build_availability_matrix())

print('\nDependency Ratio Matrix')
mpp(dg.build_dependency_matrix())

print('\nInitial Demand Matrix')
init_demand = dg.build_initial_demand_matrix()
mpp(init_demand)

print('\nUpdated Demand Matrix')
mpp(dg.build_updated_demand_matrix(init_demand))

print('\nInitial Problem')
init_data = dg.build_initial_data()
#print(init_data['text'])

print('\nUpdated Problem')
#print(dg.build_updated_data(init_data, init_data['y'])['text'])

# --- Test ProblemExecutor.
ex = ProblemExecutor('./params/params-3.csv')
#ex.solve_instance(1)

ex.solve_problem_set()