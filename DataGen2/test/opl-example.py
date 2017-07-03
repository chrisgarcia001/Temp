# This is an example of how to call from Python.
import subprocess 

model = '../models/ejor-sched-model-1.mod'
data = '../data/ejor-test-1.dat'

# Call a subprocess
#subprocess.check_call(['oplrun','../models/ejor-sched-model-1.mod','../data/EJOR/ejor-test-1.dat'])

# Call a subprocess and get the output as a string into a variable
raw_output = subprocess.check_output(['oplrun', model, data])
print("Raw Output:")
print(raw_output)
