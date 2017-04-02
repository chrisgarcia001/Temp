require 'pmap'

include Structs
include CombUtil

module OptimizationAlgorithms
  
  def exact_solve problem
    start_time = Time.now
    items = problem.item_footprints.sort
    solutions = all_partitions(items, problem.path_funcs.length)
    solutions = solutions.pmap{|s| {:solution => s, :objective_func => objective_function(s, problem.path_funcs)}}
    opt = solutions.first
    solutions.each{|s| opt = s if s[:objective_func] > opt[:objective_func]}
    opt[:elapsed_time] = Time.now - start_time
    opt
  end
  
end