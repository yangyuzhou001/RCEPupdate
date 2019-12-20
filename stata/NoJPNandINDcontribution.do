import excel using ".\result\baseline\VAdecomposition_before.xlsx", clear
stack A-XZ, clear into(va)
gen part = ceil(_n/(65*65*18))
by part, sort : gen expid = ceil(_n/(65*18))
by part expid, sort : gen sectorid = ceil(_n/65)
by part expid sectorid, sort : gen impid = _n
drop _stack
save before.dta, replace

foreach pos in "India" "Japan" "IndiaAndJapan" {
	import excel using ".\result\No`pos'\VAdecomposition_after.xlsx", clear
	stack A-XZ, clear into(va)
	gen part = ceil(_n/(65*65*18))
	by part, sort : gen expid = ceil(_n/(65*18))
	by part expid, sort : gen sectorid = ceil(_n/65)
	by part expid sectorid, sort : gen impid = _n
	drop _stack
	save after_No`pos'.dta, replace
	
	rename va vap 
	merge 1:1 part expid sectorid impid using before.dta, nogenerate
	keep if part == 10
	drop part 
	rename va* e*
	merge 1:m expid sectorid impid using after_No`pos'.dta, nogenerate
	rename va vap
	merge 1:1 part expid sectorid impid using before.dta, nogenerate
	drop if part == 10 
	rename expid countryid
	merge m:1 countryid using ".\data\countryname2018.dta", keepusing(shortname RCEP) nogenerate
	rename (countryid shortname RCEP) (expid expname expRCEP)
	rename impid countryid
	merge m:1 countryid using ".\data\countryname2018.dta", keepusing(shortname RCEP) nogenerate
	rename (countryid shortname RCEP) (impid impname impRCEP)

	by expid part, sort : egen VA = sum(va)
	by expid part, sort : egen VAp = sum(vap)
	by expid, sort : egen E = sum(e)
	replace E = E/9
	by expid, sort : egen Ep = sum(ep)
	replace Ep = Ep/9
	gen Ehat = Ep/E
	save contribution_No`pos'.dta, replace
	}
use contribution_NoIndia.dta, clear
gen CF = "No India"
append using contribution_NoJapan.dta
replace CF = "No Japan" if CF == ""
append using contribution_NoIndiaAndJapan.dta
replace CF = "No India and Japan" if CF == ""

gen weight = va/E
gen vahat = vap/va
gen contribution_cf = 100*weight*vahat/Ehat
keep imp* exp* CF contribution* sectorid part
merge m:1 impid expid sectorid part using ".\data\contribution.dta", keepusing(va vap E Ehat) nogenerate
gen weight = va/E
gen vahat = vap/va
gen contribution = 100*weight*vahat/Ehat
gen hat = contribution/contribution_cf
gsort - hat

#delimit ;
twoway hist hat if expRCEP == 1 & impRCEP == 1 & hat > 1 & expname == "IND"
, bfcolor(none) blcolor(red) 
||
hist hat if expRCEP == 1 & impRCEP == 1 & hat > 1 & expname == "JPN"
, bfcolor(none) blcolor(blue)
||
hist hat if expRCEP == 1 & impRCEP == 1 & hat > 1 & expname == "CHN"
, bfcolor(none) blcolor(green) 
||,
by(CF, row(1) note("")) scheme(s1color)
legend(label(1 "印度") label(2 "日本") label(3 "中国") row(1))
;
#delimit cr

preserve
keep if expid == 18 | expid == 42 | expid == 47
#delimit ;
twoway sca hat contribution , msymbol(Oh) msize(tiny) ||
lfit hat contribution , by(expname, note(""))
scheme(s1color);
#delimit cr
restore

preserve
keep if expid == 18 | CF == "NoJapan"
#delimit ;
twoway sca hat contribution , msymbol(Oh) msize(tiny) ||
lfit hat contribution , by(part, note(""))
scheme(s1color);
#delimit cr
restore

erase before.dta
foreach pos in "India" "Japan" "IndiaAndJapan" {
erase after_No`pos'.dta
erase contribution_No`pos'.dta
}
