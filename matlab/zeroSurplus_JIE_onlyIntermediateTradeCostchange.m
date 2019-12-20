% Loading trade flows
%% �Թ�˰���ݽ��е�����101Ϊ��ó��Ʒ��˰������ҵ���ż���ֵ�ϴ�
% Parameters
load ..\data\basic.mat alphas B G J N maxit taup theta tol vfactor;
tau = taup;

load ..\data\GOp_nodeficit_JIE.mat;    GO = GOp_noD;

% calculating expenditures
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
Sn = sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),2) - ...
    sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),1)';    %for JIE 2019
Sn = Sn.*0;                                                % ��֤surplus����0
INVj_ni = Yj_ni - Xj_f_ni./tau - Xj_m_ni./tau;
% INVj_ni = INVj_ni.*0;

% Calculating Value Added 
wLj_n=GO.*B;                                           % ����n����j���Ͷ�������ֵ
wL_n=sum(wLj_n)';     

tau_mp = taup;
tau_fp = taup;
kappa_m_hat = taup./tau;
kappa_f_hat = taup./tau;
% 
% [wf0_zeroS,pm_zeroS,pf_zeroS,Xj_m_np_zeroS,Xj_f_np_zeroS,PIj_m_nip_zeroS,PIj_f_nip_zeroS,Sn_zeroS,c_zeroS] = ...
%     main_JIE(kappa_m_hat, kappa_f_hat,tau_mp,tau_fp,alphas,theta,B,G,PIj_m_ni,PIj_f_ni,J,N,maxit,tol,wL_n,Sn,INVj_ni,vfactor);
% 
% RealWage_zeroS = wf0_zeroS./(prod(pf_zeroS.^alphas,1)');
% 
% save ..\data\zeroS_JIE.mat wf0_zeroS pf_zeroS pm_zeroS Xj_m_np_zeroS Xj_f_np_zeroS ...
%     PIj_m_nip_zeroS PIj_f_nip_zeroS Sn_zeroS c_zeroS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%all tariff chage 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ���ڲ���ó��Ʒ�Ĺ�˰�ɱ���ʱ��֪��ε���,�����趨Ϊ101


mu_m = -xlsread('..\data\theta-mu2.xlsx','C1:C17');
mu_f = -xlsread('..\data\theta-mu2.xlsx','D1:D17');

cp_m = ones(N,N,J);
cp_f = ones(N,N,J);

for j = 1 : J - 1                                              %����ҵ���������ó�ף��ʶ�ó�׳ɱ�δ��RTA�����仯
    for i = 1:length(RCEP)
        for n = 1:length(RCEP)
            cp_m(RCEP(i),RCEP(n),j) = exp(mu_m(j,1));
%             cp_f(RCEP(i),RCEP(n),j) = exp(mu_f(j,1));
            if n == i
                cp_m(RCEP(i),RCEP(n),j) = 1;
%                 cp_f(RCEP(i),RCEP(n),j) = 1;
            end
        end
    end
end
cp_m = reshape(permute(cp_m,[1 3 2]),J*N,N);
cp_f = reshape(permute(cp_f,[1 3 2]),J*N,N);

tau_rcep_mtariff = permute(reshape(tau,N,J,N),[1 3 2]);
tau_rcep_ftariff = permute(reshape(tau,N,J,N),[1 3 2]);
% for j = 1 : J - 1
%     for n = 1:length(RCEP)
%         for i = 1:length(RCEP)
%             tau_rcep_mtariff(RCEP(i),RCEP(n),j) = 1;                       
%             tau_rcep_ftariff(RCEP(i),RCEP(n),j) = 1; 
%         end
%     end
% end
tau_rcep_mtariff = reshape(permute(tau_rcep_mtariff,[1 3 2]),J*N,N);
tau_rcep_ftariff = reshape(permute(tau_rcep_ftariff,[1 3 2]),J*N,N);

kappa_m_hat_rcep=cp_m;                                           % Change in trade cost
kappa_f_hat_rcep=cp_f;
% tau_hat_rcep=tau_rcep_tariff./tau;
% tau_hat_rcep((J-1)*N +1 :J*N,1:N) = cp((J - 1)*N + 1:J*N, :);         % ����ҵ�������ڲ���������һ���˰�Ȳ��ᷢ���仯

[wf0_rcep,pm_rcep,pf_rcep,Xj_m_np_rcep,Xj_f_np_rcep,PIj_m_nip_rcep,PIj_f_nip_rcep,Sn_rcep,c_rcep] = ...
    main_JIE(kappa_m_hat_rcep, kappa_f_hat_rcep,tau_rcep_mtariff,tau_rcep_ftariff,alphas,theta,B,G,PIj_m_ni,PIj_f_ni,J,N,maxit,tol,wL_n,Sn,INVj_ni,vfactor);


RealWage_rcep = wf0_rcep./(prod(pf_rcep.^alphas,1)');


save ..\data\rcep_JIE_onlyIntermediateTradeCostchange.mat wf0_rcep pf_rcep pm_rcep Xj_m_np_rcep Xj_f_np_rcep ...
    PIj_m_nip_rcep PIj_f_nip_rcep Sn_rcep c_rcep Xj_f_ni Xj_m_ni ...
    RealWage_rcep RCEP ASEAN AUS JPN KOR NZL CHN IND BRN KHM ...
    IDN MYS PHL SGP THA VNM;

save ..\data\tau_JIE_onlyIntermediateTradeCostchange.mat taup tau_mp tau_fp tau ...
    kappa_m_hat_rcep kappa_f_hat_rcep tau_rcep_mtariff tau_rcep_ftariff;
