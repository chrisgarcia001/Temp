mkdir problems
mkdir problems\base
mkdir problems\transp

rem python .\src\run_experiment.py .\params\base\mmmq.csv
rem python .\src\run_experiment.py .\params\base\mmms.csv
rem python .\src\run_experiment.py .\params\base\mmpq.csv
rem python .\src\run_experiment.py .\params\base\mmps.csv
rem python .\src\run_experiment.py .\params\base\mpmq.csv
rem python .\src\run_experiment.py .\params\base\mpms.csv
rem python .\src\run_experiment.py .\params\base\mppq.csv
rem python .\src\run_experiment.py .\params\base\mpps.csv

rem python .\src\run_experiment.py .\params\base\pmmq.csv
rem python .\src\run_experiment.py .\params\base\pmms.csv
rem python .\src\run_experiment.py .\params\base\pmpq.csv
rem python .\src\run_experiment.py .\params\base\pmps.csv
rem python .\src\run_experiment.py .\params\base\ppmq.csv
rem python .\src\run_experiment.py .\params\base\ppms.csv
rem python .\src\run_experiment.py .\params\base\pppq.csv
rem python .\src\run_experiment.py .\params\base\ppps.csv
del problems\base\*.dat

python .\src\run_experiment.py .\params\transp\mmmq.csv
python .\src\run_experiment.py .\params\transp\mmms.csv
python .\src\run_experiment.py .\params\transp\mmpq.csv
python .\src\run_experiment.py .\params\transp\mmps.csv
python .\src\run_experiment.py .\params\transp\mpmq.csv
python .\src\run_experiment.py .\params\transp\mpms.csv
python .\src\run_experiment.py .\params\transp\mppq.csv
python .\src\run_experiment.py .\params\transp\mpps.csv

python .\src\run_experiment.py .\params\transp\pmmq.csv
python .\src\run_experiment.py .\params\transp\pmms.csv
python .\src\run_experiment.py .\params\transp\pmpq.csv
python .\src\run_experiment.py .\params\transp\pmps.csv
python .\src\run_experiment.py .\params\transp\ppmq.csv
python .\src\run_experiment.py .\params\transp\ppms.csv
python .\src\run_experiment.py .\params\transp\pppq.csv
python .\src\run_experiment.py .\params\transp\ppps.csv
del problems\base\*.dat