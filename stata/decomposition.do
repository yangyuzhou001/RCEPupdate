import excel using ".\result\baseline\VAdecomposition_before.xlsx", clear
stack A-XZ, clear into(va)
gen part = ceil(_n/(65*65*18))
by part, sort : gen expid = ceil(_n/(65*18))
by part expid, sort : gen sectorid = ceil(_n/65)
by part expid sectorid, sort : gen impid = _n
drop _stack
save before.dta, replace

import excel using ".\result\baseline\VAdecomposition_after.xlsx", clear
stack A-XZ, clear into(va)
gen part = ceil(_n/(65*65*18))
by part, sort : gen expid = ceil(_n/(65*18))
by part expid, sort : gen sectorid = ceil(_n/65)
by part expid sectorid, sort : gen impid = _n
drop _stack
save after.dta, replace

use after.dta, clear
rename va vap 
merge 1:1 part expid sectorid impid using before.dta, nogenerate
keep if part == 10
drop part 
rename va* e*
merge 1:m expid sectorid impid using after.dta, nogenerate
rename va vap
merge 1:1 part expid sectorid impid using before.dta, nogenerate
drop if part == 10 
rename expid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
rename countryid expid

by expid part, sort : egen VA = sum(va)
by expid part, sort : egen VAp = sum(vap)
by expid, sort : egen E = sum(e)
replace E = E/9
by expid, sort : egen Ep = sum(ep)
replace Ep = Ep/9
gen Ehat = Ep/E
save ".\data\contribution.dta", replace

preserve
keep expid part VA* E* shortname RCEP
duplicates drop

gen weight = VA/E
gen VAhat = VAp/VA
gen contribution = 100*VAhat*weight/Ehat
#delimit ;
graph bar (sum) contribution if RCEP == 1, 
over(part) over(shortname) asyvar stack
ytitle("不同机制的增加值变化对出口增长的贡献(%)")
legend(label(1 "VA1") label(2 "VA2") label(3 "VA3") 
	   label(4 "VA4") label(5 "VA5") label(6 "VA6") 
	   label(7 "VA7") label(8 "VA8") label(9 "VA9") 
	   row(3))
scheme(s1color);
#delimit cr
graph export ".\figure\不同机制的增加值变化对出口增长的贡献.png", width(1342) height(976) replace
restore 

preserve
by expid impid, sort : egen VAn = sum(va)
by expid impid, sort : egen VAnp = sum(vap)
keep expid impid VAn* E* shortname RCEP
duplicates drop

gen weight = VAn/E
gen VAnhat = VAnp/VAn
gen contribution = 100*VAnhat*weight/Ehat
replace contribution = 0 if contribution == .
keep if RCEP == 1 
rename shortname expname
keep expname impid contribution 
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", keepusing(RCEP shortname) nogenerate
keep if RCEP == 1
rename shortname impname
encode expname, gen(expid)
encode impname, gen(impid)

format contribution %2.1f
#delimit ;
graph hbar contribution , over(impid) over(expid) asyvars stack 
	   ytitle("")
	  legend(row(2) symxsize(5))
	  scheme(s1color)
;
#delimit cr
graph export ".\figure\不同国家增加值变化对出口增长的贡献.png", width(1342) height(976) replace
restore

use ".\data\contribution.dta", clear
by expid sectorid, sort : egen VAj = sum(va)
by expid sectorid, sort : egen VAjp = sum(vap)
keep expid VAj* E* shortname RCEP sectorid
duplicates drop

