**cepii
use ".\originaldata\geo_cepii.dta", clear
keep iso3 country
duplicates drop
replace country = "Belgium" if strpos(country,"Belgium")
replace country = "Brunei" if strpos(country,"Brunei")
replace country = "Kazakhstan" if strpos(country,"Kazakstan")
replace country = "Hong Kong, China" if strpos(country,"Hong Kong")
replace country = "Korea, Rep." if strpos(country,"Korea") & iso3 == "KOR"
replace country = "Slovak Republic" if strpos(country,"Slovakia")
replace country = "Taiwan, China" if strpos(country,"Taiwan")
replace country = "United States" if strpos(country,"United States of America")
replace country = "Vietnam" if strpos(country,"Viet Nam")
save ".\data\cepii_countryname.dta", replace
******************************************************************************
*                           ICIO2016 CP2015                                  *
******************************************************************************
**icio
forvalues i = 1995/2011{
	import excel using ".\data\ICIO2016_`i'.xlsx", clear
	rename A  Y
	gen sectorid = ceil(_n/(64*64))
	by sectorid, sort : gen impid = ceil(_n/64)
	by sectorid impid, sort : gen expid = _n
	save ".\data\ICIO2016_`i'.dta", replace
}

use ".\data\ICIO2016_1995.dta", clear
gen year = 1995
forvalues i = 1996/2011{
	append using ".\data\ICIO2016_`i'.dta"
	replace year = `i' if year == .	
	erase ".\data\ICIO2016_`i'.dta"
}
cap erase ".\data\ICIO2016_1995.dta"
rename impid countryid
merge m:1 countryid using ".\data\countryname2016.dta", nogenerate
rename (countryid shortname ICIOcountry) (impid imp impName)
rename expid countryid
merge m:1 countryid using ".\data\countryname2016.dta", nogenerate
rename (countryid shortname ICIOcountry) (expid exp expName)
** tariff
rename (impName expName year) (ReporterName PartnerName TariffYear)
merge 1:1 ReporterName PartnerName TariffYear sectorid using ".\data\tauFinal.dta", keep(match master) nogenerate
replace t1 = 1 if t1 == .
replace t2 = 1 if t2 == .
rename (ReporterName PartnerName TariffYear) (impName expName year)
** CEPII
rename impName country
merge m:1 country using ".\data\cepii_countryname.dta", keep(match master) nogenerate
rename (country iso3) (impName iso_d)
rename expName country
merge m:1 country using ".\data\cepii_countryname.dta", keep(match master) nogenerate
rename (country iso3) (expName iso_o)
merge m:1 iso_o iso_d using ".\originaldata\dist_cepii.dta", keepusing(contig comlang_off colony dist) keep(match master) nogenerate
** RTA 
rename (exp imp) (exporter importer)
merge m:1 exporter importer year using ".\originaldata\rta_20181107\rta_20181107.dta", keepusing(rta) keep(match master) nogenerate
/*by year, sort : egen rtasum = mean(rta)
replace rta = rtasum if rta == .						//ROW's RTA = 0
drop if _merge == 2
drop _merge
*/
save ".\data\total.dta", replace

use ".\data\total.dta", clear
drop if sector == 18
replace t1 = 1
gen X = Y*t1
replace X = round(X,1)
gen lndist = log(dist)
gen logX = log(X)
global D lndist contig comlang_off colony 

egen impyear = group(impid year)
egen expyear = group(expid year)
gen pair = importer + exporter
encode pair, gen(lambda)

forvalues i = 1/17{
preserve
keep if sectorid == `i'
keep logX rta $D impyear expyear lambda expid impid
save ".\data\OLSGravitysector`i'.dta", replace
restore

preserve
keep if sectorid == `i'
keep X rta $D impid expid year pair t1
save ".\data\PPMLGravitysector`i'.dta", replace
restore
}

******************************************************************************
*                           ICIO2018 CP2015                                  *
******************************************************************************
forvalues i = 2005/2015{
	import excel using ".\data\ICIO2018_`i'.xlsx", clear
	rename A  Y
	gen sectorid = ceil(_n/(65*65))
	by sectorid, sort : gen impid = ceil(_n/65)
	by sectorid impid, sort : gen expid = _n
	save ".\data\ICIO2018_`i'.dta", replace
}

