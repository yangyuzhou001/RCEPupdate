clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       after world's tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat
load ..\data\tau.mat
load ..\data\zeroS.mat
% load ..\data\all.mat
% load ..\data\all_nCJK.mat
load ..\data\alphas_nodeficit.mat
% Xj_nip_all = (reshape(reshape(Xj_np_all,J,N)',J*N,1)*ones(1,N)).*PIj_nip_all;
% Yj_nip_all = Xj_nip_all./tau_all;
% Xj_nip_all_nCJK = (reshape(reshape(Xj_np_all_nCJK,J,N)',J*N,1)*ones(1,N)).*PIj_nip_all_nCJK;
% Yj_nip_all_nCJK = Xj_nip_all_nCJK./taup;
% M_all = zeros(J,N);
% M_all_nCJK = zeros(J,N);
% E_all = zeros(J,N);
% E_all_nCJK = zeros(J,N);
% for j      = 1:1:J
%     % Imports
%     M_all(j,:) = (sum(Yj_nip_all(1+N*(j-1):N*j,:)' - diag(diag(Yj_nip_all(1 + N*(j - 1):N*j,:)))))';                % 进口国家进口部门的总进口
%     M_all_nCJK(j,:) = (sum(Yj_nip_all_nCJK(1+N*(j-1):N*j,:)' - diag(diag(Yj_nip_all_nCJK(1 + N*(j - 1):N*j,:)))))';     
%     for n  = 1:1:N
%     % Exports
%     E_all(j,n) = sum(Yj_nip_all(1+N*(j-1):N*j,n)) - Yj_nip_all(n + N*(j - 1),n);                   % 出口国家出口部门的总出口
%     E_all_nCJK(j,n) = sum(Yj_nip_all_nCJK(1+N*(j-1):N*j,n)) - Yj_nip_all_nCJK(n + N*(j - 1),n);        
%     end
% end
% Expper = sum(E_all - E_all_nCJK)./sum(E_all_nCJK);
% Impper = sum(M_all - M_all_nCJK)./sum(M_all_nCJK);
% ExSecper = sum(E_all - E_all_nCJK, 2)./sum(E_all_nCJK, 2);
% ImSecper = sum(M_all - M_all_nCJK, 2)./sum(M_all_nCJK, 2);
% table1 = [Expper(:,1:N/2)', Impper(:,1:N/2)',Expper(:,N/2+1:N)',Impper(:,N/2+1:N)'];

% Expper = sum(E_all - E)./sum(E);
% Impper = sum(M_all - M)./sum(M);
% ExSecper = sum(E_all - E, 2)./sum(E, 2);
% ImSecper = sum(M_all - M, 2)./sum(M, 2);
% WorldImExChange = [Expper(:,1:N/2)', Impper(:,1:N/2)',Expper(:,N/2+1:N)',Impper(:,N/2+1:N)']; 
% %xlswrite('..\result\WorldImExChange.xls',100*WorldImExChange);
% disp(['Wold Average Import Change is ',num2str(mean(Expper))]);
% disp(['Wold Average Export Change is ',num2str(mean(Impper))]);


% EShare = E./(ones(J,1)*sum(E));
% EShare_all = E_all./(ones(J,1)*sum(E_all));
%xlswrite('figure1.xls', 100*[EShare, EShare_all]);                          %效果不佳，弃用

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Export and Import change share only CJK's tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\rcep.mat
% load ..\data\nCJK.mat
% theta=xlsread('..\data\theta-mu.xlsx','A1:A18');   

Xj_nip_rcep = (reshape(reshape(Xj_np_rcep,J,N)',J*N,1)*ones(1,N)).*PIj_nip_rcep;
Yj_nip_rcep = Xj_nip_rcep./tau_rcep_tariff;

X_ni = sum(permute(reshape(Xj_ni,N,J,N),[1 3 2]),3);
X_nip_rcep = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);
M_rcep = zeros(J,N);
E_rcep = zeros(J,N);
for j      = 1:1:J
    % Imports
    M_rcep(j,:) = (sum(Yj_nip_rcep(1+N*(j-1):N*j,:)' - diag(diag(Yj_nip_rcep(1 + N*(j - 1):N*j,:)))))';                % 进口国家进口部门的总进口
    for n  = 1:1:N
    % Exports
    E_rcep(j,n) = sum(Yj_nip_rcep(1+N*(j-1):N*j,n)) - Yj_nip_rcep(n + N*(j - 1),n);                   % 出口国家出口部门的总出口
    end
end

Expper_rcep = sum(E_rcep - E)./sum(E);
Impper_rcep = sum(M_rcep - M)./sum(M);
ExSecper_rcep = sum(E_rcep - E, 2)./sum(E, 2);
Y_ni = sum(permute(reshape(Yj_ni,N,J,N),[1 3 2]),3);
xlswrite('..\result\Why different trade type is important\Yni_imp_exp_rcep_CP2015.xlsx',[Y_ni,Impper_rcep',Expper_rcep']);

Xj_nip_rcep_hat = Xj_nip_rcep./Xj_ni;
direct = (tau_hat_rcep).^kron(-theta,ones(N,N));
expIndirect = kron(c_rcep.^(- theta*ones(1,N)),ones(N,1));
PIj_ni_rcep_hat = PIj_nip_rcep./PIj_ni;
Xj_np_rcep_hat = Xj_np_rcep./(reshape(reshape(Xj_n,N,J)',J*N,1));
impIndirect = PIj_ni_rcep_hat.*reshape(reshape(Xj_np_rcep_hat,J,N)',N*J,1).*(kron(c_rcep,ones(N,1)).*tau_hat_rcep).^(kron(theta,ones(N,N)));
test = PIj_ni_rcep_hat.*reshape(reshape(Xj_np_rcep_hat,J,N)',N*J,1).*kron(ones(J,1),eye(N));
test(isnan(test) == 1) = 0;
test = sum(test,2);
test = kron(ones(1,N),test).*kron(ones(1,N),reshape(c_rcep',N*J,1)).^(kron(theta,ones(N,N)));
% xlswrite('..\result\Why different trade type is important\DirectIndirect.xlsx',[Xj_nip_rcep_hat,direct,expIndirect,test]);

X_nip = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);
X_ni_hat = X_nip./X_ni;
psij_ni = Xj_ni./kron(ones(J,1),X_ni);
psij_ni(isnan(psij_ni)==1)=0;
Direct = psij_ni.*(log(direct)./log(Xj_nip_rcep_hat)).*Xj_nip_rcep_hat;
Direct(isnan(Direct) == 1) = 0;
Direct = sum(permute(reshape(Direct,N,J,N),[1 3 2]),3);
ExpIndirect = psij_ni.*(log(expIndirect)./log(Xj_nip_rcep_hat)).*Xj_nip_rcep_hat;
ExpIndirect(isnan(ExpIndirect) == 1) = 0;
ExpIndirect = sum(permute(reshape(ExpIndirect,N,J,N),[1 3 2]),3);
ImpIndirect = psij_ni.*(log(impIndirect)./log(Xj_nip_rcep_hat)).*Xj_nip_rcep_hat;
ImpIndirect(isnan(ImpIndirect) == 1) = 0;
ImpIndirect = sum(permute(reshape(ImpIndirect,N,J,N),[1 3 2]),3);

eta_ni = X_ni(RCEP',:)./(ones(length(RCEP),1)*sum(X_ni(RCEP',:),1));
Direct_rta = sum(Direct(RCEP,:).*eta_ni,1);
ExpIndirect_rta = sum(ExpIndirect(RCEP,:).*eta_ni,1);
ImpIndirect_rta = sum(ImpIndirect(RCEP,:).*eta_ni,1);
X_rta_hat = Direct_rta + ExpIndirect_rta + ImpIndirect_rta;
xlswrite('..\result\Why different trade type is important\Xni_CP2015.xlsx',[X_ni_hat, Direct, ExpIndirect, ImpIndirect;X_rta_hat, Direct_rta, ExpIndirect_rta, ImpIndirect_rta]);



ImSecper_rcep = sum(M_rcep - M, 2)./sum(M, 2);
disp(['Only RCEP, World Average Export Change is ', num2str(mean(Expper_rcep))]);
onlyRCEPImExChange = [Expper_rcep', Impper_rcep']; 
% xlswrite('..\result\Why different trade type is important\onlyRCEPImExChange.xlsx',100*onlyRCEPImExChange);


X_ni_rcep_per = (X_nip_rcep - X_ni)./X_ni;
mainCountry_rcep_Per = X_ni_rcep_per(RCEP,RCEP);
disp(['Only RCEP change, the average bilateral trade increase percentage of RCEP countries is ',num2str(mean(mean(mainCountry_rcep_Per)))]);
%xlswrite('..\result\mainCountry_all_Per.xls',100*mainCountry_all_Per);
%xlswrite('..\result\mainCountry_rcep_Per.xls',100*mainCountry_rcep_Per);
disp(['Only RCEP Change, the average bilateral trade increase percentage of all coutnry is ',num2str(nanmean(nanmean(X_ni_rcep_per)))]);
disp(['Only RCEP Change, the total increas value is ',num2str(sum(sum(X_nip_rcep - X_ni))),...
    'million dollars. It is about',num2str(round(100*sum(sum(X_nip_rcep - X_ni))./sum(sum(X_ni)),4)),'%']);

% figure 
% h = heatmap(X_ni_all_per);
% h.MissingDataColor = [1 1 1];       %效果不佳，弃用
% h.GridVisible = 'on';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TABLE 13 Welfare effects from CJK's tariff reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Only RCEP, Average Country Welfeare is ',num2str(mean(Welfare_rcep))]);
disp(['Only RCEP, Average Country Real Wage is ',num2str(mean(RealWage_rcep))]);

InternalEffect = zeros(J,N);
PIj_ni_rcep_hat3D = permute(reshape(PIj_ni_rcep_hat,N,J,N),[1 3 2]);
ExternalEffect = zeros(J,N);
for j = 1:J
    ExternalEffect(j,:) = -alpha(j,:).*log(prod((pf0_rcep./(ones(J,1)*pf0_rcep(j,:)))...
        .^((reshape(kron((1 - B(j,:))',ones(J,1)).*G(:,j),J,N)))))./(B(j,:));
end
ExternalEffect(ExternalEffect == inf) = 0;
ExternalEffect(ExternalEffect == -inf) = 0;

for j = 1:J
    for n = 1:N
        InternalEffect(j,n) = - alpha(j,n)/(theta(j)*B(j,n))*log(PIj_ni_rcep_hat3D(n,n,j));
        if InternalEffect(j,n) == inf || InternalEffect(j,n) == -inf
            InternalEffect(j,n) = 0;
        end
    end
end
InternalEffect(isnan(InternalEffect) == 1) = 0;

CountryWelfare_onlyRCEP = [Welfare_rcep, ToT_rcep, VoT_rcep, ...
    RealWage_rcep-1,exp(sum(InternalEffect,1))'-1, ...
    exp(sum(ExternalEffect,1))' - 1];
% xlswrite('..\result\Why different trade type is important\CountryWelfare_onlyRCEP_CP2015.xlsx',100*CountryWelfare_onlyRCEP);


% xlswrite('..\result\InternalEffect_rcep.xlsx',InternalEffect);
% xlswrite('..\result\ExternalEffect_rcep.xlsx',ExternalEffect);
xlswrite('..\result\Why different trade type is important\RealWage_rcep_CP2015.xlsx',RealWage_rcep);
%%与RealWage_cjk比较没有问题
%test = exp(sum(InternalEffect + ExternalEffect)');

% %% CP2015
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   TABLE 3 Bilateral welfare effects from CJK's tariff redcutions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table3 = [sum(ToT_ni_cjk(rta, rta), 2)./I_n(rta), ...
%     (sum(ToT_ni_cjk(rta, :),2) - sum(ToT_ni_cjk(rta,rta),2))./I_n(rta), ...
%     sum(VoT_ni_cjk(rta, rta), 2)./I_n(rta), ...
%     (sum(VoT_ni_cjk(rta, :),2) - sum(VoT_ni_cjk(rta,rta),2))./I_n(rta)];
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TABLE 4 Sectoral contributions to welfare effects from CJK's tariff
%   reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ToTj_n_rcep2D = reshape(ToTj_n_rcep,N,J);
VoTj_n_rcep2D = reshape(VoTj_n_rcep,N,J);
% SectorContribution = [ToTj_n_rcep2D(CHN,1:20)'./sum((ToTj_n_rcep2D(CHN,1:20)')),...
%     VoTj_n_rcep2D(CHN,1:20)'./sum((VoTj_n_rcep2D(CHN,1:20)')), ...
%     ToTj_n_rcep2D(JPN,1:20)'./sum((ToTj_n_rcep2D(JPN,1:20)')), ...
%     VoTj_n_rcep2D(JPN,1:20)'./sum((VoTj_n_rcep2D(JPN,1:20)')), ...
%     ToTj_n_rcep2D(KOR,1:20)'./sum((ToTj_n_rcep2D(KOR,1:20)')), ...
%     VoTj_n_rcep2D(KOR,1:20)'./sum((VoTj_n_rcep2D(KOR,1:20)')), ...
%     ToTj_n_rcep2D(USA,1:20)'./sum((ToTj_n_rcep2D(USA,1:20)')), ...
%     VoTj_n_rcep2D(USA,1:20)'./sum((VoTj_n_rcep2D(USA,1:20)'))];
SectorContribution = zeros(J,2*length(RCEP));
for i = 1:length(RCEP)
    SectorContribution(:,2*i - 1:2*i) = ...
        [(ToTj_n_rcep2D(RCEP(i),:)'./nansum((ToTj_n_rcep2D(RCEP(i),:)'))).*(ToT_rcep(RCEP(i))/Welfare_rcep(RCEP(i))),...
        (VoTj_n_rcep2D(RCEP(i),:)'./nansum((VoTj_n_rcep2D(RCEP(i),:)'))).*(VoT_rcep(RCEP(i))/Welfare_rcep(RCEP(i)))];
