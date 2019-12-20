*******************************************************************************
*			Why different trade type is important
*******************************************************************************
import excel using ".\result\Why different trade type is important\Xni_CP2015.xlsx", clear
rename A-IZ v#, addnumber
rename v1-v65 Xni#, addnumber
rename v66-v130 Direct#, addnumber
rename v131-v195 ExpIndi#, addnumber
rename v196-v260 ImpIndi#, addnumber

gen impid = _n
reshape long Xni Direct ExpIndi ImpIndi, i(impid) j(expid)

gen Directper = Direct/Xni
gen ExpIndiper = ExpIndi/Xni
gen ImpIndiper = ImpIndi/Xni

gen Indirectper = ExpIndiper + ImpIndiper

rename expid countryid
merge m:1 countryid using ".\data\countryname2018.dta" 
rename (countryid ICIOcountry name) (expid exp expName)
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
rename (countryid ICIOcountry name) (impid imp impName)

keep imp* exp* Xni RCEP
drop if impid > 65 | expid > 65


preserve
keep Xni impName impid expid
reshape wide Xni impName, i(impid) j(expid)
keep impName1 Xni* 
order imp Xni*
rename impName1 _varname
xpose, varname clear
gen countryid = subinstr(_varname,"Xni","",.)
destring countryid, replace
merge 1:1 countryid using".\data\countryname2018.dta", keepusing(name) nogenerate 
drop countryid _varname
rename name 出口国
order 出口国
export excel using ".\result\Why different trade type is important\世界贸易变化(CP2015).xlsx", firstrow(var) replace
restore


preserve
keep if RCEP == 1
keep Xni impName impid expid
reshape wide Xni impName, i(impid) j(expid)
rename impid countryid
merge 1:1 countryid using".\data\countryname2018.dta", keep(match) keepusing(name RCEP) nogenerate 
keep if RCEP == 1
keep impName1 Xni* 
order imp Xni*
rename impName1 _varname
xpose, varname clear
gen countryid = subinstr(_varname,"Xni","",.)
destring countryid, replace
merge 1:1 countryid using".\data\countryname2018.dta", keep(match) keepusing(name) nogenerate 
drop countryid _varname
rename name 出口国
order 出口国
export excel using ".\result\Why different trade type is important\RCEP贸易变化(CP2015).xlsx", firstrow(var) replace
restore

import excel using ".\result\Why different trade type is important\Yni_imp_exp_rcep_CP2015.xlsx", clear
rename A-BO v#, addnumber
rename v1-v65 Yni#, addnumber
rename (v66 v67) (impper expper)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", nogenerate


import excel using ".\result\Why different trade type is important\Xni_rcep.xlsx", clear
rename A-BM v#, addnumber
rename v1-v65 Xni#, addnumber

gen impid = _n
reshape long Xni, i(impid) j(expid)

rename expid countryid
merge m:1 countryid using ".\data\countryname2018.dta" 
rename (countryid ICIOcountry name) (expid exp expName)
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
rename (countryid ICIOcountry name) (impid imp impName)

keep imp* exp* Xni RCEP
drop if impid > 65 | expid > 65

preserve
keep Xni impName impid expid
reshape wide Xni impName, i(impid) j(expid)
keep impName1 Xni* 
order imp Xni*
rename impName1 _varname
xpose, varname clear
gen countryid = subinstr(_varname,"Xni","",.)
destring countryid, replace
merge 1:1 countryid using".\data\countryname2018.dta", keepusing(name) nogenerate 
drop countryid _varname
rename name 出口国
order 出口国
export excel using ".\result\Why different trade type is important\世界贸易变化(JIE2019).xlsx", firstrow(var) replace
restore


preserve
keep if RCEP == 1
keep Xni impName impid expid
reshape wide Xni impName, i(impid) j(expid)
rename impid countryid
merge 1:1 countryid using".\data\countryname2018.dta", keep(match) keepusing(name RCEP) nogenerate 
keep if RCEP == 1
keep impName1 Xni* 
order imp Xni*
rename impName1 _varname
xpose, varname clear
gen countryid = subinstr(_varname,"Xni","",.)
destring countryid, replace
merge 1:1 countryid using".\data\countryname2018.dta", keep(match) keepusing(name) nogenerate 
drop countryid _varname
rename name 出口国
order 出口国
export excel using ".\result\Why different trade type is important\RCEP贸易变化(JIE2019).xlsx", firstrow(var) replace
restore

