* Baier et al. (2019)
* Baier and Bergstrand (2007)


*For CP2015 

clear
cap erase ".\result\PPMLlagforeResult.csv"
cap mat drop _all
matrix define lcoeff = [1]
matrix define fcoeff = [1]
matrix define mcoeff = [1]
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'.dta"

capture log close
log using ".\log\sector`i'PPML.log", text replace

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] = 0
matrix lcoeff = [lcoeff, r(p)]
lincom _b[rta] + _b[l3rta]
matrix lcoeff = [lcoeff,_b[rta] + _b[l3rta],r(se)]

ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[f3rta] = 0
matrix fcoeff = [fcoeff, r(p)]
lincom _b[rta] + _b[f3rta]
matrix fcoeff = [fcoeff,_b[rta] + _b[f3rta],r(se)]

ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] + _b[f3rta] = 0
matrix mcoeff = [mcoeff, r(p)]
lincom _b[rta] + _b[l3rta] + _b[f3rta]
matrix mcoeff = [mcoeff,_b[rta] + _b[l3rta] + _b[f3rta],r(se)]

drop *

log close
}
matrix define coeff = [lcoeff \ fcoeff \ mcoeff]

svmat coeff, names(v)
drop v1
stack v*, into(p beta se)
by _stack, sort : gen id = _n
reshape wide p beta se, i(_stack) j(id)
gen l1 = subinstr(string(round(beta1,0.0001)),".","0.",.)
replace l1 = l1 + "*" if p1 <= 0.1
replace l1 = l1 + "*" if p1 <= 0.05
replace l1 = l1 + "*" if p1 <= 0.01
gen f1 = subinstr(string(round(beta2,0.0001)),".","0.",.)
replace f1 = f1 + "*" if p2 <= 0.1
replace f1 = f1 + "*" if p2 <= 0.05
replace f1 = f1 + "*" if p2 <= 0.01
gen m1 = subinstr(string(round(beta3,0.0001)),".","0.",.)
replace m1 = m1 + "*" if p3 <= 0.1
replace m1 = m1 + "*" if p3 <= 0.05
replace m1 = m1 + "*" if p3 <= 0.01
gen l2 = "(" + subinstr(string(round(se1,.0001)),".","0.",.) + ")"
gen f2 = "(" + subinstr(string(round(se2,.0001)),".","0.",.) + ")"
gen m2 = "(" + subinstr(string(round(se3,.0001)),".","0.",.) + ")"
keep l* f* m* _stack
reshape long l f m, i(_stack) j(id)
outsheet l f m using ".\result\PPMLlagforeResult.csv", nonames replace
********************************************************************************
*			RTA's effects through  NTB 
********************************************************************************

* For different intermediate and final trade cost change

use ".\data\total_ZF.dta", clear
log using ".\log\PPMLtotal_ZF.txt", text replace
cap eststo clear
drop if sectorid == 18
replace t1 = 1
gen Xm = Z*t1
gen Xf = F*t1
egen pair = group(importer exporter sectorid)
xtset pair year
replace Xm = round(Xm,1)
replace Xf = round(Xf,1)
gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
ppml_panel_sg Xm rta l3rta f3rta, ex(expid) im(impid) y(year) indu(sectorid) sym robust maxiter(200000)
lincom _b[rta] + _b[l3rta] + _b[f3rta]
eststo, add(beta r(estimate) se_plus r(se))
ppml_panel_sg Xf rta l3rta f3rta, ex(expid) im(impid) y(year) indu(sectorid) sym robust maxiter(200000)
lincom _b[rta] + _b[l3rta] + _b[f3rta]
eststo, add(beta r(estimate) se_plus r(se))
esttab * using ".\result\onlyTwoPPML.csv", cells(b(star fmt(4)) se(par fmt(4))) stat(beta se_plus) nomtitles nonumbers noobs nodepvars nonotes replace
log close

clear
cap erase ".\result\PPMLlagforeResult_Z.csv"
cap mat drop _all
matrix define lcoeff = [1]
matrix define fcoeff = [1]
matrix define mcoeff = [1]
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'ZF.dta"

