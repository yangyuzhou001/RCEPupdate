insheet using ".\result\PPMLlagforeResult.csv", clear
*insheet using ".\result\result.csv", clear
drop if strpos(v1,"(")
keep v3
replace v3 = subinstr(v3,"*","",.)
destring, replace
rename v3  beta 
gen sector = ""
replace sector = "农业" in 1
replace sector = "采矿业" in 2
replace sector = "食品业" in 3
replace sector = "纺织品业" in 4
replace sector = "林业" in 5
replace sector = "纸制品业" in 6
replace sector = "石油制品业" in 7
replace sector = "化学与医药行业" in 8
replace sector = "塑料业" in 9
replace sector = "矿产品业" in 10
replace sector = "基础金属业" in 11
replace sector = "金属制品业" in 12
replace sector = "电脑行业" in 13 
replace sector = "电子产品业" in 14
replace sector = "机械行业" in 15
replace sector = "汽车业" in 16
//replace sector = "其他交通工具业" in 17
replace sector = "其他制造业" in 17
gen sectorid = _n
merge 1:1 sectorid using ".\data\theta.dta", nogenerate

gen mu = -beta/theta

save ".\data\beta.dta", replace

insheet using ".\result\onlyTwoPPML.csv", clear
keep if v1 == "beta"
keep v2 v3
replace v2 = subinstr(v2,"*","",.)
replace v3 = subinstr(v3,"*","",.)
destring, replace
rename (v2 v3) (beta_m_all beta_f_all)
save ".\data\beta_all_zf.dta", replace

insheet using ".\result\PPMLlagforeResult_Z.csv", clear
gen id = _n
rename v* m*
save 1.dta, replace
insheet using ".\result\PPMLlagforeResult_F.csv", clear
gen id = _n
rename v* f*
merge 1:1 id using 1.dta, nogenerate
erase 1.dta
*insheet using ".\result\result.csv", clear
drop if strpos(f1,"(")
keep f3 m3
replace m3 = subinstr(m3,"*","",.)
replace f3 = subinstr(f3,"*","",.)
destring, replace
rename (f3 m3) (beta_f beta_m)
gen sector = ""
replace sector = "农业" in 1
replace sector = "采矿业" in 2
replace sector = "食品业" in 3
replace sector = "纺织品业" in 4
replace sector = "林业" in 5
replace sector = "纸制品业" in 6
replace sector = "石油制品业" in 7
replace sector = "化学与医药行业" in 8
replace sector = "塑料业" in 9
replace sector = "矿产品业" in 10
replace sector = "基础金属业" in 11
replace sector = "金属制品业" in 12
replace sector = "电脑行业" in 13 
replace sector = "电子产品业" in 14
replace sector = "机械行业" in 15
replace sector = "汽车业" in 16
//replace sector = "其他交通工具业" in 17
replace sector = "其他制造业" in 17
gen sectorid = _n
merge 1:1 sectorid using ".\data\theta.dta", nogenerate
cross using ".\data\beta_all_zf.dta"

gen mu_m = -beta_m/theta
gen mu_f = -beta_f/theta

replace mu_m = -beta_m_all/theta if beta_m < 0
replace mu_f = -beta_f_all/theta if beta_f < 0

save ".\data\beta_zf.dta", replace
