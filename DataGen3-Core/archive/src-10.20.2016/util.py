import csv

# Try to turn a value into a float - otherwise just return the value.
def to_float_if_possible(val):
	try:
		return float(val)
	except:
		None
	return val

# Read in a set of params via a CSV file. Assumes all values are numeric.
def read_params(path, lowercase_keys=True):
	params = {}
	with open(path, 'rb') as csvfile:
		reader = csv.reader(csvfile)
		for row in reader:
			if not(row[0].startswith('#')):
				key = row[0].lower() if lowercase_keys else row[0]
				rest = map(to_float_if_possible, filter(lambda y: not(y in ['', None, ' ']), row[1:]))
				if len(rest) == 1:
					rest = rest[0]
				params[key] = rest
	return params

# Build a dimensional matrix of specified dimension and repeated value.	
def dim_matrix(rows, columns, val=None):
	matrix = []
	for i in range(rows):
		matrix.append([val] * columns)
	return matrix

# Transform a value/list/matrix
def transform(v, transform_f):
	if type(v) == type([]):
		return map(lambda x: transform(x, transform_f), v)
	return transform_f(v)

# Smart cast to int.	
def to_int(v):
	return transform(v, lambda x: int(x))

# Generate matrix index tuples covering the specified row and column range.	
def matrix_index_tuples(rows, columns):
	t = []
	for i in range(rows):
		for j in range(columns):
			t.append((i,j))
	return t

# Generate row index tuples covering the specified row and columns.	
def row_index_tuples(row, num_columns):
	t = []
	for j in range(num_columns):
		t.append((row, j))
	return t

# Write text to a file.	
def write_file(output_text, filename):
	file = open(filename, 'w')
	file.write(output_text)
	file.close()