import excel using ".\result\baseline\RealWage_rcep_diff.xlsx", clear
rename A wagehat
gen countryid = _n
save realwage_rcep_diff.dta, replace

import excel using ".\result\baseline\VAXandEchange_diff.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
gen gvc = (FVA + DVX)/E
gen gvcp = (FVAp + DVXp)/Ep 
gen position = ln(1 + DVX/E) - ln(1 + FVA/E)
gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep) 

merge 1:1 countryid using realwage_rcep_diff.dta, nogenerate
#delimit ;
twoway scatter VAXratioTilde gvc if RCEP == 1, msymbol(c) mlabel(shortname) ||
	   scatter VAXratioTilde gvc if RCEP == 0, msymbol(Oh) ||
	   lfit VAXratioTilde gvc if RCEP == 1,
	   xtitle("初始全球价值链参与程度") ytitle("VAX率变化程度(%)")
	   xlabel(.2(.1).6)
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家") label(3 "拟合曲线")
			row(1)) 
	   scheme(s1color)
;
graph export ".\figure\RCEP国家VAX率变化与初始GVC参与率率之间的关系.png", width(1342) height(976) replace
;
#delimit cr
#delimit ;
twoway scatter VAXratioTilde position if RCEP == 1, msymbol(c) mlabel(shortname) ||
	   scatter VAXratioTilde position if RCEP == 0, msymbol(Oh) ||
	   lfit VAXratioTilde position if RCEP == 1 ||,
	   xtitle("国家的初始全球价值链上游程度") ytitle("VAX率变化程度(%)")
	   xlabel(-.3(.1).3)
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家") label(3 "拟合曲线")
			row(1)) 
	   scheme(s1color)
;
graph export ".\figure\RCEP国家VAX率变化与初始GVC上游程度之间的关系.png", width(1342) height(976) replace
;
#delimit cr
#delimit ;
twoway scatter gvc position if RCEP == 1, msymbol(c) mlabel(shortname) ||
	   scatter gvc position if RCEP == 0, msymbol(Oh) mlabel(shortname) ||, 
	   xsca(alt) xlabel(,grid) ylabel(, grid)
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家") ring(0) row(2) pos(2))
	   xtitle("初始全球价值链上游程度") ytitle("初始全球价值链参与程度")
	   scheme(s1color) saving(yx)
;
twoway scatter gvc VAXratioTilde if RCEP == 1, msymbol(c) mlabel(shortname) mlabp(9) ||
	   scatter gvc VAXratioTilde if RCEP == 0, msymbol(Oh) ||
	   lfit gvc VAXratioTilde if RCEP == 1,
	   ytitle("初始全球价值链参与程度") xtitle("VAX率变化程度(%)")
	   xsca(alt reverse) ysca(alt) saving(hy) fxsize(25)
	   ylabel(,grid) legend(off) scheme(s1color)
;
twoway scatter VAXratioTilde position if RCEP == 1, msymbol(c) mlabel(shortname) ||
	   scatter VAXratioTilde position if RCEP == 0, msymbol(Oh) ||
	   lfit VAXratioTilde position if RCEP == 1 ||,
	   xtitle("初始全球价值链上游程度") ytitle("VAX率变化程度(%)")
	   xlabel(, grid) ylabel(, nogrid) 
	   legend(off) scheme(s1color) saving(hx) fysize(25)
;
graph combine yx.gph hy.gph hx.gph, imargin(0 0 0 0) graphregion(margin(l = 22 r = 22))
	   scheme(s1color)
;
erase hy.gph;
erase yx.gph;
erase hx.gph;
graph export ".\figure\RCEP国家VAX率变化与初始GVC地位之间的关系.png", width(1342) height(976) replace
;
#delimit cr


tostring Ehat VAXratio DVAratio wagehat gvc* position*, format(%9.4f) replace force
keep Ehat VAXratio DVAratio RCEP name ASEAN wagehat gvc* position*
keep if RCEP == 1
sort ASEAN name
rename name _varname
destring, replace
xpose, clear varname 
drop in 1/2
tostring _all, format(%9.4f) replace force
preserve
drop in 4/7
export excel using ".\table\RCEP差异化贸易成本变化下出口、增加值与实际收入的增长(基准).xlsx", firstrow(var) replace
restore

