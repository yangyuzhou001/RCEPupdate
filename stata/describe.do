//Table 1
use ".\data\total.dta", clear
replace t1 = 1
gen X = round(Y*t1,1)
gen zeroid = (X == 0)
merge m:1 sectorid using ".\data\sectorname2016.dta", nogenerate
preserve
collapse (count) sampleX = X (mean) meanX = X (sd) sdX = X (min) minX = X (max) maxX = X, by(sectorid sector)
drop sectorid
list, compress noobs clean
export excel using ".\table\被解释变量统计描述(CP2015).xlsx", replace
restore

//Table 2
insheet using ".\result\result.csv", clear
drop if strpos(v1,"main")
drop if strpos(v2,"b/se")
preserve
gen id = _n
save ".\data\result.dta", replace
restore
gen j = ceil(_n/18)
by j, sort : gen i = _n
drop v1
reshape wide v2 v3 v4 v5, i(i) j(j)
gen sectorid = ceil(_n/2)
merge m:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
replace sector = "" if sectorid == sectorid[_n - 1]
rename sector sector1
replace sectorid = sectorid + 9
merge m:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
replace sector = "" if sectorid == sectorid[_n - 1]
rename sector sector2
order sector1 v21 v31 v41 v51 sector2 v22 v32 v42 v52
list sector1 v21 v31 v41 v51 sector2 v22 v32 v42 v52, compress noobs clean
export excel sector1 v21 v31 v41 v51 sector2 v22 v32 v42 v52 using ".\table\没有时间效应的RTA回归系数(CP2015).xlsx", replace

//Appendix 1
use ".\data\total.dta", clear
replace t1 = 1
gen X = round(Y*t1,1)
gen zeroid = (X == 0)
keep zeroid sector*
collapse (sum) zeroid, by(sector*)
replace zeroid = round(100*zeroid/(64*64*17),0.01)
drop if sectorid == 19
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
gen j = ceil(_n/9)
by j, sort : gen i = _n
reshape wide sector* zeroid*, i(i) j(j)
list sector1 zeroid1 sector2 zeroid2, compress noobs clean
export excel sector1 zeroid1 sector2 zeroid2 using ".\table\各部门零值比例(CP2015).xlsx", replace

//Figure 1
insheet using ".\result\lagforeResult.csv", clear
drop if strpos(v1,"X")
drop if strpos(v2,"b/se")
gen id = _n
merge 1:1 id using ".\data\result.dta", nogenerate
gen sectorid = ceil(_n/2)
by sectorid, sort : replace id = _n
drop v1
replace v2 = subinstr(v2,"*","",.)
replace v3 = subinstr(v3,"*","",.)
replace v4 = subinstr(v4,"*","",.)
replace v5 = subinstr(v5,"*","",.)
reshape wide v2-v4 v5, i(sectorid) j(id)
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
destring, replace
label define sectorname 1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油制品业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"机械业" ///
				14	"电脑业" ///
				15	"电子产品业" ///
				16	"汽车业" ///
				17	"其他交通工具业" ///
				18	"其他制造业" 
label value sectorid sectorname
twoway line v51 sectorid || sca v21 sectorid || sca v31 sectorid || ///
sca v41 sectorid ||, ///
xlabel(1(1)18,angle(90) valuelabel)	///
xtitle("部门名称") ytitle("回归系数") ///
legend(label(1 "RTA效应") label(2 "控制滞后项的RTA净效应") ///
	   label(3 "控制前置项的RTA净效应") ///
	   label(4 "控制滞后项与前置项的RTA净效应")) ///
scheme(s1color) 
graph export ".\figure\考虑时间效应的RTA净效应(CP2015).png", width(1342) height(976) replace

//Figure 2
use ".\data\beta.dta", clear
sum mu
dis exp(r(mean)) - 1
gen delta = exp(mu) - 1
replace delta = -100*delta
gen symbol = string(round(abs(delta),0.01))
replace symbol = "0" + symbol if substr(symbol,1,1) == "."
gen zero = 0
replace zero = delta if delta > 0
drop if sectorid > 17

