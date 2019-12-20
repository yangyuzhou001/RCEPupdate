version 14.0
clear all
set more off
capture log close

do ".\stata\welfare.do"
do ".\stata\Xni.do"
do ".\stata\VAX.do"
do ".\stata\baseline.do"
do ".\stata\Why different trade type is important.do"
do ".\stata\NoJPNandIND.do"
do ".\stata\decomposition.do"
do ".\stata\NoJPNandINDcontribution.do"
