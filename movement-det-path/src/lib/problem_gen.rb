include RandUtil
include Util
include Structs

module ProblemGen
  # Generate a random exponential function.
  def rand_exponential_func minv, maxv
    ExponentialFunction.new rand_float(minv, maxv)
  end
  
  # Generate a random decreasing step function
  def rand_step_func max_footprint, min_steps, max_steps
    steps = []
    step_ranges = interval_sample(0, max_footprint, rand_int(min_steps - 1, max_steps - 1)).sort + [max_footprint]
    probs = interval_sample(0, 1, step_ranges.length, 6).sort.reverse
    step_ranges.each_with_index do |footprint, i|
      steps << {'cum_footprint' => footprint, 'p' => probs[i]}
    end
    DecreasingStepFunction.new steps
  end
  
  # Generate a random problem.
  def rand_problem(n, num_exp_funcs, num_step_funcs, range_item_footprint=[1, 10],
                   range_exp_const=[0.98, 0.99999], range_num_steps=[3,8])
    items = (1..n).map{|i| rand_float(*range_item_footprint)}
    total_footprint = items.reduce{|x,y| x + y}
    prob_funcs = []
    1.upto(num_exp_funcs){prob_funcs << rand_exponential_func(*range_exp_const)}
    1.upto(num_step_funcs){prob_funcs << rand_step_func(*([total_footprint] + range_num_steps))}
    Problem.new items, prob_funcs
  end
end