twoway bar delta sectorid, lc(black) || ///
	   scatter delta sectorid, mlabel(symbol) mlabcolor(black) msymbol(i) ///
				mlabposition(6) mlabsize(vsmall) ||, ///
	   yline(0) ylabel(-25(5)0) ///
		 xlabel(1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"电脑行业" ///
				14	"电子产品业" ///
				15	"机械行业" ///
				16	"汽车业" /// //17	"其他交通工具业" 
				17	"其他制造业" /// //20	"服务业" 
				, angle(90)) ///
		xtitle("部门名称") ytitle("RTA降低部门贸易成本的比例(%)") ///
		legend(off) scheme(s1mono)
graph export ".\figure\各部门贸易成本降低的比例(CP2015).png", width(1342) height(976) replace
export excel theta sectorid mu using ".\data\theta-mu.xlsx", replace


use ".\data\beta_zf.dta", clear
sum mu_m
dis exp(r(mean)) - 1
sum mu_f
dis exp(r(mean)) - 1
gen delta_m = exp(mu_m) - 1
gen delta_f = exp(mu_f) - 1
replace delta_m = -100*delta_m
replace delta_f = -100*delta_f
gen symbol_m = string(round(abs(delta_m),0.01))
gen symbol_f = string(round(abs(delta_f),0.01))
replace symbol_m = "0" + symbol_m if substr(symbol_m,1,1) == "."
replace symbol_f = "0" + symbol_f if substr(symbol_f,1,1) == "."

drop if sectorid > 17

twoway bar delta_m sectorid, lc(black) || ///
	   scatter delta_m sectorid, mlabel(symbol_m) mlabcolor(black) msymbol(i) ///
				mlabposition(6) mlabsize(vsmall) ||, ///
	   xlabel(1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"电脑行业" ///
				14	"电子产品业" ///
				15	"机械行业" ///
				16	"汽车业" /// //17	"其他交通工具业" 
				17	"其他制造业" /// //20	"服务业" 
				, angle(90) nolabels noticks) ///
	   yline(0) ylabel(-50(5)0) ///
	   xtitle("RTA降低部门中间产品贸易成本的比例(%)") ytitle("") ///
	   legend(off) scheme(s1mono) fysize(60)
graph save 1.gph, replace

twoway bar delta_f sectorid, lc(black) || ///
	   scatter delta_f sectorid, mlabel(symbol_f) mlabcolor(black) msymbol(i) ///
				mlabposition(6) mlabsize(vsmall) ||, ///
	   yline(0) ylabel(-10(5)0) ///
		 xlabel(1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"电脑行业" ///
				14	"电子产品业" ///
				15	"机械行业" ///
				16	"汽车业" /// //17	"其他交通工具业" 
				17	"其他制造业" /// //20	"服务业" 
				, angle(90)) ///
		xtitle("RTA降低部门最终使用贸易成本的比例(%)") ytitle("") ///
		legend(off) scheme(s1mono) fysize(45)
graph save 2.gph, replace
graph combine 1.gph 2.gph, row(2) scheme(s1mono)
erase 1.gph
erase 2.gph
graph export ".\figure\各部门贸易成本降低的比例.png", width(1342) height(976) replace


twoway bar delta_m sectorid, lc(black) || ///
	   scatter delta_m sectorid, mlabel(symbol_m) mlabcolor(black) msymbol(i) ///
				mlabposition(6) mlabsize(vsmall) ||, ///
	   xlabel(1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"电脑行业" ///
				14	"电子产品业" ///
				15	"机械行业" ///
				16	"汽车业" /// //17	"其他交通工具业" 
				17	"其他制造业" /// //20	"服务业" 
				, angle(90)) ///
	   yline(0) ylabel(-50(5)0) ///
	   ytitle("RTA降低部门中间产品贸易成本的比例(%)") xtitle("部门名称") ///
	   legend(off) scheme(s1mono)
