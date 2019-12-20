*Why different trade type is important

import excel using ".\result\Why different trade type is important\Yni_imp_exp_rcep_CP2015.xlsx", clear
keep BO
rename BO Ehat
replace Ehat = 100*Ehat
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
tostring Ehat, format(%9.2f) replace force
keep if RCEP == 1
sort ASEAN name
save CP2015.dta, replace

import excel using ".\result\Why different trade type is important\RCEP实际工资变化(CP2015).xlsx", firstrow clear
rename (国家地区名称 实际工资变化) (name wagehat)
merge 1:1 name using CP2015.dta, nogenerate
replace wagehat = substr(wagehat,1,4)
order name wagehat
sort ASEAN name
rename (wagehat Ehat) (wagehat_CP Ehat_CP)
save CP2015.dta, replace

import excel using ".\result\Why different trade type is important\VAXandEchange.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
tostring Ehat VAXratioTilde DVAratioTilde, format(%9.2f) replace force
keep Ehat VAXratioTilde DVAratioTilde RCEP name ASEAN
keep if RCEP == 1
sort ASEAN name
save JIE2019.dta, replace

import excel using ".\result\Why different trade type is important\RCEP实际工资变化(JIE2019).xlsx", firstrow clear
rename (国家地区名称 实际工资变化) (name wagehat)
merge 1:1 name using JIE2019.dta, nogenerate
replace wagehat = substr(wagehat,1,4)
order name Ehat VAX DVA wagehat
sort ASEAN name
save JIE2019.dta, replace

import excel using ".\result\baseline\VAXandEchange_diff.xlsx", clear
rename A-J (VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep)
gen countryid = _n
merge 1:1 countryid using ".\data\countryname2018.dta", keepusing(shortname name RCEP ASEAN) nogenerate
gen Ehat = 100*(Ep/E - 1)
gen VAXratioTilde = 100*(VAXp/Ep - VAX/E)
gen DVAratioTilde = 100*(DVAp/Ep - DVA/E)
tostring Ehat VAXratioTilde DVAratioTilde, format(%9.2f) replace force
keep Ehat VAXratioTilde DVAratioTilde RCEP name ASEAN
keep if RCEP == 1
sort ASEAN name
save JIE2019_diff.dta, replace

import excel using ".\result\baseline\RCEP实际工资变化(JIE2019).xlsx", firstrow clear
rename (国家地区名称 实际工资变化) (name wagehat)
merge 1:1 name using JIE2019_diff.dta, nogenerate
replace wagehat = substr(wagehat,1,4)
order name Ehat VAX DVA wagehat
sort ASEAN name
save JIE2019_diff.dta, replace

use JIE2019_diff.dta, clear
keep name Ehat* wagehat* ASEAN
rename (Ehat wagehat) (Ehat_diff wagehat_diff)
merge 1:1 name using JIE2019.dta, keepusing(Ehat wagehat) nogenerate
merge 1:1 name using CP2015.dta, keepusing(Ehat_CP wagehat_CP) nogenerate
keep name Ehat* wagehat* ASEAN
sort ASEAN name
order name *_diff Ehat_CP wagehat_CP Ehat wagehat 

export excel using ".\result\Why different trade type is important\CP与JIE模型的贸易与福利比较分析.xlsx", replace

destring, replace
label define ID 1 "中国" 2 "印度" 3 "新西兰" 4 "日本" 5 "澳大利亚" 6 "韩国" ///
7 "印度尼西亚" 8 "文莱" 9 "新加坡" 10 "柬埔寨" 11 "泰国" 12 "菲律宾" 13 "越南" ///
14 "马来西亚"
gen id = _n
label value id ID
rename *_diff *1
rename *_CP *3
rename (Ehat wagehat) (Ehat2 wagehat2)
radar name wagehat1 wagehat3, lc(red blue) lw(*1 *2) connected ///
ms(D S) r(0 1 2 3 4) title("RCEP国家的福利增长(%)") ///
aspect(1) legend(label(1 "不区分中间与最终使用情况") ///
				 label(2 "区分中间与最终使用情况") row(2)) scheme(s1color) ///
				 labsize(*.5) plotregion(style(none)) note("")
graph save 1.gph, replace
radar name Ehat1 Ehat3, lc(red blue) lw(*1 *2) connected ///
ms(D S) r(0 5 10 15 20) title("RCEP国家的出口贸易增长(%)") ///
aspect(1) legend(label(1 "不区分中间与最终使用情况") ///
				 label(2 "区分中间与最终使用情况") row(2)) scheme(s1color) ///
				 labsize(*.5) plotregion(style(none)) note("")
graph save 2.gph, replace
graph combine 1.gph 2.gph, scheme(s1color) note("Center is at 0")
erase 1.gph
erase 2.gph
graph export ".\figure\CP模型与JIE模型RCEP导致的实际工资与出口增长率.png", width(1342) height(976) replace

reshape long Ehat wagehat, i(id) j(model)
drop if model == 3
graph bar (asis) Ehat wagehat, over(model) over(id) 
graph hbar wagehat, over(model) over(id)


erase CP2015.dta
erase JIE2019.dta
erase JIE2019_diff.dta


