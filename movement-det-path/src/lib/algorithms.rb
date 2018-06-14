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
  
  # A greedy algorithm which provides fast but not necessarily optimal solutions.
  def greedy_solve problem
    start_time = Time.now
    items = problem.item_footprints.sort
    current = []
    items.each do |footprint|
      cands = (0..problem.path_funcs.length - 1).to_a.map do |path|
        c = current.map{|i| i.clone}
        c << Item.new(footprint, path)
        c
      end.map{|s| {:solution => s, :objective_func => objective_function(s, problem.path_funcs)}}
      current = cands.reduce{|x,y| x[:objective_func] > y[:objective_func] ? x : y}[:solution]
    end
    {:solution => current, :objective_func => objective_function(current, problem.path_funcs), 
     :elapsed_time => Time.now - start_time}
  end
  
  # Mutate by randomly changing paths. Here, s is a sequence of Item objects.
  def mutate s, num_paths, mut_rate
    b = s.map{|i| i.clone}
    b.each{|i| i.path = sample_from((0..(num_paths - 1)).to_a - [i.path], 1)[0] if rand <= mut_rate and num_paths > 1}
    b
  end
  
  # Perform a local search, starting with the greedy output.
  def local_search(problem, max_iterations, max_unimprove_iterations, max_time, 
                   max_unimprove_time, mut_rate, report_time_interval = 2)
    best = greedy_solve(problem)[:solution]
    best_find_time = 0
    iter = 1
    unimprove_iter = 1
    unimprove_start_time = Time.now
    last_improve_time = Time.now
    start_time = Time.now
    last_rep_time = Time.now
    while ((!max_iterations || iter <= max_iterations) and 
           (!max_unimprove_iterations || unimprove_iter <= max_unimprove_iterations) and
           (!max_time || (Time.now - start_time).to_i <= max_time) and 
           (!max_unimprove_time || (Time.now - last_improve_time).to_i <= max_unimprove_time)) do
      nxt = mutate(best, problem.path_funcs.length, mut_rate) 
      if objective_function(nxt, problem.path_funcs) > objective_function(best, problem.path_funcs)    
        unimprove_start_time = Time.now
        last_improve_time = Time.now
        unimprove_iter = 1
        best = nxt
        best_find_time = Time.now - start_time
      else
        unimprove_iter += 1
      end
      iter += 1
      if (Time.now - last_rep_time).to_i >= report_time_interval
        msg = "Iteration = #{iter}, Obj = #{objective_function(best, problem.path_funcs)}, "
        msg += "Elapsed Time = #{Time.now - start_time}"
        puts msg
        last_rep_time = Time.now
      end
    end
    {:solution => best, :objective_func => objective_function(best, problem.path_funcs), 
     :elapsed_time => Time.now - start_time, :best_find_time => best_find_time}
  end
  
  # Provides a GA implementation.
  class GeneticAlgorithm
    def initialize params #pop_size, crossover_rate, mutation_rate, elitism
      @input_dir = params[:input_dir]
      @output_dir = params[:output_dir]
      @pop_size_multiplier = params[:pop_size_multiplier]
      @max_time = params[:max_time]
      @max_iter = params[:max_iter]
      @max_unimprove_time = params[:max_unimprove_time]
      @max_unimprove_iter = params[:max_unimprove_iter]
      @crossover_rate = params[:crossover_rate]
      @mutation_rate = params[:mutation_rate]
      @elitism = params[:elitism] || 0.0
      @greedy_seed_proportion = params[:greedy_seed_proportion] || 0.0
      @greedy_mutation_rate = params[:greedy_mutation_rate] || 0.0
    end
    
    # Simple single-point crossover, where paths of items are swapped.
    # Here, s1 and s2 are sequences of Item objects.
    def crossover s1, s2
      b1, b2 = s1.map{|i| i.clone}, s2.map{|i| i.clone}
      if rand <= @crossover_rate
        point = rand_int(1, s1.length - 1)
        0.upto(s1.length - 1) do |i|
          if i < point
            b2[i].path = s1[i].path
          else
            b1[i].path = s2[i].path
          end
        end
      end
      [b1, b2]
    end
    
    # Check to see if termination conditions reached.
    def terminate?
      if ((@max_time and @start_time and (Time.now - @start_time).to_i >= @max_time) or
          (@max_unimprove_time and (Time.now - @current_unimprove_time).to_i > @max_unimprove_time) or
          (@max_iter and @current_iter >= @max_iter) or
          (@max_unimprove_iter and @current_unimprove_iter >= @max_unimprove_iter))
        return true
      end
       false
    end
       
    # Generate the initial population.
    def initial_population problem
      n = problem.path_funcs.length
      @population_size = (@pop_size_multiplier * problem.item_footprints.length).to_i
      init_pop = []
      gs = greedy_solve(problem)[:solution]
      1.upto((@greedy_seed_proportion * @population_size) - 1) do |s|
        if s == 1
          init_pop << gs
        else
          init_pop << mutate(gs, problem.path_funcs.length, @greedy_mutation_rate)
        end
      end
      while init_pop.length < @population_size do
        init_pop << problem.item_footprints.sort.map{|i| Item.new(i, rand_int(0, n - 1))}
      end
      init_pop
    end
    
    # GA solution method
    def solve problem
      @start_time = Time.now
      @current_iter = 1
      @current_unimprove_time = Time.now
      @current_unimprove_iter = 0
      @population_size = -1
      population = initial_population(problem)
      best = nil
      while !terminate? do
        next_pop = []
        evaluated_pop = population.pmap{|s| {:solution => s, :objective_func => objective_function(s, problem.path_funcs)}}.sort{|x,y| x[:objective_func] <=> y[:objective_func]}
        if @elitism
          next_pop = evaluated_pop.reverse[0..(@elitism * @population_size)].pmap{|x| x[:solution].map{|i| i.clone}}
        end
        if best == nil or evaluated_pop.last[:objective_func] > best[:objective_func]
          @current_unimprove_time = Time.now
          @current_unimprove_iter = 0
          best = evaluated_pop.last 
          best[:best_find_time] = Time.now - @start_time
          if best[:objective_func] == 1.0
            best[:elapsed_time] = best[:best_find_time]
            return best
          end
        end
        puts "  Iteration: #{@current_iter}: best objective function value = #{best[:objective_func]}, elapsed time = #{Time.now - @start_time} sec." 
        min_obj = evaluated_pop.pmap{|x| x[:objective_func]}.min
        evaluated_pop.peach{|x| x[:fitness] = 0.00001 + ((x[:objective_func] / min_obj) - 1)}
        fits = evaluated_pop.pmap{|x| x[:fitness]}
        cum_fit = fits.reduce{|x,y| x + y}
        next_pop += (1..(@population_size * (1.0 - @elitism)).ceil).to_a.pmap do |i|
          i1, i2 = roulette_wheel_select(fits, rand_float(0,cum_fit)), roulette_wheel_select(fits, rand_float(0,cum_fit))
          crossover(evaluated_pop[i1][:solution], evaluated_pop[i1][:solution])
        end.reduce{|x,y| x + y}
        next_pop = next_pop.pmap{|s| mutate(s, problem.path_funcs.length, @mutation_rate)}
        while next_pop.length < @population_size and !evaluated_pop.empty? do
          next_pop << evaluated_pop.pop[:solution]
        end
        population = next_pop
        @current_iter += 1
      end
      best[:elapsed_time] = Time.now - @start_time
      best
    end
  
  end # End GA
  
end