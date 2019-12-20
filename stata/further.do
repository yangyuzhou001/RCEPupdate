cap erase ".\result\result.csv"
cap erase ".\result\OLSresult.csv"
cap erase ".\result\PPMLresult.csv"
forvalues i = 1/17{
cap log close
cap eststo clear
use ".\data\OLSGravitysector`i'.dta", clear
log using ".\log\OLSsector`i'.log", text replace
eststo : reghdfe logX rta $D if expid != impid, absorb(impyear expyear) vce(cluster lambda)
eststo : reghdfe logX rta, absorb(impyear expyear lambda) vce(cluster lambda)
esttab * using ".\result\OLSresult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
*esttab * using ".\result\result.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append

cap log close

use ".\data\PPMLGravitysector`i'.dta", clear
log using ".\log\PPMLsector`i'.log", text replace
eststo : ppml_panel_sg X rta $D if expid != impid, ex(expid) im(impid) y(year) nopair robust maxiter(200000)
eststo : ppml_panel_sg X rta, ex(expid) im(impid) y(year) sym robust maxiter(200000)
esttab * using ".\result\PPMLresult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
esttab * using ".\result\result.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append

cap log close
}
* prove Dai et al. (2014)'s idea
cap erase ".\result\AltOLSresult.csv"
cap erase ".\result\AltPPMLresult.csv"
cap erase ".\result\Altresult.csv"
forvalues i = 1/17{
cap log close
cap eststo clear
use ".\data\OLSGravitysector`i'.dta", clear
*log using ".\log\OLSsector`i'.log", text replace
eststo : reghdfe logX rta $D, absorb(impyear expyear) vce(cluster lambda)
eststo : reghdfe logX rta if expid != impid, absorb(impyear expyear lambda) vce(cluster lambda)
esttab * using ".\result\AltOLSresult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
*esttab * using ".\result\result.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append

*cap log close

use ".\data\PPMLGravitysector`i'.dta", clear
*log using ".\log\PPMLsector`i'.log", text replace
eststo : ppml_panel_sg X rta $D, ex(expid) im(impid) y(year) nopair robust maxiter(200000)
eststo : ppml_panel_sg X rta if expid != impid, ex(expid) im(impid) y(year) sym robust maxiter(200000)
esttab * using ".\result\AltPPMLresult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
esttab * using ".\result\Altresult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append

*cap log close
}
cap erase ".\data\ci.csv"
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'.dta", clear
cap eststo clear
eststo : ppml_panel_sg X rta, ex(expid) im(impid) y(year) sym robust maxiter(200000)
esttab * using ".\data\ci.csv", cells("b(star fmt(4)) ci(par fmt(4))") stat() nomtitles noobs nonumbers nodepvars nonotes append
}
* Argriculture + Manufacture
use ".\data\total.dta", clear
cap eststo clear
drop if sectorid == 18
replace t1 = 1
gen X = Y*t1
replace X = round(X,1)
eststo:ppml_panel_sg X rta, ex(expid) im(impid) y(year) indu(sectorid) sym robust maxiter(200000)
esttab * using ".\result\onlyOnePPML.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes replace
esttab * using ".\data\ci.csv", cells("b(star fmt(4)) ci(par fmt(4))") stat() nomtitles noobs nonumbers nodepvars nonotes append


cap erase ".\result\lagforeResult.csv"
forvalues i = 1/17{
cap eststo clear
use ".\data\PPMLGravitysector`i'.dta", clear

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .

eststo : qui ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
eststo : qui ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
eststo : qui ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)

esttab * using ".\result\lagforeResult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append 
esttab * using ".\result\lagResult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(l3rta) append 
esttab * using ".\result\foreResult.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(f3rta) append 
}

cap erase ".\result\resultZF.csv"
cap erase ".\result\OLSresultZF.csv"
cap erase ".\result\PPMLresultZF.csv"
forvalues i = 1/17{
cap eststo clear
/*
use ".\data\OLSGravitysector`i'ZF.dta", clear
eststo : reghdfe logX rta $D if expid != impid, absorb(impyear expyear) vce(cluster lambda)
eststo : reghdfe logX rta, absorb(impyear expyear lambda) vce(cluster lambda)
esttab * using ".\result\OLSresultZF.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
*esttab * using ".\result\result.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append
*/
use ".\data\PPMLGravitysector`i'ZF.dta", clear
eststo : ppml_panel_sg Xm rta, ex(expid) im(impid) y(year) sym robust maxiter(200000)
eststo : ppml_panel_sg Xf rta, ex(expid) im(impid) y(year) sym robust maxiter(200000)
esttab * using ".\result\PPMLresultZF.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes append
esttab * using ".\result\resultZF.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes keep(rta) append

cap log close
}

