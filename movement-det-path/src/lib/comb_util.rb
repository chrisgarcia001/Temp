# A library of combinatorial and set algorithms.

module CombUtil
  
  # Generate the power set for the list of items.
  def powerset items
    return [[]] if items.empty?
    rest = powerset(items.last(items.length - 1))
    curr = rest.map{|i| [items.first] + i}
    curr + rest
  end
  
  # Returns a hash of number of counts for each unique item, of form {item => count}.
  def table items
    h = []
    items.each do |i|
      h[i] = 0 if !h.has_key? i
      h[i] += 1
    end
    h
  end
  
  # For a given table (in form outputted above), construt a list/bag.
  def detable table
    a = []
    table.each{|item, count| 1.upto(count){a << item}}
    a.sort
  end
  
  # The difference between two bags.
  def bag_diff a, b
    t1 = table a
    t2 = table b
    t1.each{|item, count| t1[item] -= t2[item] if t2.has_key? item}
    detable t1
  end
  
  # Generate every possible partitioning of the items into the specified number of groups.
  def all_partitions items, num_groups
    if num_groups == 1
      return powerset(items).map{|s| [s]}
    else
      ps = powerset(items)
      comp_ps = ps.map{|s| bag_diff(items, s)}
      
    end
  end
  
end