graph export ".\figure\各部门中间产品贸易成本降低的比例.png", width(1342) height(976) replace

twoway bar delta_f sectorid, lc(black) || ///
	   scatter delta_f sectorid, mlabel(symbol_f) mlabcolor(black) msymbol(i) ///
				mlabposition(6) mlabsize(vsmall) ||, ///
	   yline(0) ylabel(-10(5)0) ///
		 xlabel(1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"电脑行业" ///
				14	"电子产品业" ///
				15	"机械行业" ///
				16	"汽车业" /// //17	"其他交通工具业" 
				17	"其他制造业" /// //20	"服务业" 
				, angle(90)) ///
		ytitle("RTA降低部门最终使用贸易成本的比例(%)") xtitle("部门名称") ///
		legend(off) scheme(s1mono)
graph export ".\figure\各部门最终使用贸易成本降低的比例.png", width(1342) height(976) replace

export excel theta sectorid mu_m mu_f using ".\data\theta-mu2.xlsx", replace

//Appendix 2
use ".\data\countryname2018.dta", clear
preserve
gen id = ceil(_n/13)
by id, sort : gen sortid = _n
reshape wide oecd shortname ICIOcountry ASEAN countryid name RCEP, i(sortid) j(id)
rename shortname* sn*
list sn1 name1 sn2 name2 sn3 name3 sn4 name4 sn5 name5, compress noobs clean
export excel sn1 name1 sn2 name2 sn3 name3 sn4 name4 sn5 name5 using ".\table\ICIO国家地区名称与代码匹配.xlsx", replace
restore

preserve
//Appendix 3
drop if countryid == 65
rename (shortname ICIOcountry) (sn WITS)
gen id = ceil(_n/16)
by id, sort : gen sortid = _n
reshape wide oecd sn WITS countryid name RCEP ASEAN, i(sortid) j(id)
list sn1 WITS1 sn2 WITS2 sn3 WITS3 sn4 WITS4, compress noobs clean
export excel sn1 WITS1 sn2 WITS2 sn3 WITS3 sn4 WITS4 using ".\table\ICIO编号与WITS国家地区代码匹配.xlsx", replace
restore

//Appendix 4
use ".\data\WITSsector.dta", clear
gen wits = substr("0" + string(Product),-2,2)
label var sectorid "部门编号"
label var wits "WITS编号"
label var ProductName "WITS部门全称"
list sectorid wits ProductName, compress noobs clean
export excel sectorid wits ProductName using ".\table\WITS原部门与整合后部门名称与编号.xlsx", replace

//Appendix 5
use ".\data\sector2018.dta", clear
preserve
rename sectorid id
gen j = ceil(_n/12)
by j, sort : gen i = _n
reshape wide code industry isicv4 sector id, i(i) j(j)
list id1 sector1 code1 id2 sector2 code2 id3 sector3 code3, compress noobs clean
restore
export excel sectorid sector industry using ".\table\ICIO(SNA08)原部门与整合后部门名称与编号.xlsx", replace

//Appendix 6
use ".\data\sector2016.dta", clear
preserve
rename sectorid id
gen j = ceil(_n/12)
by j, sort : gen i = _n
reshape wide code industry sector id, i(i) j(j)
list id1 sector1 code1 id2 sector2 code2 id3 sector3 code3, compress noobs clean
restore
export excel sectorid sector industry using ".\table\ICIO(SNA93)原部门与整合后部门名称与编号.xlsx", replace

//Appendix 7
use ".\originaldata\rta_20181107\rta_20181107.dta", clear
rename exporter shortname
merge m:1 shortname using ".\data\countryname2018.dta", keep(match) nogenerate
rename (shortname importer) (exporter shortname)
merge m:1 shortname using ".\data\countryname2018.dta", keep(match) nogenerate
keep if year > 1994 & year < 2016
tab year, sum(rta)
collapse (mean) rtamean = rta (sd) sd = rta (sum) sample = rta, by(year)
gen N = sample/rtamean
set obs 22
egen totalsample = sum(sample)
egen totalN = sum(N)
replace rtamean = totalsample/totalN if rtamean == .
replace sd = ((totalsample*(1 - rtamean)*(1-rtamean) + (totalN - totalsample)*rtamean*rtamean)/(totalN-1))^.5 in l
replace N = totalN in l
export excel year rtamean sd N using ".\table\1995-2011年RTA签署情况的统计性描述.xlsx", replace

