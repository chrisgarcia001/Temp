require 'json'

# ------------------ Item representation -------------------------------
class Item
  attr_accessor :footprint, :path
  
  def initialize footprint=nil, path = nil
    @footprint = footprint
    @path = path
  end
end


# ----------------- Base class for probability functions ----------
class SuccessProbFunctionBase
  # Returns the JSON as a hash
  def to_json
    'Implement Me!'
  end
    
  # Returns true or false depending on whether this can be constructed from the given JSON
  def from_json json
    'Implement Me!'
  end
  
  # Calculates the P(Success | Cum. Footprint)
  def prob cum_footprint
    'Implement Me!'
  end
end

# ----------------- A simple BASE^x function, where BASE is in [0, 1] and x is non-negative -------
class ExponentialFunction < SuccessProbFunctionBase
  attr_accessor :base # Base is a number between 0 and 1 which will be raised to any nonnegative power
  
  def initialize base=nil
    @base = base
  end
  
  # Returns the JSON as a hash
  def to_json
    JSON.generate({'prob_function' => 'ExponentialFunction', 'base' => @base})
  end
    
  # Returns true or false depending on whether this can be constructed from the given JSON
  def from_json json
    json = JSON.parse(json) if json.class != {}.class
    if json['prob_function'] == 'ExponentialFunction'
      @base = json['base']
      return self
    end
    false
  end
  
  # Calculates the P(Success | Cum. Footprint)
  def prob cum_footprint
    @base ** cum_footprint
  end
end

# ----------------- A decreasing step function by arbitrary footprint levels ----------
# Creates a decreasing step function. Cumulative footprints are cut into step sections by cumulative footprint. Each higher level
# cumulative footprint range has its own lower probability of success for all values in range (previous level, current level]). 
# Anything cumulative footprint beyond the last level results in probability of 0. 
class DecreasingStepFunction < SuccessProbFunctionBase
  # @steps is a list of the form [{:cum_footprint => f, :p => p} , {:cum_footprint => f, :p => p} , ...] where each increasing position
  # has higher cum_footprint and <= p. It is always assumed that P(0) = 1.
  attr_accessor :steps
  
  def initialize steps=nil
    @steps = steps
  end
  
  # Returns the JSON as a hash
  def to_json
    JSON.generate({'prob_function' => 'DecreasingStepFunction', 'steps' => @steps})
  end
    
  # Returns true or false depending on whether this can be constructed from the given JSON
  def from_json json
    json = JSON.parse(json) if json.class != {}.class
    if json['prob_function'] == 'DecreasingStepFunction'
      @steps = json['steps']
      return self
    end
    false
  end
  
  # Calculates the P(Success | Cum. Footprint)
  def prob cum_footprint
    if cum_footprint > 0
      i = 0
      while i < @steps.length
        return @steps[i]['p'] if cum_footprint <= @steps[i]['cum_footprint']
        i += 1
      end
      return 0
    end
    1.0
  end
  
end

# -----------------  Will construct and return the appropriate probability function from the JSON --------
class ProbFunctionBuilder
  
  def initialize
    @functions = [ExponentialFunction.new, DecreasingStepFunction.new]
  end
  
  def build json
    @functions.each do |f|
      v = f.from_json json
      return v if v
    end
    nil
  end
end


# ----------------- This is the problem objective function ----------------------------------------------
# @param solution: Either 1) A list of Item objects in sequence, OR
#                         2) A list of lists - each inner list contains a sequence of item footprints and
#                            corresponds to a path.
# @param path_prob_funcs: A list of SuccessProbFunctionBase instances, corresponding the the different paths.
def objective_function solution, path_prob_funcs
  prob = 1
  cums = Array.new path_prob_funcs.length, 0
  if !solution.empty? and solution.first.class == [].class
    path_prob_funcs.each_with_index do |func, j|
      solution[j].each do |item_footprint|
        cums[j] += item_footprint
        prob *= func.prob(cums[j])
      end
    end
  else
    solution.each do|item| 
      cums[item.path] += item.footprint
      prob *= path_prob_funcs[item.path].prob(cums[item.path])
    end
  end
  prob
end