use ".\data\ICIO2018_2005.dta", clear
gen year = 2005
forvalues i = 2006/2015{
	append using ".\data\ICIO2018_`i'.dta"
	replace year = `i' if year == .	
	erase ".\data\ICIO2018_`i'.dta"
}
cap erase ".\data\ICIO2018_2005.dta"
** countryname 2018
rename impid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
rename (oecd countryid shortname ICIOcountry name RCEP) (impOECD impid imp impName impname impRCEP)
rename expid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
rename (oecd countryid shortname ICIOcountry name RCEP) (expOECD expid exp expName expname expRCEP)
** tariff
rename (impName expName year) (ReporterName PartnerName TariffYear)
merge 1:1 ReporterName PartnerName TariffYear sectorid using ".\data\tauFinal.dta", keep(match master) nogenerate
replace t1 = 1 if t1 == .
replace t2 = 1 if t2 == .
rename (ReporterName PartnerName TariffYear) (impName expName year)
save ".\data\total2018.dta", replace

******************************************************************************
*                           ICIO2016 JIE2019                                 *
******************************************************************************

**icio
forvalues i = 1995/2011{
	import excel using ".\data\ICIO2016_`i'ZF.xlsx", clear
	rename (A B) (Z F)
	gen sectorid = ceil(_n/(64*64))
	by sectorid, sort : gen impid = ceil(_n/64)
	by sectorid impid, sort : gen expid = _n
	save ".\data\ICIO2016_`i'ZF.dta", replace
}

use ".\data\ICIO2016_1995ZF.dta", clear
gen year = 1995
forvalues i = 1996/2011{
	append using ".\data\ICIO2016_`i'ZF.dta"
	replace year = `i' if year == .	
	erase ".\data\ICIO2016_`i'ZF.dta"
}
cap erase ".\data\ICIO2016_1995ZF.dta"
rename impid countryid
merge m:1 countryid using ".\data\countryname2016.dta", nogenerate
rename (countryid shortname ICIOcountry) (impid imp impName)
rename expid countryid
merge m:1 countryid using ".\data\countryname2016.dta", nogenerate
rename (countryid shortname ICIOcountry) (expid exp expName)
** tariff
rename (impName expName year) (ReporterName PartnerName TariffYear)
merge 1:1 ReporterName PartnerName TariffYear sectorid using ".\data\tauFinal.dta", keep(match master) nogenerate
replace t1 = 1 if t1 == .
replace t2 = 1 if t2 == .
rename (ReporterName PartnerName TariffYear) (impName expName year)
** CEPII
rename impName country
merge m:1 country using ".\data\cepii_countryname.dta", keep(match master) nogenerate
rename (country iso3) (impName iso_d)
rename expName country
merge m:1 country using ".\data\cepii_countryname.dta", keep(match master) nogenerate
rename (country iso3) (expName iso_o)
merge m:1 iso_o iso_d using ".\originaldata\dist_cepii.dta", keepusing(contig comlang_off colony dist) keep(match master) nogenerate
** RTA 
rename (exp imp) (exporter importer)
merge m:1 exporter importer year using ".\originaldata\rta_20181107\rta_20181107.dta", keepusing(rta) keep(match master) nogenerate
/*by year, sort : egen rtasum = mean(rta)
replace rta = rtasum if rta == .						//ROW's RTA = 0
drop if _merge == 2
drop _merge
*/
save ".\data\total_ZF.dta", replace

use ".\data\total_ZF.dta", clear
drop if sector == 18
replace t1 = 1
gen Xm = Z*t1
gen Xf = F*t1
replace Xm = round(Xm,1)
replace Xf = round(Xf,1)
gen lndist = log(dist)
gen logXm = log(Xm)
gen logXf = log(Xf)
global D lndist contig comlang_off colony 

egen impyear = group(impid year)
egen expyear = group(expid year)
gen pair = importer + exporter
encode pair, gen(lambda)

forvalues i = 1/17{
preserve
keep if sectorid == `i'
keep logX* rta $D impyear expyear lambda expid impid
save ".\data\OLSGravitysector`i'ZF.dta", replace
restore

preserve
keep if sectorid == `i'
keep X* rta $D impid expid year pair t1
save ".\data\PPMLGravitysector`i'ZF.dta", replace
restore
}

import excel using ".\data\theta.xlsx", clear
rename (A B) (sectorid theta)
save ".\data\theta.dta", replace
