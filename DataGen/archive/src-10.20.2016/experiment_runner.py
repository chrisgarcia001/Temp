from util import *
import random as rnd
import math
import subprocess

# TODO - update to work with supervisors/others separately.

# This class provides methods for generating problem data based on a set of parameters.
class DataGenerator:
	def __init__(self, params):
		self.params = params
		self.set_resources()
		self.shortge_range = self.params['shortage weight range']
		self.tps = int(self.params['tasks per shift'])
		self.spd = int(self.params['shifts per day'])
		self.days = int(self.params['days in horizon'])
		self.num_shifts = int(self.spd * self.days)
		self.num_tasks = int(self.tps * self.spd * self.days)
		
	# This sets the proper numbers related to resources and resource types.
	def set_resources(self):
		self.raw_resources = to_int(self.params['resources'])
		self.num_resource_types = len(self.raw_resources) #+ 1 
		self.num_managers = to_int(self.raw_resources[0])
		self.num_non_managers = to_int(sum(self.raw_resources[1:]))
		self.resource_types = to_int(list(self.raw_resources))
		self.num_resources = to_int(sum(self.raw_resources))
		self.available_resources = self.raw_resources 
	
	# This is u[j][j']. Needs to be added to each resource for u[i][j][j'].
	def build_task_conflict_matrix(self):
		tps = self.tps
		spd = self.spd
		days = self.days
		min_shifts_off = int(self.params['min shifts off between tasks'])
		num_shifts = int(spd * days)
		num_tasks = tps * num_shifts
		block_size = tps * (1 + min_shifts_off)
		matrix = dim_matrix(num_tasks, num_tasks, 0)
		curr_row = 0
		curr_col = 0
		for i in range(num_shifts):
			for j in range(tps):
				for k in range(curr_col, min(curr_col + block_size, len(matrix))):
					matrix[curr_row][k] = 1
				curr_row += 1			
			curr_col += tps
		for i in range(len(matrix)):
			for j in range(len(matrix)):
				if matrix[i][j] == 1:
					matrix[j][i] = 1
		for i in range(len(matrix)):
			matrix[i][i] = 0
		return matrix

		
	# This is rij.	
	def build_resource_type_matrix(self):
		resources = dim_matrix(self.num_resources, self.num_resource_types, 0)
		i = 0
		for j in range(self.num_resource_types):
			for k in range(self.available_resources[j]):
				resources[i][j] = 1
				i += 1
		return resources
	
	# This is S[j][k].	
	def build_shortage_weight_matrix(self):
		min_short, max_short = tuple(self.params['shortage weight range'])
		matrix = dim_matrix(self.num_resource_types, self.num_shifts, 0)
		for i in range(len(matrix)):
			for j in range(len(matrix[i])):
				matrix[i][j] = round(rnd.uniform(min_short, max_short), 2)
		return matrix
	
	# This is A[i][k].
	def build_availability_matrix(self):
		min_perc, max_perc = tuple(self.params['percent availability per resource range'])
		matrix = dim_matrix(self.num_resources, self.num_tasks, 0)
		for i in range(self.num_resources):
			t = row_index_tuples(i, self.num_tasks)
			inds = rnd.sample(t, rnd.randint(int(min_perc * self.num_tasks), math.ceil(max_perc * self.num_tasks)))
			for (i,j) in inds:
				matrix[i][j] = 1
		return matrix
	
	# This is d[j][j'][k].
	def build_dependency_matrix(self):
		a, b = tuple(self.params['supervisor ratio'])
		ratio_matrix = dim_matrix(self.num_resource_types, self.num_resource_types, 0)
		for j in range(1, len(ratio_matrix[0])):
			ratio_matrix[0][j] = a / b
		matrix = dim_matrix(self.num_resource_types, self.num_resource_types)
		for i in range(len(ratio_matrix)):
			for j in range(len(ratio_matrix[i])):
				matrix[i][j] = list([ratio_matrix[i][j]] * self.num_tasks)
		return matrix
	
	# This is initial D[j][k].
	def build_initial_demand_matrix(self):
		min_types, max_types = tuple(self.params['num resource types per class range'])
		min_perc, max_perc = tuple(self.params['percent availability per resource range'])
		matrix = dim_matrix(self.num_resource_types, self.num_tasks, 0)
		for k in range(self.num_tasks):
			inds = [0] + rnd.sample(range(1, self.num_resource_types), max(0, rnd.randint(min_types - 1, max_types - 1)))
			for j in inds:
				a = max(1,int(min_perc * self.available_resources[j]))
				b = math.ceil(max_perc * self.available_resources[j])
				matrix[j][k] = rnd.randint(a, b)
		return matrix
	
	# This is the updated D[j][k].	
	def build_updated_demand_matrix(self, init_matrix):
		min_perc, max_perc = tuple(self.params['task demand percent change range'])
		update_f = lambda x: rnd.randint(int(min_perc * x), math.ceil(max_perc * x))
		return transform(init_matrix, update_f)

	# Build the initial set of data (i.e. prior to condition changes).
	def build_initial_data(self):
		h = {'r':self.build_resource_type_matrix(),
		     'D':self.build_initial_demand_matrix(),
			 'd':self.build_dependency_matrix(),
			 'S':self.build_shortage_weight_matrix(),
			 'y':dim_matrix(self.num_resources, self.num_tasks, 0),
			 'mP':dim_matrix(self.num_resources, self.num_tasks, 0),
			 'mM':dim_matrix(self.num_resources, self.num_tasks, 0),
			 'A':self.build_availability_matrix(),
			 'u':[self.build_task_conflict_matrix()] * self.num_resources,
			 'numResources':self.num_resources,
			 'numResourceTypes':self.num_resource_types,
			 'numTasks':self.num_tasks}

		ordered_keys = ['numResources', 'numResourceTypes', 'numTasks', 'r', 'D',
		                'd', 'S', 'y', 'mP', 'mM', 'A', 'u']
		text = ''
		for key in ordered_keys:
			text += str(key) + ' = ' + str(h[key]) + ";\n"
		h['text'] = text
		return h
	
	
	# Build the updated (i.e. post-condition change) set of data.
	def build_updated_data(self, init_data, new_y):
		h = init_data
		h['y'] = new_y
		h['D'] = self.build_updated_demand_matrix(h['D'])
		ordered_keys = ['numResources', 'numResourceTypes', 'numTasks', 'r', 'D',
		                'd', 'S', 'y', 'mP', 'mM', 'A', 'u']
		text = ''
		for key in ordered_keys:
			text += str(key) + ' = ' + str(h[key]) + ";\n"
		h['text'] = text
		return h

