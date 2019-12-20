
%% only tariff change of intermediate and final goods 

clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       after world's tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat J N alphas;
load ..\data\tau_JIE_onlyTariffchange.mat tau tau_rcep_ftariff tau_rcep_mtariff;
load ..\data\rcep_JIE_onlyTariffchange.mat Xj_m_np_rcep Xj_f_np_rcep PIj_m_nip_rcep ...
    PIj_f_nip_rcep Xj_f_ni Xj_m_ni RCEP wf0_rcep pf_rcep;

Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;

Xj_ni = Xj_f_ni + Xj_m_ni;
Xj_nip_rcep = Xj_m_nip_rcep + Xj_f_nip_rcep;
% Yj_ni = Xj_f_ni./tau + Xj_m_ni./tau;

X_ni = sum(permute(reshape(Xj_ni,N,J,N),[1 3 2]),3);
X_nip_rcep = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);

X_ni_hat = X_nip_rcep./X_ni;

% xlswrite('..\result\Xni_rcep.xlsx',X_ni_hat);


X_ni_rcep_per = (X_nip_rcep - X_ni)./X_ni;
mainCountry_rcep_Per = X_ni_rcep_per(RCEP,RCEP);
disp(['----------------------------------------------------------------------------------------------']);
disp(['If the trade cost of intermediate and final use is cosntant,']);
disp(['and RCEP reduced tariff to zero only']);
disp(['----------------------------------------------------------------------------------------------']);
disp(['The average bilateral trade increase percentage of RCEP countries is ',num2str(mean(mean(mainCountry_rcep_Per)))]);
disp(['The average bilateral trade increase percentage of all coutnry is ',num2str(nanmean(nanmean(X_ni_rcep_per)))]);
disp(['The total increase value is ',num2str(sum(sum(X_nip_rcep - X_ni))),...
    'million dollars. It is about ',num2str(round(100*sum(sum(X_nip_rcep - X_ni))./sum(sum(X_ni)),4)),'%']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Welfare effects from RCEP's tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealWage_rcep = wf0_rcep./(prod(pf_rcep.^alphas,1)');
disp(['The average Real Wage change of all countries is ',num2str(mean(RealWage_rcep))]);

%% only the different trade cost changes of intermediate and final use
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       after world's trade cost reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat J N alphas;
load ..\data\tau_JIE_onlyTradeCostchange_diff.mat tau tau_rcep_ftariff tau_rcep_mtariff;
load ..\data\rcep_JIE_onlyTradeCostchange_diff.mat Xj_m_np_rcep Xj_f_np_rcep PIj_m_nip_rcep ...
    PIj_f_nip_rcep Xj_f_ni Xj_m_ni RCEP wf0_rcep pf_rcep;

Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;

Xj_ni = Xj_f_ni + Xj_m_ni;
Xj_nip_rcep = Xj_m_nip_rcep + Xj_f_nip_rcep;
% Yj_ni = Xj_f_ni./tau + Xj_m_ni./tau;

X_ni = sum(permute(reshape(Xj_ni,N,J,N),[1 3 2]),3);
X_nip_rcep = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);

X_ni_hat = X_nip_rcep./X_ni;

% xlswrite('..\result\Xni_rcep.xlsx',X_ni_hat);


X_ni_rcep_per = (X_nip_rcep - X_ni)./X_ni;
mainCountry_rcep_Per = X_ni_rcep_per(RCEP,RCEP);
disp(['----------------------------------------------------------------------------------------------']);
disp(['If the trade cost of intermediate and final use is different,']);
disp(['and RCEP reduced the different trade cost only']);
disp(['----------------------------------------------------------------------------------------------']);
disp(['The average bilateral trade increase percentage of RCEP countries is ',num2str(mean(mean(mainCountry_rcep_Per)))]);
disp(['The average bilateral trade increase percentage of all coutnry is ',num2str(nanmean(nanmean(X_ni_rcep_per)))]);
disp(['The total increase value is ',num2str(sum(sum(X_nip_rcep - X_ni))),...
    'million dollars. It is about ',num2str(round(100*sum(sum(X_nip_rcep - X_ni))./sum(sum(X_ni)),4)),'%']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Welfare effects from RCEP's trade cost reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealWage_rcep = wf0_rcep./(prod(pf_rcep.^alphas,1)');
disp(['The average Real Wage change of all countries is ',num2str(mean(RealWage_rcep))]);

%% the trade cost changes of intermediate and final goods are different, meanwhile tariff reduction exist
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     after world's tariff and different trade cost reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat J N alphas;
load ..\data\tau_JIE_diff.mat tau tau_rcep_ftariff tau_rcep_mtariff;
load ..\data\rcep_JIE_diff.mat Xj_m_np_rcep Xj_f_np_rcep PIj_m_nip_rcep ...
    PIj_f_nip_rcep Xj_f_ni Xj_m_ni RCEP wf0_rcep pf_rcep;

Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;

Xj_ni = Xj_f_ni + Xj_m_ni;
Xj_nip_rcep = Xj_m_nip_rcep + Xj_f_nip_rcep;
% Yj_ni = Xj_f_ni./tau + Xj_m_ni./tau;

X_ni = sum(permute(reshape(Xj_ni,N,J,N),[1 3 2]),3);
X_nip_rcep = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);

X_ni_hat = X_nip_rcep./X_ni;

% xlswrite('..\result\Xni_rcep.xlsx',X_ni_hat);


X_ni_rcep_per = (X_nip_rcep - X_ni)./X_ni;
mainCountry_rcep_Per = X_ni_rcep_per(RCEP,RCEP);
disp(['----------------------------------------------------------------------------------------------']);
disp(['If the trade cost of intermediate and final use are different,']);
disp(['and RCEP reduced the trade cost reduction with tariff reduction']);
disp(['----------------------------------------------------------------------------------------------']);
disp(['The average bilateral trade increase percentage of RCEP countries is ',num2str(mean(mean(mainCountry_rcep_Per)))]);
disp(['The average bilateral trade increase percentage of all coutnry is ',num2str(nanmean(nanmean(X_ni_rcep_per)))]);
disp(['The total increase value is ',num2str(sum(sum(X_nip_rcep - X_ni))),...
    'million dollars. It is about ',num2str(round(100*sum(sum(X_nip_rcep - X_ni))./sum(sum(X_ni)),4)),'%']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Welfare effects from RCEP's heterogenous trade cost and tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealWage_rcep = wf0_rcep./(prod(pf_rcep.^alphas,1)');
disp(['The average Real Wage change of all countries is ',num2str(mean(RealWage_rcep))]);

% xlswrite('..\result\RealWage_rcep.xlsx',100*(RealWage_rcep - 1));
