mkdir ..\..\output\
mkdir ..\..\output\experiment
mkdir ..\..\output\experiment\small

rem ruby ..\apps\exact_solver_runner.rb ..\..\params\experiment\solve\exact-exp.csv
rem ruby ..\apps\greedy_solver_runner.rb ..\..\params\experiment\solve\greedy-exp.csv
rem ruby ..\apps\ls_runner.rb ..\..\params\experiment\solve\ls-exp.csv
rem ruby ..\apps\ga_runner.rb ..\..\params\experiment\solve\ga-exp.csv

jruby -J-Xmx16384m ..\apps\exact_solver_runner.rb ..\..\params\experiment\solve\exact-exp.csv
jruby -J-Xmx16384m ..\apps\greedy_solver_runner.rb ..\..\params\experiment\solve\greedy-exp.csv
jruby -J-Xmx16384m ..\apps\ls_runner.rb ..\..\params\experiment\solve\ls-exp.csv
jruby -J-Xmx16384m ..\apps\ga_runner.rb ..\..\params\experiment\solve\ga-exp.csv