# This class performs combined problem generation (via ProblemGenerator) and
# problem solution by calling OPL. 		
class ProblemExecutor:
	def __init__(self, param_path):
		self.params = read_params(param_path, True)
		self.model_file = self.params['model file']
		self.problem_set_name = self.params['problem set name']
		self.problem_path = self.params['problem path']
		self.solution_path = self.params['solution path']
		self.num_replicates = int(self.params['replicates'])
	
	# Generate a consistent problem name with appropriate suffix.
	def prob_name(self, path, prefix, set_name, prob_id, suffix=''):
		if path != '' and not(path.endswith('/')):
			path = path + '/'
		elems = [prefix, set_name, prob_id]
		return path + '_'.join(filter(lambda x: x != '', map(lambda y: str(y), elems))) + suffix
	
	# Solve the specified problem with OPL, write the solution to the specified output file,
	# and return the results.
	def opl_solve(self, data_file, solution_filename=None): 	
		raw_output = subprocess.check_output(['oplrun', self.model_file, data_file])
		if solution_filename != None:
			print('Writing solution file: ' + solution_filename)
			write_file(raw_output, solution_filename)
		x, objective, time = 'NA', 'NA', 'NA'
		try:
			xtext = filter(lambda x: x.startswith('x ='), raw_output.split("\n"))[0]
			x = eval(xtext.split('=')[1].strip())
		except:
			print('Error getting x: ' + str(solution_filename))
		try:
			obj_text = filter(lambda x: x.startswith('OBJECTIVE:'), raw_output.split("\n"))[0]
			objective = obj_text.split(':')[1].strip()
		except:
			print('Error getting objective: ' + str(solution_filename))
		try:
			if objective != 'NA':
				time = '0.0'
			time_text = filter(lambda x: x.startswith('Total'), raw_output.split("\n"))[0]
			time_list = time_text.split(' ')
			time = time_list[len(time_list) - 2]
		except:
			print('Error getting time: ' + str(solution_filename))
		h = {'text':raw_output, 'x':x, 'objective':objective, 'time':time}
		# print({'objective':objective, 'time':time})
		return h
	
	# Generate and solve an individual instance.
	def solve_instance(self, problem_id):
		dg = DataGenerator(self.params)
		init_prob_data = dg.build_initial_data()
		init_prob_data_file = self.prob_name(self.problem_path, 'init', self.problem_set_name, problem_id, '.dat')
		write_file(init_prob_data['text'], init_prob_data_file)
		init_sol_data_file = self.prob_name(self.solution_path, 'init', self.problem_set_name, problem_id, '.txt')
		init_sol_data = self.opl_solve(init_prob_data_file, init_sol_data_file)
		updated_prob_data = dg.build_updated_data(init_prob_data, init_sol_data['x'])
		updated_prob_data_file = self.prob_name(self.problem_path, 'updated', self.problem_set_name, problem_id, '.dat')
		write_file(updated_prob_data['text'], updated_prob_data_file)
		updated_sol_data_file = self.prob_name(self.solution_path, 'updated', self.problem_set_name, problem_id, '.txt')
		updated_sol_data = self.opl_solve(updated_prob_data_file, updated_sol_data_file)
		return {self.prob_name('', 'init', self.problem_set_name, problem_id):init_sol_data,
				self.prob_name('', 'updated', self.problem_set_name, problem_id):updated_sol_data}
	
	# Build and write a summary CSV file for the result set.
	def write_results_summary(self, results):
		sorted_keys = sorted(results.keys())
		text = ['Problem ID, Objective, Elapsed Time']
		print('Generating results summary file...')
		for key in sorted_keys:
			text.append(','.join([key, results[key]['objective'], results[key]['time']]))
		write_file("\n".join(text), self.solution_path + '/' + 'summary.csv')
		print('Done!')
	
	# Generate and solve all replicates in the problem set.
	def solve_problem_set(self):
		results = {}
		for i in range(1, self.num_replicates + 1):
			print('Solving problem ' + str(i) + ' in ' + self.problem_set_name + '...')
			sol = self.solve_instance(i)
			results.update(sol)
		self.write_results_summary(results)