%%
%参数设定

%Inputs

% Countries = [
%     AUS   澳大利亚   ISL       冰岛   POL         波兰   BGR     保加利亚   MAR         摩洛哥  
%     AUT     奥地利   IRL     爱尔兰   PRT       葡萄牙   KHM       柬埔寨   PER           秘鲁  
%     BEL     比利时   ISR     以色列   SVK     斯洛伐克   CHN         中国   PHL         菲律宾  
%     CAN     加拿大   ITA     意大利   SVN   斯洛文尼亚   COL     哥伦比亚   ROU       罗马尼亚  
%     CHL       智利   JPN       日本   ESP       西班牙   CRI   哥斯达黎加   RUS         俄罗斯  
%     CZE       捷克   KOR       韩国   SWE         瑞典   HRV     克罗地亚   SAU     沙特阿拉伯  
%     DNK       丹麦   LVA   拉脱维亚   CHE         瑞士   CYP     塞浦路斯   SGP         新加坡  
%     EST   爱沙尼亚   LTU     立陶宛   TUR       土耳其   IND         印度   ZAF           南非  
%     FIN       芬兰   LUX     卢森堡   GBR         英国   IDN   印度尼西亚   TWN       中国台湾  
%     FRA       法国   MEX     墨西哥   USA         美国   HKG     中国香港   THA           泰国  
%     DEU       德国   NLD       荷兰   ARG       阿根廷   KAZ   哈萨克斯坦   TUN         突尼斯  
%     GRC       希腊   NZL     新西兰   BRA         巴西   MYS     马来西亚   VNM           越南  
%     HUN     匈牙利   NOR       挪威   BRN         文莱   MLT       马耳他   ROW   其他国家地区 
% ];
AUS = 1;
JPN = 18;
KOR = 19;
NZL = 25;
CHN = 42;
IND = 47;
BRN = 39;
KHM = 41;
IDN = 48;
MYS = 51;
PHL = 55;
SGP = 59;
THA = 62;
VNM = 64;
ASEAN = [BRN KHM IDN MYS PHL SGP THA VNM];
RCEP = [AUS KOR NZL CHN ASEAN];
% RCEP = [JPN KOR CHN];
% RCEP = [AUS NZL IND ASEAN];