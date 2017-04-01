module RandUtil
  
  # Performs a binary search on sorted list of elements. If element value needs explicit 
  # calculation/accessing logic, use block &accessorf to get element value.
  # Returns: The index with largest value <= value param.
  def binary_search sorted_arr, value, &accessorf #accessorf = Proc(array_element) -> value
    return nil if sorted_arr.empty?
    accessorf = Proc.new{|val| val} if !accessorf
    lo = 0; hi = sorted_arr.length - 1
    while hi - lo > 1  do
      if value < accessorf.call(sorted_arr[lo + ((hi - lo) / 2)])
        hi = lo + ((hi - lo) / 2)
      else 
        lo = lo + ((hi - lo) / 2)
      end
    end
    lo += 1 if (lo == sorted_arr.length - 2) and accessorf.call(sorted_arr[lo + 1]) <= value
    lo
  end
  
  # Fast roulette-wheel selection. Cumulative weights is list, and weight is a single cumulative weight.
  # Returns the appropriate array index.
  def roulette_wheel_select cumulative_weights, weight
    binary_search(cumulative_weights, weight)
  end
  
  def rand_int min, max
    min + rand(max + 1 - min)
  end
  
  def rand_float min, max
    min + (rand * (max - min))
  end
  
  def seq from, to, by = 1
    vals = [from]
    while vals.last + by <= to do
      vals << vals.last + by
    end
    vals
  end
  
  # Take a discrete sample in range [from, to]
  def discrete_sample from, to, n
    samp = []
    range = (from..to).to_a
    while n > 0 and range.length > 0
      samp << range.delete_at(rand(range.length))
      n -= 1
    end
    samp
  end
  
  # Take a continuous sample over the specified range.
  def interval_sample from, to, n, round_digits=3
    samp = []
    1.upto(n){|i| samp << (rand * (to - from)) + from}
    samp = samp.map{|i| i.round(round_digits)} if round_digits
    samp
  end
  
  # Given an array of elements, get a random sample of n elements
  def sample_from arr, n
    sample(0, arr.length - 1, n).map{|i| arr[i]}
  end
  
end