require '../src/lib/comb_util'

include CombUtil

# Test bag_diff
b1 = [1,1,2,2,3,3]
b2 = [1,2,2,3,4,5,5]
p bag_diff b1, b2
p bag_diff b2, b1
p bag_diff b2, []
p bag_diff [], b2

# Test powerset
n = 10
p powerset((1..n).to_a)

# Test all_partitions
n = 6
pts = all_partitions((1..n).to_a, 3)
p pts.length
#pts.each{|pt| p pt}