//Appendix 8 
import excel using ".\data\theta-mu.xlsx", clear
rename A-C (theta sectorid mu)
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) keepusing(sector) nogenerate
gen j = ceil(_n/9)
by j, sort : gen i = _n
replace theta = -theta
replace mu = -mu
reshape wide sector* theta mu, i(i) j(j)
export excel sector1 theta1 mu1 sector2 theta2 mu2 using ".\table\RTA签署对各部门贸易成本的影响系数(CP2015).xlsx", replace
//Appendix 9
insheet using ".\result\PPMLlagforeResult.csv", clear
gen id = _n
gen sectorid = ceil(_n/2)
by sectorid, sort : replace id = _n
replace v2 = subinstr(v2,"*","",.)
replace v3 = subinstr(v3,"*","",.)
replace v1 = subinstr(v1,"*","",.)
reshape wide v1-v3 , i(sectorid) j(id)
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
destring, replace
label define sectorname 1	"农业" ///
				2	"采矿业" ///
				3	"食品业" ///
				4	"纺织品业" ///
				5	"林业" ///
				6	"纸制品业" ///
				7	"石油制品业" ///
				8	"化学与医药行业" ///
				9	"塑料业" ///
				10	"矿产品业" ///
				11	"基础金属业" ///
				12	"金属制品业" ///
				13	"机械业" ///
				14	"电脑业" ///
				15	"电子产品业" ///
				16	"汽车业" /// //17	"其他交通工具业" ///
				17	"其他制造业" 
label value sectorid sectorname
twoway sca v11 sectorid || sca v21 sectorid || ///
sca v31 sectorid, c(l) ||, ///
xlabel(1(1)17,angle(90) valuelabel)	///
xtitle("部门名称") ytitle("回归系数") ///
legend(label(1 "控制滞后项的RTA总效应") ///
	   label(2 "控制前置项的RTA总效应") ///
	   label(3 "控制滞后与前置项的RTA总效应")) ///
scheme(s1color) 
graph export ".\figure\各部门的RTA总效应(CP2015).png", width(1342) height(976) replace
//Appendix 10
insheet using ".\result\altresult.csv", clear
drop if strpos(v1,"main")
drop if strpos(v2,"b/se")
gen sectorid = ceil(_n/2)
by sectorid, sort : gen id = _n
drop v1
reshape wide v2 v3 v4 v5, i(sectorid) j(id)
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
order sector v2* v3* v4* v5*
drop sectorid
export excel using ".\table\备择方法回归系数(CP2015).xlsx", replace
//Appendix 11
insheet using ".\result\lagResult.csv", clear
drop if strpos(v1,"X")
drop if strpos(v2,"b/se")
drop v1 v3
rename (v2 v4) (lag bothlag)
gen id = _n
save ".\data\lagResult.dta", replace

insheet using ".\result\foreResult.csv", clear
drop if strpos(v1,"X")
drop if strpos(v2,"b/se")
drop v1 v2
rename (v3 v4) (fore bothfore)
gen id = _n
save ".\data\foreResult.dta", replace

