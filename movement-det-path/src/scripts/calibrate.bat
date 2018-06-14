rem ruby ..\apps\greedy_solver_runner.rb ..\..\params\calibration-solve\greedy-calib.csv
jruby -J-Xmx16384m ..\apps\greedy_solver_runner.rb ..\..\params\calibration-solve\greedy-calib.csv

rem ruby ..\apps\ga_runner.rb ..\..\params\calibration-solve\ga-calib.csv
jruby -J-Xmx16384m ..\apps\ga_runner.rb ..\..\params\calibration-solve\ga-calib.csv