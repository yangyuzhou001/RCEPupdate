import excel using ".\originaldata\SNA08\ReadMe_ICIO_CSV.xlsx", sheet("Country_Industry") cellrange(G4:I39) clear
rename G-I (code industry isicv4)
gen sector = ""
replace sector = "农业" if code == "D01T03"
replace sector = "采矿业" if code == "D05T06" | code == "D07T08" | code == "D09"
replace sector = "食品业" if code == "D10T12"
replace sector = "纺织品业" if code == "D13T15"
replace sector = "林业" if code == "D16"
replace sector = "纸制品业" if code == "D17T18"
replace sector = "石油制品业" if code == "D19"
replace sector = "化学与医药行业" if code == "D20T21"
replace sector = "塑料业" if code == "D22"
replace sector = "矿产品业" if code == "D23"
replace sector = "基础金属业" if code == "D24"
replace sector = "金属制品业" if code == "D25"
replace sector = "电脑行业" if code == "D26"
replace sector = "电子产品业" if code == "D27"
replace sector = "机械行业" if code == "D28"
replace sector = "汽车业" if code == "D29" | code == "D30"
replace sector = "其他制造业" if code == "D31T33"
replace sector = "服务业" if sector == ""

gen sectorid = 0
replace sectorid = sectorid + 1 if sector != sector[_n - 1] in 2/l
replace sectorid = sectorid + sectorid[_n - 1] in 2/l
replace sectorid = sectorid + 1

preserve
forvalues i = 1/18{
	gen sectorid`i' = (sectorid == `i')
}
keep sectorid1-sectorid18
xpose, clear
export excel using ".\data\AggS2018.xlsx", replace
restore

save ".\data\sector2018.dta", replace

keep sector*
duplicates drop
save ".\data\sectorname2018.dta", replace
