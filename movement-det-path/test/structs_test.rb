require '../src/lib/structs'

expf_json = '{"prob_function":"ExponentialFunction", "base":0.87}'
steps = '[{"cum_footprint":5,"p":95},{"cum_footprint":10,"p":82}]'
step_json = '{"prob_function":"DecreasingStepFunction", "steps":' + steps + '}'

builder = ProbFunctionBuilder.new
#expf = ExponentialFunction.new
#expf = expf.from_json(expf_json)

expf = builder.build(expf_json)
stepf = builder.build(step_json)

puts "\n----- Exponential Function Test ----------"
[0, 2, 6, 12].map{|c| puts expf.prob(c)}

puts "\n----- Decreasing Step Function Test ----------"
[0, 2, 6, 12].map{|c| puts stepf.prob(c)}

puts "\n----- Test JSON Generation ----------"
puts expf.to_json
puts stepf.to_json

