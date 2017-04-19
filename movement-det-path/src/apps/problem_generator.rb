# This provides a problem generator based on the specified params. See the example.

require '../lib/util'
require '../lib/rand_util'
require '../lib/structs'
require '../lib/problem_gen'

include Structs
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


num_problems = params[:num_problems]
num_items = params[:num_items]
num_exp_paths = params[:num_exp_paths]
num_step_paths = params[:num_step_paths]
range_item_footprint = params[:range_item_footprint]
range_exp_const = params[:range_exp_const]
range_num_steps = params[:range_num_steps]
problem_class_name = params[:problem_class_name]
step_floor = params[:step_floor] || 0.0
max_total_footprint_frac = params[:max_total_footprint_frac] || 1.0
output_dir = params[:output_dir]

1.upto(num_problems) do |i|
  prob_name = problem_class_name + '_' + i.to_s
  puts 'Generating ' + prob_name + '...'
  prob = rand_problem(num_items, num_exp_paths, num_step_paths, range_item_footprint, 
                      range_exp_const, range_num_steps, step_floor)
  ofile = File.join(output_dir, prob_name + ".json")
  puts 'Outputting File: ' + ofile + '...'        
  write(prob.to_json, ofile)
  puts 'Done!'
end
