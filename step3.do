version 14.0
clear 
set more off
eststo clear
set maxvar 10000
set matsize 10000
capture log close

do ".\cp\Estimation.do"
do ".\stata\prepare.do"
do ".\stata\main.do"
do ".\stata\beta.do"
do ".\stata\further.do"
do ".\stata\describe.do"