gen weight = VAj/E
gen VAjhat = VAjp/VAj
gen contribution = 100*VAjhat*weight/Ehat
replace contribution = 0 if contribution == .
keep if RCEP == 1 
rename shortname expname
keep expname sectorid contribution 
encode expname, gen(expid)
merge m:1 sectorid using ".\data\sectorname2018.dta", nogenerate
preserve
keep sectorid sector
duplicates drop
gen code = "label define SECTOR " + string(sectorid) + `" ""' + sector + `"""'
replace code = code + ", add" in 2/l
keep code
outsheet using label.txt, nonames noquote replace
!copy label.txt label.do
restore
do label.do
erase label.do
erase label.txt
label value sectorid SECTOR
keep if expname == "CHN" | expname == "IND" | expname == "JPN" 
#delimit ;
graph hbar contribution , over(sectorid) scheme(s1color)
ytitle("") 
by(expname, style(compact) row(1) note("") noedgelabel);
gr_edit .plotregion1.grpaxis[2].draw_view.setstyle, style(no);
// grpaxis[2] edits

gr_edit .plotregion1.grpaxis[3].draw_view.setstyle, style(no);
#delimit cr
graph export ".\figure\不同部门增加值变化对出口增长的贡献.png", width(1342) height(976) replace


use ".\data\contribution.dta", clear
by expid impid sectorid, sort : egen va_all = sum(va)
by expid impid sectorid, sort : egen va_allp = sum(vap)
keep expid impid va_all* E* shortname RCEP sectorid
duplicates drop

gen weight = va_all/E
gen vahat = va_all/va_allp
gen contribution = 100*vahat*weight/Ehat
replace contribution = 0 if contribution == .
rename (shortname RCEP) (expname expRCEP)
keep exp* impid contribution sectorid Ehat
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", keepusing(RCEP shortname) nogenerate
rename (shortname RCEP) (impname impRCEP)
merge m:1 sectorid using ".\data\sectorname2018.dta", nogenerate

gsort - contribution
format contribution %2.1f
gen logCon = log10(contribution)
label define EXP 0 "非RCEP出口国" 1 "RCEP出口国"
label value expRCEP EXP

#delimit ;
twoway hist logCon if impRCEP == 1 , freq 
bfcolor(green) blcolor(black)
||
 hist logCon if impRCEP == 0, freq 
bfcolor(none) blcolor(red) 
||, 
by(expRCEP, rows(2) note(""))
legend(label(1 "RCEP国家") label(2 "非RCEP国家"))
xlabel(-6 "0.000001%" -5 "0.00001%" -4 "0.0001%" -3 "0.001%" -2 "0.01%" 
	   -1 "0.1%" 0 "1%" 1 "10%")
xtitle("不同国家不同部门增加值对出口总值的贡献")  ytitle("频次")
scheme(s1color)
;
#delimit cr
graph export ".\figure\不同国家不同部门增加值对出口总值的贡献.png", width(1342) height(976) replace

use ".\data\contribution.dta", clear
gen weight = va/E
gen vahat = vap/va
gen contribution = 100*weight*vahat/Ehat
keep shortname RCEP *id part Ehat contribution
rename (shortname RCEP) (expname expRCEP)
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", keepusing(RCEP shortname) nogenerate
rename (countryid shortname RCEP) (impid impname impRCEP)
merge m:1 sectorid using ".\data\sectorname2018.dta", nogenerate
gen logCon = log10(contribution)
format contribution %9.2f
preserve
gsort - impRCEP - expRCEP - contribution 
keep expname impname sector part contribution
keep in 1/10
order expname impname sector part contribution
tostring contribution, replace format(%9.2f) force
export excel ".\table\不同国家不同部门不同方式增长价值对出口总值的贡献(前十).xlsx", replace
restore

#delimit ;
twoway hist logCon if impRCEP == 1 & expRCEP == 1, freq 
||, 
by(part, rows(2) note(""))
legend(label(1 "RCEP国家") label(2 "非RCEP国家"))
xlabel(-6 "0.000001%" -5 "0.00001%" -4 "0.0001%" -3 "0.001%" -2 "0.01%" 
	   -1 "0.1%" 0 "1%" 1 "10%")
xtitle("不同国家不同部门不同方式增加值对出口总值的贡献")  ytitle("频次")
scheme(s1color)
;
#delimit cr

erase before.dta
erase after.dta
*******************************************************************************
/*
import excel using ".\result\baseline\ajk_ni.xlsx", clear
rename A-ARZ v#, addnumber
stack v1-v1170, into(a1-a18) clear
rename _stack impid
gen id = _n
by impid, sort : gen expid = ceil(_n/18)
by impid expid, sort : gen supid = _n
reshape long a, i(id) j(demid)
save ajk_ni.dta, replace

import excel using ".\result\baseline\bjk_ni.xlsx", clear
rename A-ARZ v#, addnumber
stack v1-v1170, into(b1-b18) clear
rename _stack impid
gen id = _n
by impid, sort : gen expid = ceil(_n/18)
by impid expid, sort : gen supid = _n
reshape long b, i(id) j(demid)
save bjk_ni.dta, replace

import excel using ".\result\baseline\bjk_ii.xlsx", clear
rename A-ARZ v#, addnumber
stack v1-v1170, into(bii1-bii18) clear
rename _stack impid
gen id = _n
by impid, sort : gen expid = ceil(_n/18)
by impid expid, sort : gen supid = _n
reshape long bii, i(id) j(demid)
save bjk_ii.dta, replace

import excel using ".\result\baseline\C.xlsx", clear
rename A-BM v#, addnumber
stack v1-v65, into(C) clear
rename _stack impid
by impid, sort : gen expid = ceil(_n/18)
by impid expid, sort : gen supid = _n
save C.dta, replace

import excel using ".\result\baseline\B.xlsx", clear
rename A-BM v#, addnumber
stack v1-v65, into(beta) clear
rename _stack countryid
by countryid, sort : gen sectorid = _n
save beta.dta, replace

import excel using ".\result\baseline\G.xlsx", clear
rename A-R v#, addnumber
stack v1-v18, into(gamma) clear
rename _stack demid
by demid, sort : gen impid = ceil(_n/18)
by demid impid, sort : gen supid = _n
save gamma.dta, replace

import excel using ".\result\baseline\Y.xlsx", clear
rename A-BM v#, addnumber
stack v1-v65, into(Y) clear
rename _stack expid
by expid, sort : gen supid = ceil(_n/65)
by expid supid, sort : gen impid = _n
save Y.dta, replace

use Y.dta, clear
by expid supid, sort : egen Ynj = sum(Y)
keep Ynj expid supid 
duplicates drop
rename (expid supid) (impid demid)
merge 1:m impid demid using ajk_ni.dta, keep(match) nogenerate
by impid expid supid, sort : egen Ynik = sum(a*Ynj)
keep impid expid supid Ynik
duplicates drop
merge 1:1 impid expid supid using C.dta, nogenerate
gen e = Ynik + C
replace e = 0 if impid == expid

use C.dta, clear
keep if impid == 2
rename impid destination
rename (expid supid) (impid demid)
merge 1:m impid demid using bjk_ni.dta, nogenerate
drop if destination == impid
drop if destination == expid
drop if expid == impid
keep if expid == 1
keep if supid == 2
rename (expid supid) (countryid sectorid)
merge m:1 countryid sectorid using beta.dta, keep(match) nogenerate
gen va = beta*C*b
egen VA = sum(va)