end

% xlswrite('..\result\Why different trade type is important\SectorContribution.xlsx',100*SectorContribution);

D_n_rcep = sum(E_rcep)'-sum(M_rcep)';

VoTj_ni_rcep(isnan(VoTj_ni_rcep) == 1) = 0;
Welfarej_ni_rcep = (ToTj_ni_rcep + VoTj_ni_rcep)./kron(ones(J,N),I_n);

% xlswrite('..\result\Why different trade type is important\Welfarej_rcep.xlsx',100*Welfarej_ni_rcep);


%% the trade cost changes of intermediate and final goods are the same, meanwhile tariff reduction exist
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       after world's tariff and trade cost reduction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat J N alphas;
load ..\data\tau_JIE.mat tau tau_rcep_ftariff tau_rcep_mtariff;
load ..\data\rcep_JIE.mat Xj_m_np_rcep Xj_f_np_rcep PIj_m_nip_rcep ...
    PIj_f_nip_rcep Xj_f_ni Xj_m_ni RCEP wf0_rcep pf_rcep;

Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;

Xj_ni = Xj_f_ni + Xj_m_ni;                                                  %[importer exporter]
Xj_nip_rcep = Xj_m_nip_rcep + Xj_f_nip_rcep;
% Yj_ni = Xj_f_ni./tau + Xj_m_ni./tau;

