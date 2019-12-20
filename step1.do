version 14.0
clear all
set more off
capture log close

do ".\stata\sector2016.do"
do ".\stata\country2016.do"
do ".\stata\sector2018.do"
do ".\stata\country2018.do"
do ".\stata\tariff.do"