/*
********************************************************************************
*			RTA's effects through NTB  using JIE(2019)
********************************************************************************
use ".\data\total_ZF.dta", clear
cap eststo clear
drop if sectorid == 18
merge m:1 sectorid using ".\data\theta.dta", nogenerate
gen Xm = Z*t1
gen Xf = F*t1
replace Xm = round(Xm,1)
replace Xf = round(Xf,1)
by year impid sectorid, sort : egen Xmsum = sum(Xm)
by year impid sectorid, sort : egen Xfsum = sum(Xf)
replace Xm = Xm/Xmsum
replace Xf = Xf/Xfsum
replace Xm = Xm/(t1^theta)
replace Xf = Xf/(t1^theta)

eststo:ppml_panel_sg Xm rta, ex(expid) im(impid) y(year) indu(sectorid) sym robust maxiter(200000)
eststo:ppml_panel_sg Xf rta, ex(expid) im(impid) y(year) indu(sectorid) sym robust maxiter(200000)
esttab * using ".\result\onlyTwoPPML_NTB.csv", cells(b(star fmt(4)) se(par fmt(4))) stat() nomtitles nonumbers noobs nodepvars nonotes replace

clear
cap erase ".\result\PPMLlagforeResult_Z_NTB.csv"
cap mat drop _all
matrix define lcoeff = [1]
matrix define fcoeff = [1]
matrix define mcoeff = [1]
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'ZF.dta"

capture log close
gen X = Xm
gen sectorid = `i'
merge m:1 sectorid using ".\data\theta.dta", nogenerate
replace X = X/(t1^theta)

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
qui ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] = 0
matrix lcoeff = [lcoeff, r(p)]
lincom _b[rta] + _b[l3rta]
matrix lcoeff = [lcoeff,_b[rta] + _b[l3rta],r(se)]

qui ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[f3rta] = 0
matrix fcoeff = [fcoeff, r(p)]
lincom _b[rta] + _b[f3rta]
matrix fcoeff = [fcoeff,_b[rta] + _b[f3rta],r(se)]

qui ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] + _b[f3rta] = 0
matrix mcoeff = [mcoeff, r(p)]
lincom _b[rta] + _b[l3rta] + _b[f3rta]
matrix mcoeff = [mcoeff,_b[rta] + _b[l3rta] + _b[f3rta],r(se)]

drop *
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
outsheet l f m using ".\result\PPMLlagforeResult_Z_NTB.csv", nonames replace

clear
cap erase ".\result\PPMLlagforeResult_F_NTB.csv"
cap mat drop _all
matrix define lcoeff = [1]
matrix define fcoeff = [1]
matrix define mcoeff = [1]
forvalues i = 1/17{
use ".\data\PPMLGravitysector`i'ZF.dta"

capture log close
gen X = Xf
merge m:1 sectorid using ".\data\theta.dta", nogenerate
replace X = X/(t1^theta)

encode pair, gen(pair_id)
xtset pair_id year

gen f3rta = f3.rta
replace f3rta = 0 if f3rta == .
gen l3rta = l3.rta
replace l3rta = 0 if l3rta == .
qui ppml_panel_sg X rta l3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] = 0
matrix lcoeff = [lcoeff, r(p)]
lincom _b[rta] + _b[l3rta]
matrix lcoeff = [lcoeff,_b[rta] + _b[l3rta],r(se)]

qui ppml_panel_sg X rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[f3rta] = 0
matrix fcoeff = [fcoeff, r(p)]
lincom _b[rta] + _b[f3rta]
matrix fcoeff = [fcoeff,_b[rta] + _b[f3rta],r(se)]

qui ppml_panel_sg X rta l3rta f3rta , ex(expid) im(impid) y(year) sym robust maxiter(200000)
test _b[rta] + _b[l3rta] + _b[f3rta] = 0
matrix mcoeff = [mcoeff, r(p)]
lincom _b[rta] + _b[l3rta] + _b[f3rta]
matrix mcoeff = [mcoeff,_b[rta] + _b[l3rta] + _b[f3rta],r(se)]

drop *
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
outsheet l f m using ".\result\PPMLlagforeResult_F_NTB.csv", nonames replace


