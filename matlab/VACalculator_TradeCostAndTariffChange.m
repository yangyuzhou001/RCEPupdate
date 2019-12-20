clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_onlyTariffchange.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip_noD;
%3ά����
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % ������FOB

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
Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip_noD;
%3ά����
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % ������FOB

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
Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip_noD;
%3ά����
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % ������FOB

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
Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip_noD;
%3ά����
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % ������FOB

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
Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip_noD;
%3ά����
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % ������FOB

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
% Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
% Xj_f_ni = Xj_f_nip_noD;
% %3ά����
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
%                                                              %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
%                                                              %�ų���
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % ������FOB
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
% Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
% Xj_f_ni = Xj_f_nip_noD;
% %3ά����
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
%                                                              %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
%                                                              %�ų���
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % ������FOB
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
% Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
% Xj_f_ni = Xj_f_nip_noD;
% %3ά����
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
%                                                              %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
%                                                              %�ų���
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % ������FOB
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
% Xj_m_ni = Xj_m_nip_noD;                                          % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
% Xj_f_ni = Xj_f_nip_noD;
% %3ά����
% % Calculating X0 Expenditure
% Xj_m_n=sum((Xj_m_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧
% 
% % Calculating Expenditure shares
% PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
% PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
%                                                              %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
%                                                              %�ų���
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Xj_f_n=sum((Xj_f_ni'));                                          
% PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
% PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   
% 
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % ������FOB
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