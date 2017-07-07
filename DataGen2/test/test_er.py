from os import sys
sys.path.insert(0, '../src/')

from experiment_runner import *

param_path = './params/base.csv'

def mpp(matrix):
	for row in matrix:
		print(row)
	
#params = {'tasks per shift':3, 'shifts per day':2, 'days in horizon':3, 'min shifts off between tasks':1}

params = read_params(param_path, True)
dg = DataGenerator(params)

# print('Random test')
# for i in range(10):
	# print(random_float(5, 10))

print('Dummy Tasks')
mpp(dg.get_dummy_task_indices())
	
print('Tasks by Shift')
mpp(dg.get_tasks_by_shift())

print('Task Shift Map')
mpp(dg.task_shift_map())

print('Task Conflict Matrix')
mpp(dg.build_task_conflict_matrix())

print('E Matrix')
mpp(dg.build_E_matrix())

print('Transportation Cost Matrix')
mpp(dg.build_transp_cost_matrix())

# print('\nShortage Cost Matrix')
# mpp(dg.build_shortage_weight_matrix())

# print('\nResource-Type Matrix')
# mpp(dg.build_resource_type_matrix())

# print('\nAvailability Matrix')
# mpp(dg.build_availability_matrix())

# print('\nDependency Ratio Matrix')
# mpp(dg.build_dependency_matrix())

# print('\nInitial Demand Matrix')
# init_demand = dg.build_initial_demand_matrix()
# mpp(init_demand)

# print('\nUpdated Demand Matrix')
# mpp(dg.build_updated_demand_matrix(init_demand))

# print('\nInitial Problem')
# init_data = dg.build_initial_data()
# print(init_data['text'])

# print('\nUpdated Problem')
# print(dg.build_updated_data(init_data, init_data['y'])['text'])

#--- Test ProblemExecutor.
ex = ProblemExecutor(param_path)
ex.solve_instance(1)

#ex.solve_problem_set()