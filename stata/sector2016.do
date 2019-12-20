import excel using ".\originaldata\SNA93\ReadMe_CSV.xlsx", sheet("CtryInd") cellrange(G4:H37) clear
rename G-H (code industry)
gen sector = ""
replace sector = "农业" if code == "C01T05AGR"
replace sector = "采矿业" if code == "C10T14MIN"
replace sector = "食品业" if code == "C15T16FOD"
replace sector = "纺织品业" if code == "C17T19TEX"
replace sector = "林业" if code == "C20WOD"
replace sector = "纸制品业" if code == "C21T22PAP"
replace sector = "石油制品业" if code == "C23PET"
replace sector = "化学与医药行业" if code == "C24CHM"
replace sector = "塑料业" if code == "C25RBP"
replace sector = "矿产品业" if code == "C26NMM"
replace sector = "基础金属业" if code == "C27MET"
replace sector = "金属制品业" if code == "C28FBM"
replace sector = "电脑行业" if code == "C30T33XCEQ"
replace sector = "电子产品业" if code == "C31ELQ"
replace sector = "机械行业" if code == "C29MEQ"
replace sector = "汽车业" if code == "C34MTR" | code == "C35TRQ"
replace sector = "其他制造业" if code == "C36T37OTM"
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
export excel using ".\data\AggS2016.xlsx", replace
restore

save ".\data\sector2016.dta", replace

keep sector*
duplicates drop
save ".\data\sectorname2016.dta", replace
