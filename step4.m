run('.\matlab\prepare.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WHY DIFFERENT TRADE TYPE IS IMPORTANT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%CP 2015
run('.\matlab\basic.m')
run('.\matlab\nodeficit.m')
run('.\matlab\zeroSurplus.m')
%%the trade cost changes of intermediate and final goods are the same, meanwhile tariff reduction exist
run('.\matlab\basic_JIE.m')
run('.\matlab\nodeficit_JIE.m')
clear all;
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE.m')

%%only same trade cost change between intermediate and final use, without tariff change
clear all;
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_onlyTradeCostchange.m')

run('.\matlab\result.m')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Baseline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%there is only tariff change of intermediate and final use 
clear
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_onlyTariffchange.m')
xlswrite('.\result\baseline\RealWage_rcep_onlyTariffchange.xlsx',100*(RealWage_rcep - 1));
%%there is only the different trade cost changes of intermediate and final use
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_onlyTradeCostchange_diff.m')
xlswrite('.\result\baseline\RealWage_rcep_onlyTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%there are the trade cost changes of intermediate and final use are different, meanwhile tariff reduction exist
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_diff.m')
xlswrite('.\result\baseline\RealWage_rcep_diff.xlsx',100*(RealWage_rcep - 1));

run('.\matlab\result_JIE.m')
%%only the intermediate trade cost change
% run('.\matlab\RCEPset.m')
% run('.\matlab\zeroSurplus_JIE_onlyIntermediateTradeCostchange.m')
% xlswrite('.\result\baseline\RealWage_rcep_onlyIntermediateTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%only the final use trade cost change
% run('.\matlab\RCEPset.m')
% run('.\matlab\zeroSurplus_JIE_onlyFinalTradeCostchange.m')
% xlswrite('.\result\baseline\RealWage_rcep_onlyFinalTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%only intermediate tariff change
% run('.\matlab\RCEPset.m')
% run('.\matlab\zeroSurplus_JIE_onlyIntermediateTariffchange.m')
% xlswrite('.\result\baseline\RealWage_rcep_onlyIntermediateTariffchange.xlsx',100*(RealWage_rcep - 1));
%%only final tariff change
% run('.\matlab\RCEPset.m')
% run('.\matlab\zeroSurplus_JIE_onlyFinalTariffchange.m')
% xlswrite('.\result\baseline\RealWage_rcep_onlyFinalTariffchange.xlsx',100*(RealWage_rcep - 1));
%%intermediate trade cost and tariff change
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_IntermediateTradeAndTariffchange.m')
xlswrite('.\result\baseline\RealWage_rcep_IntermediateTradeAndTariffchange.xlsx',100*(RealWage_rcep - 1));
%%final trade cost and tariff change
run('.\matlab\RCEPset.m')
run('.\matlab\zeroSurplus_JIE_FinalTradeAndTariffchange.m')
xlswrite('.\result\baseline\RealWage_rcep_FinalTradeAndTariffchange.xlsx',100*(RealWage_rcep - 1));


%%calculate the Value added
run('.\matlab\VACalculator.m')
run('.\matlab\VACalculator_TradeCostAndTariffChange.m')
clear
load .\data\VAXandEchange_onlyTariffchange.mat;
xlswrite('.\result\baseline\VAXandEchange_onlyTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_onlyTradeCostchange_diff.mat;
xlswrite('.\result\baseline\VAXandEchange_onlyTradeCostchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_FinalTradeAndTariffchange.mat;
xlswrite('.\result\baseline\VAXandEchange_FinalTradeAndTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_IntermediateTradeAndTariffchange.mat;
xlswrite('.\result\baseline\VAXandEchange_IntermediateTradeAndTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
% load .\data\VAXandEchange_onlyFinalTariffchange.mat;
% xlswrite('.\result\baseline\VAXandEchange_onlyFinalTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
% clear
% load .\data\VAXandEchange_onlyFinalTradeCostchange.mat;
% xlswrite('.\result\baseline\VAXandEchange_onlyFinalTradeCostchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
% clear
% load .\data\VAXandEchange_onlyIntermediateTariffchange.mat;
% xlswrite('.\result\baseline\VAXandEchange_onlyIntermediateTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
% clear
% load .\data\VAXandEchange_onlyIntermediateTradeCostchange.mat;
% xlswrite('.\result\baseline\VAXandEchange_onlyIntermediateTradeCostchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF INDIA EXIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%only tariff change of intermediate and final use, RCEP without India

clear
run('.\matlab\RCEPwithoutIndia.m')
run('.\matlab\zeroSurplus_JIE_onlyTariffchange.m')
xlswrite('.\result\NoIndia\RealWage_rcep_onlyTariffchange.xlsx',100*(RealWage_rcep - 1));
%%only the different trade cost changes of intermediate and final use, without India
run('.\matlab\RCEPwithoutIndia.m')
run('.\matlab\zeroSurplus_JIE_onlyTradeCostchange_diff.m')
xlswrite('.\result\NoIndia\RealWage_rcep_onlyTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%the trade cost changes of intermediate and final use are different, meanwhile tariff reduction exist
% RCEP without India
run('.\matlab\RCEPwithoutIndia.m')
run('.\matlab\zeroSurplus_JIE_diff.m')
xlswrite('.\result\NoIndia\RealWage_rcep_diff.xlsx',100*(RealWage_rcep - 1));

run('.\matlab\result_JIE.m')
%%calculate the Value added
run('.\matlab\VACalculator_TradeCostAndTariffChange.m')
clear
load .\data\VAXandEchange_onlyTariffchange.mat;
xlswrite('.\result\NoIndia\VAXandEchange_onlyTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_onlyTradeCostchange_diff.mat;
xlswrite('.\result\NoIndia\VAXandEchange_onlyTradeCostchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_diff.mat;
xlswrite('.\result\NoIndia\VAXandEchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_diff_after.mat;
xlswrite('.\result\NoIndia\VAdecomposition_after.xlsx',[va1p va2p va3p va4p va5p va6p va7p va8p va9p Ej_nip]);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF JAPAN EXIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%only tariff change of intermediate and final use, RCEP without India
clear
run('.\matlab\RCEPwithoutJapan.m')
run('.\matlab\zeroSurplus_JIE_onlyTariffchange.m')
xlswrite('.\result\NoJapan\RealWage_rcep_onlyTariffchange.xlsx',100*(RealWage_rcep - 1));
%%only the different trade cost changes of intermediate and final use, without India
run('.\matlab\RCEPwithoutJapan.m')
run('.\matlab\zeroSurplus_JIE_onlyTradeCostchange_diff.m')
xlswrite('.\result\NoJapan\RealWage_rcep_onlyTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%the trade cost changes of intermediate and final use are different, meanwhile tariff reduction exist
% RCEP without India
run('.\matlab\RCEPwithoutJapan.m')
run('.\matlab\zeroSurplus_JIE_diff.m')
xlswrite('.\result\NoJapan\RealWage_rcep_diff.xlsx',100*(RealWage_rcep - 1));

run('.\matlab\result_JIE.m')
%%calculate the Value added
run('.\matlab\VACalculator_TradeCostAndTariffChange.m')
clear 
load .\data\VAXandEchange_onlyTariffchange.mat;
xlswrite('.\result\NoJapan\VAXandEchange_onlyTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_onlyTradeCostchange_diff.mat;
xlswrite('.\result\NoJapan\VAXandEchange_onlyTradeCostchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_diff.mat;
xlswrite('.\result\NoJapan\VAXandEchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_diff_after.mat;
xlswrite('.\result\NoJapan\VAdecomposition_after.xlsx',[va1p va2p va3p va4p va5p va6p va7p va8p va9p Ej_nip]);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IF India and JAPAN EXIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%only tariff change of intermediate and final use, RCEP without India
clear
run('.\matlab\RCEPwithoutJPNandIND.m')
run('.\matlab\zeroSurplus_JIE_onlyTariffchange.m')
xlswrite('.\result\NoIndiaAndJapan\RealWage_rcep_onlyTariffchange.xlsx',100*(RealWage_rcep - 1));
%%only the different trade cost changes of intermediate and final use, without India
run('.\matlab\RCEPwithoutJPNandIND.m')
run('.\matlab\zeroSurplus_JIE_onlyTradeCostchange_diff.m')
xlswrite('.\result\NoIndiaAndJapan\RealWage_rcep_onlyTradeCostchange.xlsx',100*(RealWage_rcep - 1));
%%the trade cost changes of intermediate and final use are different, meanwhile tariff reduction exist
% RCEP without India
run('.\matlab\RCEPwithoutJPNandIND.m')
run('.\matlab\zeroSurplus_JIE_diff.m')
xlswrite('.\result\NoIndiaAndJapan\RealWage_rcep_diff.xlsx',100*(RealWage_rcep - 1));

run('.\matlab\result_JIE.m')
%%calculate the Value added
run('.\matlab\VACalculator_TradeCostAndTariffChange.m')
clear 
load .\data\VAXandEchange_onlyTariffchange.mat;
xlswrite('.\result\NoIndiaAndJapan\VAXandEchange_onlyTariffchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_onlyTradeCostchange_diff.mat;
xlswrite('.\result\NoIndiaAndJapan\VAXandEchange_onlyTradeCostchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear
load .\data\VAXandEchange_diff.mat;
xlswrite('.\result\NoIndiaAndJapan\VAXandEchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
clear 
load .\data\VAXandEchange_diff_after.mat;
xlswrite('.\result\NoIndiaAndJapan\VAdecomposition_after.xlsx',[va1p va2p va3p va4p va5p va6p va7p va8p va9p Ej_nip]);