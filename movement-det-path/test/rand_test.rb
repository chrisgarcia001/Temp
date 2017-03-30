require '../src/lib/rand_util'

include RandUtil

a = (1..15).to_a.map{|x| rand_int(5, 10)}
b = [0]
a.each_with_index{|v,i| b[i+1] = v + b[i]}
p b
p b.length

puts 'Selections (float):'
max = b.last
1.upto(5) do
  r = rand_float(b.min, b.max)
  i = roulette_wheel_select(b, r)
  puts "Rand val = #{r}, index = #{i}, upper/lower = #{[b[i], b[[i+1, b.length - 1].min]]}" 
end

puts 'Selections (int):'
max = b.last
1.upto(40) do
  # r = rand_int(b.min, b.max+10) # Test the <= case
  r = rand_int(b.min, b.max)
  i = roulette_wheel_select(b, r)
  puts "Rand val = #{r}, index = #{i}, max = #{b.max}, upper/lower = #{[b[i], b[[i+1, b.length - 1].min]]}" 
end

p seq(4, 101, 3)
p seq(1,10)

p (1..10).to_a.map{|x| rand_float(0.3, 0.5)}

puts 'Bin Search'
1.upto(20) do
  a = sample(1, 100, 10).sort
  i = sample(0,9,1)[0]
  puts "i: #{i}, binsearch index: #{binary_search(a, a[i]){|x| x}}"
end
