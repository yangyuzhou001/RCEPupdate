*use ".\originaldata\1688644_E5AE9905-2\DataJobID-1688644_1688644_YangYuzhou20191108.dta", clear
*append using ".\originaldata\1688538_6FC7CC90-4\DataJobID-1688538_1688538_YangYuzhou20191108.dta"

use ".\originaldata\1695789_E3BE1DE2-1\DataJobID-1695789_1695789_YangYuzhou20191108.dta", clear
duplicates drop 
preserve
keep Partner*
duplicates drop
rename Partner* country*
save name.dta, replace
restore

preserve
keep Product*
duplicates drop
save Product.dta, replace
restore

preserve
keep if Reporter == "918"
save 918.dta, replace
restore

preserve
rename Reporter* country*
merge m:1 country* using name.dta
keep if _merge == 2
keep country*
cross using 918.dta
replace Reporter = country
replace ReporterName = countryName
drop country*
save 918.dta, replace
restore

drop if Reporter == "918"
append using 918.dta
//duplicates list Reporter* Partner* Product* TariffYear, force
**a little difference in weighted average tariff 
duplicates drop Reporter* Partner* Product* TariffYear, force 
save all.dta, replace

clear
set obs 16
gen TariffYear = 1999 + _n
cross using name.dta
rename country* Reporter*
cross using name.dta
rename country* Partner*
cross using Product.dta
merge 1:1 Reporter* Partner* Product* TariffYear using all.dta, nogenerate
destring, replace
gen sectorid=.
replace sectorid =	1	  if Product==	1
replace sectorid =	1	  if Product==	2
replace sectorid =	1	  if Product==	5
replace sectorid =	2	  if Product==	10
replace sectorid =	2	  if Product==	11
replace sectorid =	2	  if Product==	12
replace sectorid =	2	  if Product==	13
replace sectorid =	2	  if Product==	14
replace sectorid =	3	  if Product==	15
replace sectorid =	3	  if Product==	16
replace sectorid =	4	  if Product==	17
replace sectorid =	4	  if Product==	18
replace sectorid =	4	  if Product==	19
replace sectorid =	5	  if Product==	20
replace sectorid =	6 	  if Product==	21
replace sectorid =	6 	  if Product==	22
replace sectorid =	7	  if Product==	23
replace sectorid =	8	  if Product==	24
replace sectorid =	9	  if Product==	25
replace sectorid =	10	  if Product==	26
replace sectorid =	11	  if Product==	27
replace sectorid =	12	  if Product==	28
replace sectorid =	15	  if Product==	29
replace sectorid =	13	  if Product==	30
replace sectorid =	14	  if Product==	31
replace sectorid =	13 	  if Product==	32
replace sectorid =	8 	  if Product==	33
replace sectorid =	16	  if Product==	34
replace sectorid =	16	  if Product==	35
replace sectorid =	17 	  if Product==	36
replace sectorid =	18	  if Product==	40

preserve
keep Product* sectorid
duplicates drop
save ".\data\WITSsector.dta", replace
restore

by Reporter* Partner* sectorid* TariffYear*, sort : egen t1 = mean(SimpleAverage)
by Reporter* Partner* sectorid* TariffYear*, sort : egen t2 = mean(WeightedAverage)
collapse (mean) t*, by(Reporter* Partner* sectorid* TariffYear*)

replace t1 = 0 if Reporter == Partner
replace t2 = 0 if Reporter == Partner
replace t1 = 0 if t1 == .
replace t2 = 0 if t2 == .
replace t1 = 0 if sectorid == 19
replace t2 = 0 if sectorid == 19
replace t1 = 1 + t1/100
replace t2 = 1 + t2/100

save ".\data\tauFinal.dta", replace

use ".\data\tauFinal.dta", clear
rename ReporterName ICIOcountry
merge m:1 ICIOcountry using ".\data\countryname2018.dta", keepusing(countryid) keep(matched) nogenerate
rename (ICIOcountry countryid) (ReporterName Reporterid)
rename PartnerName ICIOcountry
merge m:1 ICIOcountry using ".\data\countryname2018.dta", keepusing(countryid) keep(matched) nogenerate
rename (ICIOcountry countryid) (PartnerName Partnerid)
sort TariffYear Reporterid Partnerid sectorid
forvalues i = 2005/2015{
preserve
	keep if TariffYear == `i'
	export excel t1 using ".\data\tariff2018_`i'.xlsx", replace
restore
}
keep if TariffYear == 2015
export excel t1 using ".\data\tariff.xlsx", replace

erase name.dta
erase Product.dta
erase 918.dta
erase all.dta
