clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_onlyTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE_onlyTariffchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
save '..\data\VAXandEchange_onlyTariffchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;

%%

clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_onlyTradeCostchange_diff.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE_onlyTradeCostchange_diff.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
save '..\data\VAXandEchange_onlyTradeCostchange_diff.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;

%%
clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_diff.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
[va1p, va2p, va3p, va4p, va5p, va6p, va7p, va8p, va9p, Ej_nip] = VAdecomposition(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
save '..\data\VAXandEchange_diff.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
save '..\data\VAXandEchange_diff_after.mat' va1p va2p va3p va4p va5p va6p va7p va8p va9p Ej_nip;
%%
clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_FinalTradeAndTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE_FinalTradeAndTariffchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
save '..\data\VAXandEchange_FinalTradeAndTariffchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
%%
clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_IntermediateTradeAndTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE_IntermediateTradeAndTariffchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
save '..\data\VAXandEchange_IntermediateTradeAndTariffchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
%%
% clear all
% load '..\data\basic.mat' B G N J;
% load '..\data\rcep_JIE_onlyFinalTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
% load ..\data\Xj_nip_nodeficit_JIE.mat
% Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
% Xj_f_ni = Xj_f_nip_noD;
% %3维处理
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
%                                                              %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
%                                                              %排除掉
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % 总收益FOB
% 
% load '..\data\tau_JIE_onlyFinalTariffchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
% Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
% Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
% Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
% [VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
% [VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
% DVA = VAX + RDV;
% DVAp = VAXp + RDVp;
% save '..\data\VAXandEchange_onlyFinalTariffchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
%%
% clear all
% load '..\data\basic.mat' B G N J;
% load '..\data\rcep_JIE_onlyFinalTradeCostchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
% load ..\data\Xj_nip_nodeficit_JIE.mat
% Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
% Xj_f_ni = Xj_f_nip_noD;
% %3维处理
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
%                                                              %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
%                                                              %排除掉
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % 总收益FOB
% 
% load '..\data\tau_JIE_onlyFinalTradeCostchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
% Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
% Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
% Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
% [VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
% [VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
% DVA = VAX + RDV;
% DVAp = VAXp + RDVp;
% save '..\data\VAXandEchange_onlyFinalTradeCostchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
%%
% clear all
% load '..\data\basic.mat' B G N J;
% load '..\data\rcep_JIE_onlyIntermediateTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
% load ..\data\Xj_nip_nodeficit_JIE.mat
% Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
% Xj_f_ni = Xj_f_nip_noD;
% %3维处理
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
%                                                              %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
%                                                              %排除掉
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % 总收益FOB
% 
% load '..\data\tau_JIE_onlyIntermediateTariffchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
% Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
% Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
% Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
% [VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
% [VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
% DVA = VAX + RDV;
% DVAp = VAXp + RDVp;
% save '..\data\VAXandEchange_onlyIntermediateTariffchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;
%%
% clear all
% load '..\data\basic.mat' B G N J;
% load '..\data\rcep_JIE_onlyIntermediateTradeCostchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
% load ..\data\Xj_nip_nodeficit_JIE.mat
% Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
% Xj_f_ni = Xj_f_nip_noD;
% %3维处理
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
%                                                              %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
%                                                              %排除掉
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % 总收益FOB
% 
% load '..\data\tau_JIE_onlyIntermediateTradeCostchange.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
% Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
% Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
% Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
% [VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
% [VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
% DVA = VAX + RDV;
% DVAp = VAXp + RDVp;
% save '..\data\VAXandEchange_onlyIntermediateTradeCostchange.mat' VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep;