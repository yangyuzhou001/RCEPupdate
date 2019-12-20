***No India
//tariff and trade cost change
foreach pos in "India" "Japan" "IndiaAndJapan" {
import excel using ".\result\No`pos'\RealWage_rcep_diff.xlsx", clear
rename A wagehat
gen countryid = _n
save realwage_rcep_diff.dta, replace

import excel using ".\result\No`pos'\VAXandEchange_diff.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
gen gvcp = (FVAp + DVXp)/Ep 
gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep)
merge 1:1 countryid using realwage_rcep_diff.dta, nogenerate
tostring Ehat *Tilde *p wagehat, format(%9.4f) replace force
keep Ehat *Tilde gvcp positionp RCEP name ASEAN wagehat
keep if RCEP == 1
sort ASEAN name
rename name _varname
destring, replace
xpose, clear varname 
drop in 1/2
tostring _all, format(%9.4f) replace force
drop _varname
gen CF = "No`pos'"
gen model = "tariff and trade cost change"
save No`pos'_tariff_trade.dta, replace
//tariff change
import excel using ".\result\No`pos'\RealWage_rcep_onlyTariffchange.xlsx", clear
rename A wagehat
gen countryid = _n
save realwage_rcep_diff.dta, replace

import excel using ".\result\No`pos'\VAXandEchange_onlyTariffchange.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
gen gvcp = (FVAp + DVXp)/Ep 
gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep) 
merge 1:1 countryid using realwage_rcep_diff.dta, nogenerate
tostring Ehat *Tilde *p wagehat, format(%9.4f) replace force
keep Ehat *Tilde gvcp positionp RCEP name ASEAN wagehat
keep if RCEP == 1
sort ASEAN name
rename name _varname
destring, replace
xpose, clear varname 
drop in 1/2
tostring _all, format(%9.4f) replace force
drop _varname
gen CF = "No`pos'"
gen model = "tariff change"
save No`pos'_tariff.dta, replace
//trade cost change
import excel using ".\result\No`pos'\RealWage_rcep_onlyTradeCostchange.xlsx", clear
rename A wagehat
gen countryid = _n
save realwage_rcep_diff.dta, replace

