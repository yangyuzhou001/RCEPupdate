clear all;
%%
%�����趨

%Inputs

% Countries = [
%     AUS   �Ĵ�����   ISL       ����   POL         ����   BGR     ��������   MAR         Ħ���  
%     AUT     �µ���   IRL     ������   PRT       ������   KHM       ����կ   PER           ��³  
%     BEL     ����ʱ   ISR     ��ɫ��   SVK     ˹�工��   CHN         �й�   PHL         ���ɱ�  
%     CAN     ���ô�   ITA     �����   SVN   ˹��������   COL     ���ױ���   ROU       ��������  
%     CHL       ����   JPN       �ձ�   ESP       ������   CRI   ��˹�����   RUS         ����˹  
%     CZE       �ݿ�   KOR       ����   SWE         ���   HRV     ���޵���   SAU     ɳ�ذ�����  
%     DNK       ����   LVA   ����ά��   CHE         ��ʿ   CYP     ����·˹   SGP         �¼���  
%     EST   ��ɳ����   LTU     ������   TUR       ������   IND         ӡ��   ZAF           �Ϸ�  
%     FIN       ����   LUX     ¬ɭ��   GBR         Ӣ��   IDN   ӡ��������   TWN       �й�̨��  
%     FRA       ����   MEX     ī����   USA         ����   HKG     �й����   THA           ̩��  
%     DEU       �¹�   NLD       ����   ARG       ����͢   KAZ   ������˹̹   TUN         ͻ��˹  
%     GRC       ϣ��   NZL     ������   BRA         ����   MYS     ��������   VNM           Խ��  
%     HUN     ������   NOR       Ų��   BRN         ����   MLT       �����   ROW   �������ҵ��� 
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
%% �Թ�˰���ݽ��е�����101Ϊ��ó��Ʒ��˰������ҵ���ż���ֵ�ϴ�
% Parameters
load ..\data\basic.mat
tau = taup;

load ..\data\GOp_nodeficit.mat;    GO = GOp_noD;
load ..\data\alphas_nodeficit.mat

% calculating expenditures
load ..\data\Xj_nip_nodeficit.mat
Xj_ni = Xj_nip_noD;                                          % ��1��31*31�����ǵ�1�������й���n���й���i���ڵĿ�֧

%3ά����


% Calculating X0 Expenditure
Xj_n=sum((Xj_ni'));                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
PIj_ni=Xj_ni./(Xj_n'*ones(1,N));                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_ni(isnan(PIj_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Calculating superavits
Yj_ni=Xj_ni./tau;                                            % ������FOB
M = zeros(J,N);
E = zeros(J,N);
for j      = 1:1:J
    % Imports
    M(j,:) = (sum(Yj_ni(1+N*(j-1):N*j,:)' - diag(diag(Yj_ni(1 + N*(j - 1):N*j,:)))))';                % ���ڹ��ҽ��ڲ��ŵ��ܽ���
    for n  = 1:1:N
    % Exports
    E(j,n) = sum(Yj_ni(1+N*(j-1):N*j,n)) - Yj_ni(n + N*(j - 1),n);                   % ���ڹ��ҳ��ڲ��ŵ��ܳ���
    end
end

D_n=sum(E)'-sum(M)';                                         % ��������D_n = sum(M)' - sum(E)';
D_n = D_n.*0;                                                % ��֤deficit����0

% Calculating Value Added 
wLj_n=GO.*B;                                           % ����n����j���Ͷ�������ֵ
wL_n=sum(wLj_n)';                                            % ����n���Ͷ�������ֵ

%%
R_n = sum(sum(permute(reshape((tau - 1).*Yj_ni,N,J,N),[1 3 2]),3),2);
I_n = wL_n + R_n - D_n;


[wf0_zeroS,pf0_zeroS,Xj_np_zeroS,PIj_nip_zeroS,Sn_zeroS,c_zeroS,wf_history,e] = main(tau_hat,taup,...
    alpha,theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);


save ..\data\zeroS.mat wf0_zeroS pf0_zeroS Xj_np_zeroS PIj_nip_zeroS Sn_zeroS c_zeroS E M Xj_ni Yj_ni PIj_ni Xj_n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%all tariff chage 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ���ڲ���ó��Ʒ�Ĺ�˰�ɱ���ʱ��֪��ε���,�����趨Ϊ101


mu = -xlsread('..\data\theta-mu.xlsx','C1:C18');
% rta = xlsread('rta.xls');
% rtap = rta(:,66);
% rta = rta(:,52);
% 
% rtap(316,1) = 1;    rtap(333,1) = 1;    rtap(334,1) = 1;    % 
% rtap(1064,1) = 1;   rtap(1081,1) = 1;   rtap(1082,1) = 1;   %
% rtap(1108,1) = 1;   rtap(1125,1) = 1;   rtap(1126,1) = 1;   %
cp = ones(N,N,J);
for j = 1 : J - 1                                              %����ҵ���������ó�ף��ʶ�ó�׳ɱ�δ��RTA�����仯
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
% for j = 1 : J - 1                                              %����ҵ���������ó�ף��ʶ�ó�׳ɱ�δ��RTA�����仯
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
% tau_hat_all((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);           % ����ҵ�������ڲ���������һ���˰�Ȳ��ᷢ���仯
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
% tau_hat = taup./tau;                                          %�����������������ʵ����Ϊ��ʵ�в������ھ�ֵ��˰�仯
% tau_hat((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % ����ҵ�������ڲ���������һ���˰�Ȳ��ᷢ���仯
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
% tau_hat_rcep((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % ����ҵ�������ڲ���������һ���˰�Ȳ��ᷢ���仯

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
% tau_hat_nCJK((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % ����ҵ�������ڲ���������һ���˰�Ȳ��ᷢ���仯
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
% %Xj_np_cjk �ڲ��ǲ��ţ��ⲿ�ǹ���
% Xj_nip_cjk = (reshape(reshape(Xj_np_cjk,J,N)',J*N,1)*ones(1,N)).*PIj_nip_cjk;
% Yj_nip_cjk=Xj_nip_cjk./tau_cjk;                                            % ������FOB
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
% %     M_nafta(j,:) = (sum(Yj_nip_nafta(1+N*(j-1):N*j,:)'))';                % ���ڹ��ҽ��ڲ��ŵ��ܽ���
% %     for n  = 1:1:N
% %     % Exports
% %     E_nafta(j,n) = sum(Yj_nip_nafta(1+N*(j-1):N*j,n));                   % ���ڹ��ҳ��ڲ��ŵ��ܳ���
% %     end
% % end
% for j      = 1:1:J
%     % Imports
%     M_cjk(j,:) = (sum(Yj_nip_cjk(1+N*(j-1):N*j,:)' - diag(diag(Yj_nip_cjk(1 + N*(j - 1):N*j,:)))))';                % ���ڹ��ҽ��ڲ��ŵ��ܽ���
%     for n  = 1:1:N
%     % Exports
%     E_cjk(j,n) = sum(Yj_nip_cjk(1+N*(j-1):N*j,n)) - Yj_nip_cjk(n + N*(j - 1),n);                   % ���ڹ��ҳ��ڲ��ŵ��ܳ���
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
% D_n=sum(E)'-sum(M)';                                         % ��������D_n = sum(M)' - sum(E)';
% I_n = wL_n + R_n - D_n;
% 
% [wf0_cjk_deficit pf0_cjk_deficit Xj_np_cjk_deficit PIj_nip_cjk_deficit Sn_cjk_deficit c_cjk_deficit] = main(tau_hat_all,tau_all,alphas, ...
%     theta,VAShare,IO,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
% RealWage_cjk_deficit = wf0_cjk./(prod(pf0_cjk_deficit.^alphas,1)');
% [Welfare_cjk_deficit,ToT_cjk_deficit, VoT_cjk_deficit, ToT_ni_cjk_deficit,VoT_ni_cjk_deficit,ToTj_n_cjk_deficit,VoTj_n_cjk_deficit] = ...
%     F16(Yj_ni,J,N,c_cjk_deficit,I_n,tau, tau_all, Xj_np_cjk_deficit, PIj_nip_cjk_deficit);