log using ".\log\PPMLGravitysector`i'_Z.txt", text replace
gen X = Xm

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] = 0
matrix lcoeff = [lcoeff, r(p)]
lincom _b[rta] + _b[l3rta]
matrix lcoeff = [lcoeff,_b[rta] + _b[l3rta],r(se)]

ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[f3rta] = 0
matrix fcoeff = [fcoeff, r(p)]
lincom _b[rta] + _b[f3rta]
matrix fcoeff = [fcoeff,_b[rta] + _b[f3rta],r(se)]

ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] + _b[f3rta] = 0
matrix mcoeff = [mcoeff, r(p)]
lincom _b[rta] + _b[l3rta] + _b[f3rta]
matrix mcoeff = [mcoeff,_b[rta] + _b[l3rta] + _b[f3rta],r(se)]

drop *

log close
}
matrix define coeff = [lcoeff \ fcoeff \ mcoeff]

svmat coeff, names(v)
drop v1
stack v*, into(p beta se)
by _stack, sort : gen id = _n
reshape wide p beta se, i(_stack) j(id)
gen l1 = subinstr(string(round(beta1,0.0001)),".","0.",.)
replace l1 = l1 + "*" if p1 <= 0.1
replace l1 = l1 + "*" if p1 <= 0.05
replace l1 = l1 + "*" if p1 <= 0.01
gen f1 = subinstr(string(round(beta2,0.0001)),".","0.",.)
replace f1 = f1 + "*" if p2 <= 0.1
replace f1 = f1 + "*" if p2 <= 0.05
replace f1 = f1 + "*" if p2 <= 0.01
gen m1 = subinstr(string(round(beta3,0.0001)),".","0.",.)
replace m1 = m1 + "*" if p3 <= 0.1
replace m1 = m1 + "*" if p3 <= 0.05
replace m1 = m1 + "*" if p3 <= 0.01
gen l2 = "(" + subinstr(string(round(se1,.0001)),".","0.",.) + ")"
gen f2 = "(" + subinstr(string(round(se2,.0001)),".","0.",.) + ")"
gen m2 = "(" + subinstr(string(round(se3,.0001)),".","0.",.) + ")"
keep l* f* m* _stack
reshape long l f m, i(_stack) j(id)
outsheet l f m using ".\result\PPMLlagforeResult_Z.csv", nonames replace

clear
cap erase ".\result\PPMLlagforeResult_F.csv"
cap mat drop _all
matrix define lcoeff = [1]
matrix define fcoeff = [1]
matrix define mcoeff = [1]
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'ZF.dta"

log using ".\log\PPMLGravitysector`i'_F.txt", text replace
gen X = Xf

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] = 0
matrix lcoeff = [lcoeff, r(p)]
lincom _b[rta] + _b[l3rta]
matrix lcoeff = [lcoeff,_b[rta] + _b[l3rta],r(se)]

ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[f3rta] = 0
matrix fcoeff = [fcoeff, r(p)]
lincom _b[rta] + _b[f3rta]
matrix fcoeff = [fcoeff,_b[rta] + _b[f3rta],r(se)]

ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] + _b[f3rta] = 0
matrix mcoeff = [mcoeff, r(p)]
lincom _b[rta] + _b[l3rta] + _b[f3rta]
matrix mcoeff = [mcoeff,_b[rta] + _b[l3rta] + _b[f3rta],r(se)]

drop *

log close
}
matrix define coeff = [lcoeff \ fcoeff \ mcoeff]

svmat coeff, names(v)
drop v1
stack v*, into(p beta se)
by _stack, sort : gen id = _n
reshape wide p beta se, i(_stack) j(id)
gen l1 = subinstr(string(round(beta1,0.0001)),".","0.",.)
replace l1 = l1 + "*" if p1 <= 0.1
replace l1 = l1 + "*" if p1 <= 0.05
replace l1 = l1 + "*" if p1 <= 0.01
gen f1 = subinstr(string(round(beta2,0.0001)),".","0.",.)
replace f1 = f1 + "*" if p2 <= 0.1
replace f1 = f1 + "*" if p2 <= 0.05
replace f1 = f1 + "*" if p2 <= 0.01
gen m1 = subinstr(string(round(beta3,0.0001)),".","0.",.)
replace m1 = m1 + "*" if p3 <= 0.1
replace m1 = m1 + "*" if p3 <= 0.05
replace m1 = m1 + "*" if p3 <= 0.01
gen l2 = "(" + subinstr(string(round(se1,.0001)),".","0.",.) + ")"
gen f2 = "(" + subinstr(string(round(se2,.0001)),".","0.",.) + ")"
gen m2 = "(" + subinstr(string(round(se3,.0001)),".","0.",.) + ")"
keep l* f* m* _stack
reshape long l f m, i(_stack) j(id)
outsheet l f m using ".\result\PPMLlagforeResult_F.csv", nonames replace

