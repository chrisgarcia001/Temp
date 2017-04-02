require 'pmap'

include Structs
include CombUtil

module OptimizationAlgorithms
  
  # Provide an exaxt solution for small problems. Uses the all-partition methods.
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
  
  # Provides a GA implementation.
  class GeneticAlgorithm
    def initialize pop_size, crossover_rate, mutation_rate, elitism
      @population_size = pop_size
      @crossover_rate = crossover_rate
      @mutation_rate = mutation_rate
      @elitism = elitisms
    end
    
    def crossover s1, s2
      if rand < @crossover_rate
        0
        # TODO: Implement!
      end
      s1, s2
    end
  end
  
end