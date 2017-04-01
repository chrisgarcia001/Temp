require '../src/lib/rand_util'
require '../src/lib/util'
require '../src/lib/structs'
require '../src/lib/problem_gen'

include ProblemGen

p rand_exponential_func(0.9999, 0.92)

p rand_step_func(20, 3, 5)

p "\n--- PROB GENERATION ----"
prob = rand_problem(10, 2, 2)
#p prob.to_json
p prob.from_json(prob.to_json)

