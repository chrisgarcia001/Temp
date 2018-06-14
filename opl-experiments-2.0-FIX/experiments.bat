jruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/mm output/mm
jruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/mp output/mp
jruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/pm output/pm
jruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/pp output/pp

jruby ilog_output_summarizer.rb output/mm
jruby ilog_output_summarizer.rb output/mp
jruby ilog_output_summarizer.rb output/pm
jruby ilog_output_summarizer.rb output/pp