insheet using ".\result\lagforeResult.csv", clear
drop if strpos(v1,"X")
drop if strpos(v2,"b/se")
drop v1
gen id = _n
rename v2-v4 (lagRTA foreRTA bothRTA)
merge 1:1 id using ".\data\lagResult.dta", nogenerate
merge 1:1 id using ".\data\foreResult.dta", nogenerate
order lag* fore* both*
gen sectorid = ceil(_n/2)
by sectorid, sort : replace id = _n
reshape wide lag* fore* both*, i(sectorid) j(id)
merge 1:1 sectorid using ".\data\sectorname2016.dta", keep(match) nogenerate
order sector lagRTA* lag* foreRTA* fore* bothRTA* bothlag* bothfore*
gen lagRTA = lagRTA1 + lagRTA2
gen lag = lag1 + lag2
gen foreRTA = foreRTA1 + foreRTA2
gen fore = fore1 + fore2
gen bothRTA = bothRTA1 + bothRTA2
gen bothlag = bothlag1 + bothlag2
gen bothfore = bothfore1 + bothfore2
drop if sectorid == 18
drop sectorid
export excel sector lagRTA lag foreRTA fore bothRTA bothlag bothfore using ".\table\包含时间趋势的PPML回归结果.xlsx", replace

//
use ".\data\total2018.dta", clear
drop if expid == impid
gen X = round(Y*t1,1)
collapse (sum) X, by(expid year)
rename expid countryid
merge m:1 countryid using ".\data\countryname2018.dta", nogenerate
by RCEP year, sort : egen RCEPX = sum(X)
by year, sort : egen Xsum = sum(X)
keep if countryid == 42
replace X = X/Xsum
replace RCEPX = RCEPX/Xsum

twoway bar X year, barw(.4) || line RCEPX year ||, ///
xlabel(2005(1)2015) ylabel(0 "0" .05 "5%" .1 "10%" .15 "15%" .2 "20%" .25 "25%" .3 "30%", angle(0)) ///
xtitle("年份") ytitle("占世界国际贸易的份额") ///
legend(label(1 "中国") label(2 "RCEP国家")) scheme(s1color)
graph export ".\figure\中国与RCEP的国际贸易份额.png", width(1342) height(976) replace

//https://www.surveydesign.com.au/tipsgraphs.html
use ".\data\total2018.dta", clear
drop if expid == impid | expid == 65 | impid == 65
keep if impRCEP == 1 & expRCEP == 1
gen X = round(Y*t1,1)
collapse (sum) X, by(year expid impid)
rename impid countryid
gen id = 1 if countryid == 1
replace id = 2 if countryid == 18
replace id = 3 if countryid == 19
replace id = 4 if countryid == 25
replace id = 5 if countryid == 42
replace id = 6 if countryid == 47
replace id = 7 if id == .
by id year, sort : egen Xsum = sum(X)
duplicates drop id year, force
merge m:1 countryid using ".\data\countryname2018.dta", keep(match) keepusing(name) nogenerate
keep id year Xsum
by year, sort : egen totalX = sum(Xsum)
reshape wide Xsum totalX, i(year) j(id)
keep year Xsum* totalX1
forvalues i = 1/7{
	gen percentX`i' = 100*Xsum`i'/totalX1
}
forvalues i = 2/7{
	replace percentX`i' = percentX`i' + percentX`=`i'-1'
}
gen Xsum = 0
gen Xid = (_n - 1)*10

twoway rarea Xsum percentX1 year, yaxis(1) || rarea percentX1 percentX2 year || ///
rarea percentX2 percentX3 year || rarea percentX3 percentX4 year || ///
rarea percentX4 percentX5 year || rarea percentX5 percentX6 year || ///
rarea percentX6 percentX7 year || sca Xid year, msymbol(none) yaxis(2) || , ///
plotregion(margin(zero)) legend(off) xtitle("年份") xlabel(2005(1)2015) ///
title("不同国家的贸易占RCEP国际贸易的份额") ///
ytitle("百分比(%)", axis(1)) ytitle("", axis(2)) ///
ylabel(0(20)100, axis(1) angle(0)) ///
ylabel(3 "澳大利亚" 13 "日本" 26 "韩国" 33 "新西兰" 48 "中国" 69 "印度" ///
	   87 "东盟", axis(2) angle(0)) ///
scheme(s2color) graphregion(color(white))
graph export ".\figure\RCEP不同国家的国际贸易份额.png", width(1342) height(976) replace