keep in 4/7
drop _varname
export excel using ".\result\baseline\baseline_GVC.xlsx", firstrow(var) replace
********************************************************************************
*			CounterFactual of Intermeidate and Final Use
********************************************************************************
foreach v in "IntermediateTradeAndTariffchange" "FinalTradeAndTariffchange" ///
"onlyIntermediateTradeCostchange" "onlyIntermediateTariffchange" ///
"onlyTariffchange" "onlyTradeCostchange" ///
"onlyFinalTradeCostchange" "onlyFinalTariffchange" "diff"{
	import excel using ".\result\baseline\RealWage_rcep_`v'.xlsx", clear
	rename A realwage
	gen countryid = _n
	save realwage_rcep_diff.dta, replace

	import excel using ".\result\baseline\VAXandEchange_`v'.xlsx", clear
	rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
	gen countryid = _n
	merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
	gen Ehat = 100*(Ep/E - 1)
	gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
	gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
	gen gvc = (FVA + DVX)/E
	gen gvcp = (FVAp + DVXp)/Ep 
	gen position = ln(1 + DVX/E) - ln(1 + FVA/E)
	gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep) 

	merge 1:1 countryid using realwage_rcep_diff.dta, nogenerate
	by RCEP, sort : egen Esum_rcep = sum(E)
	by RCEP, sort : egen Epsum_rcep = sum(Ep)
	egen Esum = sum(E)
	egen Epsum = sum(Ep)
	gen Esumhat_rcep = 100*(Epsum_rcep/Esum_rcep - 1)
	by RCEP, sort : egen meanWage_rcep = mean(realwage)
	gen Esumhat = 100*(Epsum/Esum - 1)
	egen meanWage = mean(realwage)
	preserve
	keep if countryid == 42
	keep Ehat realwage Esumhat_rcep meanWage_rcep Esumhat meanWage
	save `v'_CHN.dta, replace
	restore
	keep Ehat realwage countryid
	save `v'.dta, replace
}

use diff_CHN.dta, clear
gen CF = "基准情况"
append using IntermediateTradeAndTariffchange_CHN.dta
replace CF = "只有中间产品的贸易成本与关税变化" if CF == ""
append using FinalTradeAndTariffchange_CHN.dta
replace CF = "只有最终产品的贸易成本与关税变化" if CF == ""

append using onlyTradeCostchange_CHN.dta
replace CF = "只有贸易成本变化" if CF == ""
append using onlyIntermediateTradeCostchange_CHN.dta
replace CF = "只有中间产品的贸易成本变化" if CF == ""
append using onlyFinalTradeCostchange_CHN.dta
replace CF = "只有最终产品的贸易成本变化" if CF == ""

append using onlyTariffchange_CHN.dta
replace CF = "只有关税变化" if CF == ""
append using onlyIntermediateTariffchange_CHN.dta
replace CF = "只有中间产品的关税变化" if CF == ""
append using onlyFinalTariffchange_CHN.dta
replace CF = "只有最终产品的关税变化" if CF == ""

order CF
tostring E* *age*, format(%9.2f) replace force

export excel using ".\table\RCEP通过不同用途不同贸易成本变化带来的中国贸易与福利变化.xlsx", replace

use diff.dta, clear
gen CF = "基准情况"
append using IntermediateTradeAndTariffchange.dta
replace CF = "只有中间产品的贸易成本与关税变化" if CF == ""
append using FinalTradeAndTariffchange.dta
replace CF = "只有最终产品的贸易成本与关税变化" if CF == ""

append using onlyTradeCostchange.dta
replace CF = "只有贸易成本变化" if CF == ""
append using onlyIntermediateTradeCostchange.dta
replace CF = "只有中间产品的贸易成本变化" if CF == ""
append using onlyFinalTradeCostchange.dta
replace CF = "只有最终产品的贸易成本变化" if CF == ""

append using onlyTariffchange.dta
replace CF = "只有关税变化" if CF == ""
append using onlyIntermediateTariffchange.dta
replace CF = "只有中间产品的关税变化" if CF == ""
append using onlyFinalTariffchange.dta
replace CF = "只有最终产品的关税变化" if CF == ""

order CF
merge m:1 countryid using ".\data\countryname2018.dta", keepusing(name) nogenerate

export excel using ".\table\RCEP通过不同用途不同贸易成本变化带来的贸易与福利效应.xlsx", replace


foreach v in "IntermediateTradeAndTariffchange" "FinalTradeAndTariffchange" ///
"onlyIntermediateTradeCostchange" "onlyIntermediateTariffchange" ///
"onlyTariffchange" "onlyTradeCostchange" ///
"onlyFinalTradeCostchange" "onlyFinalTariffchange" "diff"{
	erase `v'_CHN.dta
	erase `v'.dta
}

erase realwage_rcep_diff.dta