import excel using ".\result\No`pos'\VAXandEchange_onlyTradeCostchange_diff.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
gen gvcp = (FVAp + DVXp)/Ep
gen positionp = ln(1 + DVXp/Ep) - ln(1 + FVAp/Ep) 
merge 1:1 countryid using realwage_rcep_diff.dta, nogenerate
tostring Ehat *Tilde *p wagehat, format(%9.4f) replace force
keep Ehat *Tilde gvcp positionp RCEP name ASEAN wagehat
keep if RCEP == 1
sort ASEAN name
rename name _varname
destring, replace
xpose, clear varname 
drop in 1/2
tostring _all, format(%9.4f) replace force
drop _varname
gen CF = "No`pos'"
gen model = "trade cost change"
save No`pos'_trade.dta, replace

use No`pos'_trade.dta, clear
append using No`pos'_tariff.dta
append using No`pos'_tariff_trade.dta
save No`pos', replace
}

use NoIndia.dta, clear
append using NoJapan.dta
append using NoIndiaAndJapan.dta
gen id = ceil(_n/18)
by id, sort : gen typeid = _n
gen classid = mod(typeid,6)
replace classid = 6 if classid == 0
label define class 1 "出口增长率" 2 "VAX率变化" 3 "DVA率变化"  ///
4 "GVC参与率" 5 "价值链地位" 6 "实际收入增长率" 
label value classid class
decode classid, gen(class)
save ".\data\NoJPNandIND.dta", replace

erase realwage_rcep_diff.dta
foreach pos in "India" "Japan" "IndiaAndJapan" {
	erase No`pos'_tariff.dta
	erase No`pos'_tariff_trade.dta
	erase No`pos'_trade.dta
	erase No`pos'.dta
}

import excel using ".\result\baseline\baseline_GVC.xlsx", firstrow clear
keep 中国 印度 日本
gen id = ceil(_n/2)
by id, sort : gen sortid = _n
reshape wide 中国 印度 日本, i(id) j(sortid)
rename (中国1 印度1 日本1 中国2 印度2 日本2) (中国 印度 日本 中国0 印度0 日本0)
save counterfactual_gvc.dta, replace

import excel using ".\table\RCEP通过不同用途不同贸易成本变化带来的贸易与福利效应.xlsx", clear
rename A-E (CF countryid Ehat wagehat name)
keep if name == "中国" | name ==  "印度" | name == "日本" 
keep if CF == "只有贸易成本变化" | CF == "只有关税变化" | CF == "基准情况"
gen model = "trade cost change" if CF == "只有贸易成本变化"
replace model = "tariff change" if CF == "只有关税变化"
replace model = "tariff and trade cost change" if CF == "基准情况"
drop CF
save counterfactual_Ewage.dta, replace

use ".\data\NoJPNandIND.dta", clear

preserve
drop id typeid classid
order CF model class
export excel using ".\table\RCEP差异化贸易成本变化下出口、增加值与实际收入的增长.xlsx", firstrow(var) replace
restore

keep 中国 印度 日本 CF model id typeid class
reshape wide 中国 印度 日本 CF model, i(typeid) j(id)
rename (model1 CF1) (model CF)
drop model2 model3 CF2 CF3 typeid CF
gen modelid = 1 if model == "trade cost change"
replace modelid = 2 if model == "tariff change"
replace modelid = 3 if modelid == .
drop modelid
order model class

preserve
keep if class == "GVC参与率" | class == "价值链地位"
gen sortid = ceil(_n/2)
by sortid, sort : gen id = _n
merge m:1 id using counterfactual_gvc.dta, nogenerate
sort sortid id
destring, replace
order model class 中国* 印度* 日本*
label define modelname 1 "贸易成本变化" 2 "关税变化" ///
3 "关税与贸易都变化"
drop model 
gen _varname = class + string(sortid)
xpose, clear varname
drop in 17/l
drop if _varname == "class"
gen id = _n
reshape long GVC参与率 价值链地位, i(id) j(modelid)
replace GVC参与率 = 100*GVC参与率
replace 价值链地位 = 100*价值链地位
label value modelid modelname
gen Counter = regexs(1) if regexm(_varname,"([0-9])")
gen country = subinstr(_varname,Counter,"",.)
destring, replace
replace Counter = 4 if Counter == .
label define counter 0 "baseline" 1 "No India" 2 "No Japan" ///
3 "No India and Japan" 4 "No change"
label value Counter counter
keep modelid GVC 价值链 country Counter
sort Counter country modelid
by Counter, sort : gen num = _n
reshape wide GVC 价值链 modelid country, i(num) j(Counter)
rename country0 countryname

#delimit ;
twoway pcarrow GVC参与率4 价值链地位4 GVC参与率1 价值链地位1, msize(small) || 
pcarrow GVC参与率4 价值链地位4 GVC参与率2 价值链地位2, msize(small) || 
pcarrow GVC参与率4 价值链地位4 GVC参与率3 价值链地位3, msize(small) || 
pcarrow GVC参与率4 价值链地位4 GVC参与率0 价值链地位0, msize(small) || 
scatter GVC参与率4 价值链地位4 if countryname == "中国", 
	msymbol(i) mlabel(countryname) || 
scatter GVC参与率4 价值链地位4 if countryname == "印度", 
	msymbol(i) mlabel(countryname) || 
scatter GVC参与率4 价值链地位4 if countryname == "日本", 
	msymbol(i) mlabel(countryname) ||
, by(modelid0,  caption("") note("") row(3)) 
xtitle("价值链上游程度(%)") ytitle("GVC参与程度(%)") 
ylabel(,angle(0))
legend(label(1 "印度退出RCEP") label(2 "日本退出RCEP")
label(3 "印度和日本退出RCEP") label(4 "正常RCEP")) scheme(s1color) 
;
#delimit cr
gr_edit .legend.plotregion1.key[5].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.key[6].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.key[7].draw_view.setstyle, style(no)
// key[5] edits
gr_edit .legend.plotregion1.label[5].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.label[6].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.label[7].draw_view.setstyle, style(no)
graph export ".\figure\不同反事实情况下不同RCEP贸易成本变化对价值链的影响.png", width(1342) height(976) replace
restore

keep if class == "出口增长率" | class == "实际收入增长率"
gen id = _n
reshape long 中国 印度 日本, i(id) j(CF)
tostring CF, replace
replace CF = "NoIndia" if CF == "1"
replace CF = "NoJapan" if CF == "2"
replace CF = "NoIndiaAndJapan" if CF == "3"
destring 中国 印度 日本, replace
rename (中国 印度 日本) (country42 country47 country18)
replace id = _n
reshape long country, i(id) j(countryid)
merge m:1 countryid using ".\data\countryname2018.dta", keepusing(name) keep(match) nogenerate
keep CF model class country name
sort class CF model name country
gen id = 1 if class == "出口增长率"
replace id = 2 if id == .
by class, sort : gen sortid = _n
drop class
reshape wide country* , i(sortid) j(id)
rename (country1 country2) (Ehat_cf wagehat_cf)
merge m:1 model name using counterfactual_Ewage.dta, nogenerate 

#delimit ;
twoway pcarrow wagehat Ehat wagehat_cf Ehat_cf if CF == "NoIndia", msize(small) || 
pcarrow wagehat Ehat wagehat_cf Ehat_cf if CF == "NoJapan", msize(small) || 
pcarrow wagehat Ehat wagehat_cf Ehat_cf if CF == "NoIndiaAndJapan", msize(small) || 
scatter wagehat Ehat if name == "中国", 
	msymbol(i) mlabel(name) || 
scatter wagehat Ehat if name == "印度", 
	msymbol(i) mlabel(name) || 
scatter wagehat Ehat if name == "日本", 
	msymbol(i) mlabel(name) ||
, by(model,  caption("") note("") col(3)) 
ytitle("实际工资增长(%)") xtitle("贸易增长(%)") 
ylabel(,angle(0))
legend(label(1 "印度退出RCEP") label(2 "日本退出RCEP")
label(3 "印度和日本退出RCEP")) scheme(s1color) 
;
#delimit cr
// key[5] edits
gr_edit .legend.plotregion1.label[4].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.label[5].draw_view.setstyle, style(no)
gr_edit .legend.plotregion1.label[6].draw_view.setstyle, style(no)

graph export ".\figure\不同反事实情况下不同RCEP贸易成本变化对贸易与福利的影响.png", width(1342) height(976) replace

erase counterfactual_gvc.dta
erase counterfactual_Ewage.dta

