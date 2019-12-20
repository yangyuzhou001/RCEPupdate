import excel using ".\originaldata\SNA08\ReadMe_ICIO_CSV.xlsx", sheet("Country_Industry") cellrange(B4:E41) clear
rename B-E (shortname1 ICIOcountry1 shortname2 ICIOcountry2)
gen id = _n
reshape long shortname ICIOcountry, i(id) j(oecd)
replace oecd = oecd - 1
sort oecd id
replace oecd = 1 - oecd
replace id = _n

drop if shortname == ""
drop if strpos(shortname,"1") | strpos(shortname,"2")
drop id
gen countryid = _n

replace ICIOcountry = "Brunei" if strpos(ICIOcountry,"Brunei")
replace ICIOcountry = "China" if strpos(ICIOcountry,"China (People's Republic of)")
replace ICIOcountry = "Cyprus" if strpos(ICIOcountry,"Cyprus")
replace ICIOcountry = "Israel" if strpos(ICIOcountry,"Israel")
replace ICIOcountry = "Korea, Rep." if strpos(ICIOcountry,"Korea")
replace ICIOcountry = "Taiwan, China" if strpos(ICIOcountry,"Taipei")
replace ICIOcountry = "Vietnam" if strpos(ICIOcountry,"Viet Nam")

gen name = ""
replace name = "澳大利亚" if countryid == 1
replace name = "奥地利" if countryid == 2
replace name = "比利时" if countryid == 3
replace name = "加拿大" if countryid == 4
replace name = "智利" if countryid == 5
replace name = "捷克" if countryid == 6
replace name = "丹麦" if countryid == 7
replace name = "爱沙尼亚" if countryid == 8
replace name = "芬兰" if countryid == 9
replace name = "法国" if countryid == 10
replace name = "德国" if countryid == 11
replace name = "希腊" if countryid == 12
replace name = "匈牙利" if countryid == 13
replace name = "冰岛" if countryid == 14
replace name = "爱尔兰" if countryid == 15
replace name = "以色列" if countryid == 16
replace name = "意大利" if countryid == 17
replace name = "日本" if countryid == 18
replace name = "韩国" if countryid == 19
replace name = "拉脱维亚" if countryid == 20
replace name = "立陶宛" if countryid == 21
replace name = "卢森堡" if countryid == 22
replace name = "墨西哥" if countryid == 23
replace name = "荷兰" if countryid == 24
replace name = "新西兰" if countryid == 25
replace name = "挪威" if countryid == 26
replace name = "波兰" if countryid == 27
replace name = "葡萄牙" if countryid == 28
replace name = "斯洛伐克" if countryid == 29
replace name = "斯洛文尼亚" if countryid == 30
replace name = "西班牙" if countryid == 31
replace name = "瑞典" if countryid == 32
replace name = "瑞士" if countryid == 33
replace name = "土耳其" if countryid == 34
replace name = "英国" if countryid == 35
replace name = "美国" if countryid == 36
replace name = "阿根廷" if countryid == 37
replace name = "巴西" if countryid == 38
replace name = "文莱" if countryid == 39
replace name = "保加利亚" if countryid == 40
replace name = "柬埔寨" if countryid == 41
replace name = "中国" if countryid == 42
replace name = "哥伦比亚" if countryid == 43
replace name = "哥斯达黎加" if countryid == 44
replace name = "克罗地亚" if countryid == 45
replace name = "塞浦路斯" if countryid == 46
replace name = "印度" if countryid == 47
replace name = "印度尼西亚" if countryid == 48
replace name = "中国香港" if countryid == 49
replace name = "哈萨克斯坦" if countryid == 50
replace name = "马来西亚" if countryid == 51
replace name = "马耳他" if countryid == 52
replace name = "摩洛哥" if countryid == 53
replace name = "秘鲁" if countryid == 54
replace name = "菲律宾" if countryid == 55
replace name = "罗马尼亚" if countryid == 56
replace name = "俄罗斯" if countryid == 57
replace name = "沙特阿拉伯" if countryid == 58
replace name = "新加坡" if countryid == 59
replace name = "南非" if countryid == 60
replace name = "中国台湾" if countryid == 61
replace name = "泰国" if countryid == 62
replace name = "突尼斯" if countryid == 63
replace name = "越南" if countryid == 64
replace name = "其他国家地区" if countryid == 65

label var oecd "是否属于经合组织(是为1；不是为0)"
label var shortname "ICIO国家地区缩写"
label var ICIOcountry "ICIO国家地区英文名称(根据WITS调整)"
label var countryid "ICIO国家地区编号"
label var name "国家地区名称"

gen RCEP = 0
replace RCEP = 1 if countryid == 1 | countryid == 18 | countryid == 19 | ///
countryid == 25 | countryid == 42 | countryid == 47 | countryid == 39 | ///
countryid == 41 | countryid == 48 | countryid == 51 | countryid == 55 | ///
countryid == 59 | countryid == 62 | countryid == 64
gen ASEAN = 0
replace ASEAN = 1 if countryid == 39 | countryid == 41 | countryid == 48 | ///
countryid == 51 | countryid == 55 | countryid == 59 | countryid == 62 | ///
countryid == 64
save ".\data\countryname2018.dta", replace
