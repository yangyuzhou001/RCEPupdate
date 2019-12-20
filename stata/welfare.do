import excel using ".\result\Why different trade type is important\RealWage_rcep_CP2015.xlsx", clear
rename A wage
gen countryid = _n
preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name RCEP) nogenerate
keep if RCEP == 1
replace wage = 100*(wage - 1)
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\Why different trade type is important\RCEP实际工资变化(CP2015).xlsx", firstrow(varl) replace
restore


preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name) nogenerate
replace wage = 100*(wage - 1)
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\Why different trade type is important\世界实际工资变化(CP2015).xlsx", firstrow(varl) replace
restore

import excel using ".\result\Why different trade type is important\RealWage_rcep.xlsx", clear
rename A wage
gen countryid = _n
preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name RCEP) nogenerate
keep if RCEP == 1
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\Why different trade type is important\RCEP实际工资变化(JIE2019).xlsx", firstrow(varl) replace
restore


preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name) nogenerate
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\Why different trade type is important\世界实际工资变化(JIE2019).xlsx", firstrow(varl) replace
restore

import excel using ".\result\baseline\RealWage_rcep_diff.xlsx", clear
rename A wage
gen countryid = _n
preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name RCEP) nogenerate
keep if RCEP == 1
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\baseline\RCEP实际工资变化(JIE2019).xlsx", firstrow(varl) replace
restore


preserve
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(name) nogenerate
tostring *, replace format(%9.2f) force 
replace wage = wage + "%"
keep wage name
label var wage "实际工资变化"
export excel using ".\result\baseline\世界实际工资变化(JIE2019).xlsx", firstrow(varl) replace
restore
