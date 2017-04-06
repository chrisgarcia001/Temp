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
  puts 'Usage: > ruby ga_runner.rb <params file> ' + "\n"
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
alg_name = params[:alg_name] || 'GA'
input_dir = params[:input_dir]
output_dir = params[:output_dir]
solutions = []
Dir::foreach(input_dir) do |f|
  if f =~ /.json$/
    puts 'Solving Problem: ' + File.join(input_dir, f) 
    problem = Problem.new.from_json(read(File.join(input_dir, f)))
    ga = GeneticAlgorithm.new params
    sol = ga.solve(problem)
    sol[:problem_name] = f.split('')[0, f.split('').length - 5].join('')
    ofile = "#{alg_name}-" + f.split('')[0, f.split('').length - 5].join('') + ".json"
    puts "Done! \nWriting File: " + ofile + ', Elapsed Time: ' + sol[:elapsed_time].to_s
    write(JSON.generate(sol), File.join(output_dir, ofile))
    solutions << sol
  end
end
hashlist_to_csv solutions, File.join(output_dir, "summary-#{alg_name}.csv"), [:problem_name, :objective_func, :elapsed_time]