X_ni = sum(permute(reshape(Xj_ni,N,J,N),[1 3 2]),3);
X_nip_rcep = sum(permute(reshape(Xj_nip_rcep,N,J,N),[1 3 2]),3);

X_ni_hat = X_nip_rcep./X_ni;

xlswrite('..\result\Why different trade type is important\Xni_rcep.xlsx',X_ni_hat);


X_ni_rcep_per = (X_nip_rcep - X_ni)./X_ni;
mainCountry_rcep_Per = X_ni_rcep_per(RCEP,RCEP);
disp(['----------------------------------------------------------------------------------------------']);
disp(['If the trade cost of intermediate and final use is equal,']);
disp(['and RCEP reduced the trade cost reduction with tariff reduction']);
disp(['----------------------------------------------------------------------------------------------']);
disp(['The average bilateral trade increase percentage of RCEP countries is ',num2str(mean(mean(mainCountry_rcep_Per)))]);
disp(['The average bilateral trade increase percentage of all coutnry is ',num2str(nanmean(nanmean(X_ni_rcep_per)))]);
disp(['The total increase value is ',num2str(sum(sum(X_nip_rcep - X_ni))),...
    'million dollars. It is about ',num2str(round(100*sum(sum(X_nip_rcep - X_ni))./sum(sum(X_ni)),4)),'%']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Welfare effects from RCEP's tariff and trade cost reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RealWage_rcep = wf0_rcep./(prod(pf_rcep.^alphas,1)');
disp(['The average Real Wage change of all countries is ',num2str(mean(RealWage_rcep))]);

xlswrite('..\result\Why different trade type is important\RealWage_rcep.xlsx',100*(RealWage_rcep - 1));
%% only same trade cost change between intermediate and final use, without tariff change
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       after world's trade cost reductions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ..\data\basic.mat J N alphas;
load ..\data\tau_JIE_onlyTradeCostchange.mat tau tau_rcep_ftariff tau_rcep_mtariff;
load ..\data\rcep_JIE_onlyTradeCostchange.mat Xj_m_np_rcep Xj_f_np_rcep PIj_m_nip_rcep ...
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
disp(['If the trade cost of intermediate and final use is equal,']);
disp(['and RCEP reduced both trade cost only']);
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
