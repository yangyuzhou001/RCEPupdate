clear all;
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
RCEP = [AUS JPN KOR NZL CHN IND ASEAN];
% RCEP = [JPN KOR CHN];
% RCEP = [AUS NZL IND ASEAN];
% Loading trade flows
%% 对关税数据进行调整，101为非贸易品关税，服务业部门加总值较大
% Parameters
load ..\data\basic.mat
tau = taup;

load ..\data\GOp_nodeficit.mat;    GO = GOp_noD;
load ..\data\alphas_nodeficit.mat

% calculating expenditures
load ..\data\Xj_nip_nodeficit.mat
Xj_ni = Xj_nip_noD;                                          % 第1个31*31矩阵是第1个部门行国家n从列国家i进口的开支

%3维处理


% Calculating X0 Expenditure
Xj_n=sum((Xj_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_ni=Xj_ni./(Xj_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_ni(isnan(PIj_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Calculating superavits
Yj_ni=Xj_ni./tau;                                            % 总收益FOB
M = zeros(J,N);
E = zeros(J,N);
for j      = 1:1:J
    % Imports
    M(j,:) = (sum(Yj_ni(1+N*(j-1):N*j,:)' - diag(diag(Yj_ni(1 + N*(j - 1):N*j,:)))))';                % 进口国家进口部门的总进口
    for n  = 1:1:N
    % Exports
    E(j,n) = sum(Yj_ni(1+N*(j-1):N*j,n)) - Yj_ni(n + N*(j - 1),n);                   % 出口国家出口部门的总出口
    end
end

D_n=sum(E)'-sum(M)';                                         % 论文中是D_n = sum(M)' - sum(E)';
D_n = D_n.*0;                                                % 保证deficit等于0

% Calculating Value Added 
wLj_n=GO.*B;                                           % 国家n部门j的劳动力附加值
wL_n=sum(wLj_n)';                                            % 国家n的劳动力附加值

%%
R_n = sum(sum(permute(reshape((tau - 1).*Yj_ni,N,J,N),[1 3 2]),3),2);
I_n = wL_n + R_n - D_n;


[wf0_zeroS,pf0_zeroS,Xj_np_zeroS,PIj_nip_zeroS,Sn_zeroS,c_zeroS,wf_history,e] = main(tau_hat,taup,...
    alpha,theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);


save ..\data\zeroS.mat wf0_zeroS pf0_zeroS Xj_np_zeroS PIj_nip_zeroS Sn_zeroS c_zeroS E M Xj_ni Yj_ni PIj_ni Xj_n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%all tariff chage 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 对于不可贸易品的关税成本暂时不知如何调整,暂且设定为101


mu = -xlsread('..\data\theta-mu.xlsx','C1:C18');
% rta = xlsread('rta.xls');
% rtap = rta(:,66);
% rta = rta(:,52);
% 
% rtap(316,1) = 1;    rtap(333,1) = 1;    rtap(334,1) = 1;    % 
% rtap(1064,1) = 1;   rtap(1081,1) = 1;   rtap(1082,1) = 1;   %
% rtap(1108,1) = 1;   rtap(1125,1) = 1;   rtap(1126,1) = 1;   %
cp = ones(N,N,J);
for j = 1 : J - 1                                              %服务业不参与国际贸易，故而贸易成本未因RTA发生变化
    for i = 1:length(RCEP)
        for n = 1:length(RCEP)
            cp(RCEP(i),RCEP(n),j) = exp(mu(j,1));
            if n == i
                cp(RCEP(i),RCEP(n),j) = 1;
            end
        end
    end
end
cp = reshape(permute(cp,[1 3 2]),J*N,N);

% tau_all=taup.*cp;        % counterfactual trade cost vector
% 
% tau_tariff = permute(reshape(taup,N,J,N),[1 3 2]);       % counterfactual tariff vector
% for j = 1 : J - 1                                              %服务业不参与国际贸易，故而贸易成本未因RTA发生变化
%     for n = 1:14
%         for i = 1:14
%             tau_tariff(RCEP(i),RCEP(n),j) = 1;
%         end
%     end
% end
% tau_tariff = reshape(permute(tau_tariff,[1 3 2]),J*N,N);
% 
% tau_hat_all =tau_all./tau;                    % Change in trade cost
% 
% 
% % taup = tau;
% tau_hat_all((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);           % 服务业部门由于不可流动，一般关税比不会发生变化
% % taup=tau;                                                    % counterfactual tariff vector
% 
% 
% [wf0_all, pf0_all, Xj_np_all, PIj_nip_all, Sn_all, c_all] = main(tau_hat_all,tau_all,alphas,...
%     theta,VAShare,IO,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
% RealWage_all = wf0_all./(prod(pf0_all.^alphas,1)');
% 
% [Welfare_all,ToT_all, VoT_all, ToT_ni_all,VoT_ni_all,ToTj_n_all,VoTj_n_all, ToTj_ni_all, VoTj_ni_all] = ...
%     F16(Yj_ni,J,N,c_all,I_n,tau, tau_tariff, Xj_np_all, PIj_nip_all);
% 
% save ..\data\all.mat tau_all wf0_all pf0_all Xj_np_all PIj_nip_all Sn_all c_all RealWage_all ...
%     Welfare_all ToT_all VoT_all ToT_ni_all VoT_ni_all ToTj_n_all VoTj_n_all ToTj_ni_all VoTj_ni_all I_n
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                       all tariff change without RTA chage 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tau_hat = taup./tau;                                          %这种情况并不符合现实，因为现实中并不存在均值关税变化
% tau_hat((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % 服务业部门由于不可流动，一般关税比不会发生变化
% [wf0_all_nCJK, pf0_all_nCJK, Xj_np_all_nCJK, PIj_nip_all_nCJK, Sn_all_nCJK, c_all_nCJK] = main(tau_hat,taup,alphas,...
%     theta,VAShare,IO,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
% RealWage_all_nCJK = wf0_all_nCJK./(prod(pf0_all_nCJK.^alphas,1)');
% 
% [Welfare_all_nCJK, ToT_all_nCJK, VoT_all_nCJK, ToT_ni_all_nCJK, VoT_ni_all_nCJK, ToTj_n_all_nCJK, VoTj_n_all_nCJK, ...
%     ToTj_ni_all_nCJK, VoTj_ni_all_nCJK] = F16(Yj_ni,J,N,c_all_nCJK,I_n,tau, taup, Xj_np_all_nCJK, PIj_nip_all_nCJK);
% 
% save ..\data\all_nCJK.mat wf0_all_nCJK pf0_all_nCJK Xj_np_all_nCJK PIj_nip_all_nCJK Sn_all_nCJK c_all_nCJK ...
%     RealWage_all_nCJK Welfare_all_nCJK ToT_all_nCJK VoT_all_nCJK ToT_ni_all_nCJK VoT_ni_all_nCJK ToTj_n_all_nCJK ...
%     VoTj_n_all_nCJK ToTj_ni_all_nCJK VoTj_ni_all_nCJK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%only RCEP tariff chage        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% counterfactual tariff vector
tau_rcep = tau.*cp;
tau_rcep_tariff = permute(reshape(tau,N,J,N),[1 3 2]);
for j = 1 : J - 1
    for n = 1:length(RCEP)
        for i = 1:length(RCEP)
            tau_rcep_tariff(RCEP(i),RCEP(n),j) = 1;                       
        end
    end
end
tau_rcep_tariff = reshape(permute(tau_rcep_tariff,[1 3 2]),J*N,N);

tau_hat_rcep=tau_rcep./tau;                                           % Change in trade cost
% tau_hat_rcep=tau_rcep_tariff./tau;
% tau_hat_rcep((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % 服务业部门由于不可流动，一般关税比不会发生变化

[wf0_rcep,pf0_rcep, Xj_np_rcep, PIj_nip_rcep, Sn_rcep, c_rcep] = main(tau_hat_rcep,tau_rcep_tariff,alpha, ...
    theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
RealWage_rcep = wf0_rcep./(prod(pf0_rcep.^alpha,1)');
[Welfare_rcep,ToT_rcep, VoT_rcep, ToT_ni_rcep,VoT_ni_rcep,ToTj_n_rcep,VoTj_n_rcep, ToTj_ni_rcep, VoTj_ni_rcep] = ...
    F16(Yj_ni,J,N,c_rcep,I_n,tau, tau_rcep_tariff, Xj_np_rcep, PIj_nip_rcep);

save ..\data\rcep.mat wf0_rcep pf0_rcep Xj_np_rcep PIj_nip_rcep Sn_rcep c_rcep ...
    RealWage_rcep Welfare_rcep ToT_rcep VoT_rcep ToT_ni_rcep VoT_ni_rcep ToTj_n_rcep ...
    VoTj_n_rcep ToTj_ni_rcep VoTj_ni_rcep RCEP ASEAN AUS JPN KOR NZL CHN IND BRN KHM ...
    IDN MYS PHL SGP THA VNM I_n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       without CJK chage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% tau_nCJK = tau_all;
% 
% for j = 1 : J
%     tau_nCJK(CHN + (j - 1)*N, JPN) = tau(CHN + (j - 1)*N, JPN);
%     tau_nCJK(CHN + (j - 1)*N, KOR) = tau(CHN + (j - 1)*N, KOR);
%     tau_nCJK(JPN + (j - 1)*N, CHN) = tau(JPN + (j - 1)*N, CHN);
%     tau_nCJK(JPN + (j - 1)*N, KOR) = tau(JPN + (j - 1)*N, KOR);
%     tau_nCJK(KOR + (j - 1)*N, CHN) = tau(KOR + (j - 1)*N, CHN);
%     tau_nCJK(KOR + (j - 1)*N, JPN) = tau(KOR + (j - 1)*N, JPN);
% end
% tau_hat_nCJK = tau_nCJK./tau;
% tau_hat_nCJK((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % 服务业部门由于不可流动，一般关税比不会发生变化
% 
% [wf0_nCJK,pf0_nCJK,Xj_np_nCJK,PIj_nip_nCJK,Sn_nCJK,c_nCJK] = main(tau_hat_nCJK,tau_nCJK,alphas, ...
%     theta,VAShare,IO,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
% RealWage_nCJK = wf0_nCJK./(prod(pf0_nCJK.^alphas,1)');
% [Welfare_nCJK,ToT_nCJK, VoT_nCJK, ToT_ni_nCJK,VoT_ni_nCJK,ToTj_n_nCJK,VoTj_n_nCJK, ToTj_ni_nCJK, VoTj_ni_nCJK] = ...
%     F16(Yj_ni,J,N,c_nCJK,I_n,tau, tau_nCJK, Xj_np_nCJK, PIj_nip_nCJK);
% 
% save ..\data\nCJK.mat wf0_nCJK pf0_nCJK Xj_np_nCJK PIj_nip_nCJK Sn_nCJK c_nCJK ...
%     RealWage_nCJK Welfare_nCJK ToT_nCJK VoT_nCJK ToT_ni_nCJK VoT_ni_nCJK ToTj_n_nCJK ...
%     VoTj_n_nCJK ToTj_ni_nCJK VoTj_ni_nCJK

save ..\data\tau.mat taup tau_rcep tau_hat_rcep tau_rcep_tariff;
%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   TABLE 5 Trade effects from CJK's tariff reductions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Xj_np_cjk 内部是部门，外部是国家
% Xj_nip_cjk = (reshape(reshape(Xj_np_cjk,J,N)',J*N,1)*ones(1,N)).*PIj_nip_cjk;
% Yj_nip_cjk=Xj_nip_cjk./tau_cjk;                                            % 总收益FOB
% 
% Importp = 100*(sum(permute(reshape(Yj_nip_cjk,N,J,N),[1 3 2]),3)./sum(permute(reshape(Yj_ni,N,J,N),[1 3 2]),3) - 1);
% table5 = [Importp(CHN,CHN),Importp(CHN,JPN), Importp(CHN,KOR);
%     Importp(JPN, CHN), Importp(JPN,JPN), Importp(JPN,KOR);
%     Importp(KOR, CHN), Importp(KOR, JPN), Importp(KOR,KOR)];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %   TABLE 6 Export shares by sector before and after CJK's tariff
% %   reductions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for j      = 1:1:J
% %     % Imports
% %     M_nafta(j,:) = (sum(Yj_nip_nafta(1+N*(j-1):N*j,:)'))';                % 进口国家进口部门的总进口
% %     for n  = 1:1:N
% %     % Exports
% %     E_nafta(j,n) = sum(Yj_nip_nafta(1+N*(j-1):N*j,n));                   % 出口国家出口部门的总出口
% %     end
% % end
% for j      = 1:1:J
%     % Imports
%     M_cjk(j,:) = (sum(Yj_nip_cjk(1+N*(j-1):N*j,:)' - diag(diag(Yj_nip_cjk(1 + N*(j - 1):N*j,:)))))';                % 进口国家进口部门的总进口
%     for n  = 1:1:N
%     % Exports
%     E_cjk(j,n) = sum(Yj_nip_cjk(1+N*(j-1):N*j,n)) - Yj_nip_cjk(n + N*(j - 1),n);                   % 出口国家出口部门的总出口
%     end
% end
% EjnpShare = E_cjk./(ones(J,1)*sum(E_cjk));
% EShare = E./(ones(J,1)*sum(E));
% 
% table6 = 100*[EShare(1:20,CHN), EjnpShare(1:20,CHN), EShare(1:20,JPN), ...
%     EjnpShare(1:20,JPN), EShare(1:20,KOR), EjnpShare(1:20,KOR)];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %	TABLE 7 Welfare effects from world tariff reductions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table8 = [Welfare_all(1:22,:), ToT_all(1:22,:) VoT_all(1:22,:), ...
%     Welfare_all(23:44,:), ToT_all(23:44,:), VoT_all(23:44,:)];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %	TABLE 8 Bilateral welfare effects from world's tariff reductions
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table8 = [sum(ToT_ni_all(20,rta),2)/I_n(20), (sum(ToT_ni_all(20,:),2) - sum(ToT_ni_all(20,rta),2))/I_n(20), ...
%     sum(VoT_ni_all(20,rta),2)/I_n(20), (sum(VoT_ni_all(20,:), 2) - sum(VoT_ni_all(20,rta),2))/I_n(20);
%     sum(ToT_ni_all(5,rta),2)/I_n(5), (sum(ToT_ni_all(5,:),2) - sum(ToT_ni_all(5,rta),2))/I_n(5), ...
%     sum(VoT_ni_all(5,rta),2)/I_n(5), (sum(VoT_ni_all(5,:), 2) - sum(VoT_ni_all(5,rta),2))/I_n(5);
%     sum(ToT_ni_all(30,rta),2)/I_n(30), (sum(ToT_ni_all(30,:),2) - sum(ToT_ni_all(30,rta),2))/I_n(30), ...
%     sum(VoT_ni_all(30,rta),2)/I_n(30), (sum(VoT_ni_all(30,:), 2) - sum(VoT_ni_all(30,rta),2))/I_n(30);];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %	TABLE 9 Welfare effects from CJK given world tariff changes
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ToT_cjk_nCJK = (1 + ToT_all)./(1 + ToT_nCJK) - 1;
% VoT_cjk_nCJK = (1 + VoT_all)./(1 + VoT_nCJK) - 1;
% Welfare_cjk_nCJK = ToT_cjk_nCJK + VoT_cjk_nCJK;
% RealWage_cjk_nCJK = RealWage_all./RealWage_nCJK;
% 
% table9 = [Welfare_cjk_nCJK(rta'), ToT_cjk_nCJK(rta'), VoT_cjk_nCJK(rta'), RealWage_cjk_nCJK(rta')];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %	TABLE 10 Bilateral welfare effects from CJK given world tariff changes
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ToT_ni_cjk_nCJK = (1 + ToT_ni_all)./(1 + ToT_ni_nCJK) - 1;
% VoTj_ni_cjk_nCJK = (1 + VoTj_ni_all)./(1 + VoTj_ni_nCJK) - 1;
% VoT_ni_cjk_nCJK = nansum(permute(reshape(VoTj_ni_cjk_nCJK, N, J, N), [1 3 2]), 3);
% table10 = [sum(ToT_ni_cjk_nCJK(rta, rta), 2)./I_n(rta), ...
%     ToT_cjk_nCJK(rta) - (sum(ToT_ni_cjk_nCJK(rta, rta), 2))./I_n(rta), ...
%     sum(VoT_ni_cjk_nCJK(rta,rta),2)./I_n(rta), ...
%     VoT_cjk_nCJK(rta) - (sum(VoT_ni_cjk_nCJK(rta, rta), 2))./I_n(rta)];
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %only rta tariff chage        TABLE 4A
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D_n=sum(E)'-sum(M)';                                         % 论文中是D_n = sum(M)' - sum(E)';
% I_n = wL_n + R_n - D_n;
% 
% [wf0_cjk_deficit pf0_cjk_deficit Xj_np_cjk_deficit PIj_nip_cjk_deficit Sn_cjk_deficit c_cjk_deficit] = main(tau_hat_all,tau_all,alphas, ...
%     theta,VAShare,IO,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
% RealWage_cjk_deficit = wf0_cjk./(prod(pf0_cjk_deficit.^alphas,1)');
% [Welfare_cjk_deficit,ToT_cjk_deficit, VoT_cjk_deficit, ToT_ni_cjk_deficit,VoT_ni_cjk_deficit,ToTj_n_cjk_deficit,VoTj_n_cjk_deficit] = ...
%     F16(Yj_ni,J,N,c_cjk_deficit,I_n,tau, tau_all, Xj_np_cjk_deficit, PIj_nip_cjk_deficit);