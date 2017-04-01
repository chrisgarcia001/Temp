require '../lib/util'
require '../lib/rand_util'
require '../lib/problem_gen'
require '../lib/structs'

include ProblemGen
include Util

def print_usage
  puts 'Usage: > ruby problem_generator.rb <params file> ' + "\n"
end

# --------- MAIN -----------------------------------------------
params = nil
begin
  params = read_params(ARGV[0])
  p params
rescue
  print_usage
  exit
end

#n, num_exp_funcs, num_step_funcs, item_footprint_range=[1, 10],
#                   range_exp_const=[0.98, 0.99999], range_num_steps=[3,8]

num_problems = params[:num_problems]
num_items = params[:num_items]
num_exp_paths = params[:num_exp_paths]
num_step_paths = params[:num_step_paths]
range_item_footprint = params[:range_item_footprint]
range_exp_const = params[:range_exp_const]
range_num_steps = params[:range_num_steps]
problem_class_name = params[:problem_class_name]
output_dir = params[:output_dir]

1.upto(num_problems) do |i|
  prob_name = problem_class_name + '_' + i.to_s
  puts 'Generating ' + prob_name + '...'
  prob = rand_problem(num_items, num_exp_paths, num_step_paths, range_item_footprint, 
                      range_exp_const, range_num_steps)
  ofile = File.join(output_dir, prob_name + ".json")
  puts 'Outputting File: ' + ofile + '...'        
  write(prob.to_json, ofile)
  puts 'Done!'
end
