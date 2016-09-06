ruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/mm output/mm
ruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/mp output/mp
ruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/pm output/pm
ruby batch_oplrun.rb single-machine-mp-FIXED-timed.mod data/pp output/pp

ruby ilog_output_summarizer.rb output/mm
ruby ilog_output_summarizer.rb output/mp
ruby ilog_output_summarizer.rb output/pm
ruby ilog_output_summarizer.rb output/pp