import excel using ".\data\VAXandE2005-2015.xlsx", clear
rename A-BC v#, addnumber
rename v1-v11 vax#, addnumber
rename v12-v22 dva#, addnumber
rename v23-v33 e#, addnumber
rename v34-v44 dvx#, addnumber
rename v45-v55 fva#, addnumber
forvalues i = 1/11{
	rename (vax`i' dva`i' e`i' dvx`i' fva`i') ///
	(vax`=`i'+2004' dva`=`i' + 2004' e`=`i' + 2004' dvx`=`i' + 2004' fva`=`i' + 2004')
}
gen countryid = _n
reshape long vax dva e dvx fva, i(countryid) j(year)
gen vaxratio = vax/e
gen dvaratio = dva/e
gen gvc = (dvx + fva)/e
gen position = ln(1 + dvx/e) - ln(1 + fva/e)

merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
by year oecd, sort : egen esum = sum(e)
gen epercent = e/esum
by year oecd, sort : egen oecd_gvc = sum(epercent*gvc)
by year oecd, sort : egen oecd_pos = sum(epercent*position)
preserve 
keep year oecd*
rename (oecd oecd_gvc oecd_pos) (countryid gvc position)
replace countryid = 66 if countryid == 1
replace countryid = 67 if countryid == 0
duplicates drop
save oecd_gvc.dta, replace
restore
append using oecd_gvc.dta

sort countryid year
#delimit ;
twoway scatter gvc position if countryid == 42, c(l) || 
	   scatter gvc position if countryid == 66, c(l) ||
	   scatter gvc position if countryid == 67, c(l)
;
#delimit cr

twoway line vaxratio year if countryid == 42 || ///
	   line dvaratio year if countryid == 42 ||, ///
	   xlabel(2005(1)2015) ylabel(0.5(0.1)0.9, angle(0)) ///
	   legend(label(1 "VAX") label(2 "DVA")) ///
	   scheme(s1color)
graph export ".\figure\2005-2015年的中国VAX率与DVA率(中间与最终贸易成本变化相同).png", width(1342) height(976) replace

*******************************************************************************
*                         存在贸易成本变化差异时全球价值链变化                *
*******************************************************************************
import excel using ".\result\baseline\VAXandEchange_diff.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen vaxratio = VAX/E
gen vaxratiop = VAXp/Ep
gen dvaratio = DVA/E
gen dvaratiop = DVAp/Ep
gen gvc = (FVA + DVX)/E
gen gvcp = (FVAp + DVXp)/Ep
gen position = ln(1 + DVX/E) - ln(1 + FVA/E)
gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", nogenerate
gen posid = 9 if RCEP == 0
replace posid = 3 if RCEP == 1
replace posid = 6 if shortname == "KHM"
replace posid = 6 if shortname == "SGP"
replace posid = 6 if shortname == "JPN"
twoway scatter vaxratiop vaxratio if RCEP == 1, msym(circle) mlab(shortname) mlabvpos(posid) || ///
	   scatter vaxratiop vaxratio if RCEP == 0, msym(T) mlab(shortname) mlabvpos(posid) || ///
	   function y = x, range(vaxratio) yvarlab("y = x") || , ///
	   xtitle("初始VAX率") ytitle("反事实冲击之后的VAX率") ///
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家地区") row(1)) ///
	   scheme(s1color)
graph export ".\figure\VAX率在RCEP冲击的变化(中间与最终贸易成本变化不同).png", width(1342) height(976) replace

twoway scatter dvaratiop dvaratio if RCEP == 1, msym(c) mlab(shortname) mlabvpos(posid) || ///
	   scatter dvaratiop dvaratio if RCEP == 0, msym(T) mlab(shortname) mlabvpos(posid) || ///
	   function y = x, range(vaxratio) yvarlab("y = x") || , ///
	   xtitle("初始DVA率") ytitle("反事实冲击之后的DVA率") ///
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家地区") row(1)) ///
	   scheme(s1color)
graph export ".\figure\DVA率在RCEP冲击的变化(中间与最终贸易成本变化不同).png", width(1342) height(976) replace

twoway scatter gvcp gvc if RCEP == 1, msym(c) mlab(shortname) mlabvpos(posid) || ///
	   scatter gvcp gvc if RCEP == 0, msym(T) mlab(shortname) mlabvpos(posid) || ///
	   function y = x, range(gvc) yvarlab("y = x") || , ///
	   xtitle("初始GVC参与率") ytitle("反事实冲击之后的GVC参与率") ///
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家地区") row(1)) ///
	   scheme(s1color)
graph export ".\figure\GVC参与率在RCEP冲击的变化(中间与最终贸易成本变化不同).png", width(1342) height(976) replace

preserve
replace posid = 9 if RCEP == 1
replace posid = 3 if RCEP == 0
twoway scatter positionp position if RCEP == 1, msym(c) mlab(shortname) mlabvpos(posid) || ///
	   scatter positionp position if RCEP == 0, msym(T) mlab(shortname) mlabvpos(posid) || ///
	   function y = x, range(position) yvarlab("y = x") || , ///
	   xtitle("初始GVC地位") ytitle("反事实冲击之后的GVC地位") ///
	   legend(label(1 "RCEP国家") label(2 "非RCEP国家地区") row(1)) ///
	   scheme(s1color)
graph export ".\figure\GVC地位RCEP冲击的变化(中间与最终贸易成本变化不同).png", width(1342) height(976) replace
restore

erase oecd_gvc.dta
