# This provides a runner for the exact solver.

require '../lib/util'
require '../lib/rand_util'
require '../lib/comb_util'
require '../lib/structs'
require '../lib/algorithms'
require 'json'

include Structs
include OptimizationAlgorithms
include Util


def print_usage
  puts 'Usage: > ruby ls_runner.rb <params file> ' + "\n"
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
alg_name = params[:alg_name] || 'LS'
input_dir = params[:input_dir]
output_dir = params[:output_dir]
max_iterations = params[:max_iter]
max_unimprove_iterations = params[:max_unimprove_iter]
max_time = params[:max_time] 
max_unimprove_time = params[:max_unimprove_time]
mut_rate = params[:mutation_rate]
report_time_interval = params[:report_time_interval]
solutions = []
Dir::foreach(input_dir) do |f|
  if f =~ /.json$/
    puts 'Solving Problem: ' + File.join(input_dir, f) 
    problem = Problem.new.from_json(read(File.join(input_dir, f)))
    sol = local_search(problem, max_iterations, max_unimprove_iterations, max_time, 
                       max_unimprove_time, mut_rate, report_time_interval)
    sol[:problem_name] = f.split('')[0, f.split('').length - 5].join('')
    ofile = "#{alg_name}-" + f.split('')[0, f.split('').length - 5].join('') + ".json"
    puts "Done! \nWriting File: " + ofile + ', Elapsed Time: ' + sol[:elapsed_time].to_s
    sol.delete(:fitness)
    write(JSON.generate(sol), File.join(output_dir, ofile))
    solutions << sol
  end
end
hashlist_to_csv(solutions, File.join(output_dir, "summary-#{alg_name}.csv"), 
                [:problem_name, :objective_func, :best_find_time, :elapsed_time])
