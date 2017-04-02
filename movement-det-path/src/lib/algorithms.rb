require 'pmap'

include Structs
include CombUtil
include RandUtil

module OptimizationAlgorithms
  
  # Provides an exact solution for small problems. Uses the all-partition method.
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
    
    # Simple single-point crossover, where paths of items are swapped.
    # Here, s1 and s2 are sequences of Item objects.
    def crossover s1, s2
      b1, b2 = s1.map{|i| i.clone}, s2.map{|i| i.clone}
      if rand <= @crossover_rate
        point = rand_int(1, s1.length - 1)
        0.upto(s1.length - 1) do |i|
          if i < point
            b2.path = s1.path
          else
            b1.path = s2.path
          end
        end
      end
      [b1, b2]
    end
  
  
    # Mutate by randomly changing paths. Here, s is a sequence of Item objects.
    def mutate s, num_paths
      b = s.map{|i| i.clone}
      b.each{|i| i.path = sample_from((0..(num_paths - 1)).to_a - [i.path], 1)[0] if rand <= @mutation_rate and num_paths > 1}
      b
    end
    
    # TODO: Finish implementing and debug!
  
  end # End GA
  
end