clear all
%%
%�����趨

load '..\data\basic.mat' alphas B G J maxit N tau_hat taup theta tol vfactor;

tau = taup;

% Parameters

%% Share of value added ʹ��GOVA_44_12_2002.do�ļ����ԭʼ����
%ȱ��ROW�����ݣ������趨Ϊ�������ݵ�ƽ��ֵ
load ..\data\GOp_JIE.mat;    GO = GOp;

% calculating expenditures
load ..\data\Xj_nip_JIE.mat
Xj_m_ni = Xj_m_nip;                                 % ��1��65*65�����ǵ�1�������й���n���й���i���ڵĿ�֧
Xj_f_ni = Xj_f_nip;

%3ά����

% Calculating X0 Expenditure
Xj_m_n=sum(Xj_m_ni');                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧
Xj_f_n=sum(Xj_f_ni');

% Calculating Expenditure shares
Xj_m_n = Xj_m_n'*ones(1,N);                                      % ����n����j���Ų�Ʒ���ܻ���
PIj_m_ni=Xj_m_ni./Xj_m_n;                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
PIj_m_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ

Xj_f_n = Xj_f_n'*ones(1,N);
PIj_f_ni=Xj_f_ni./Xj_f_n;
PIj_f_ni(isnan(PIj_f_ni)) = 0;
PIj_f_ni((J-1)*N + 1:J*N, :) = eye(N);

% Calculating superavits
Yj_ni=Yj_nip;                                            % ������FOB
Sn = sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),2) - ...
    sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),1)';    %for JIE 2019
Sn = Sn.*0;                                                % ��֤surplus����0
INVj_ni = Yj_ni - Xj_f_ni./tau - Xj_m_ni./tau;
INVj_ni = INVj_ni.*0;

% Calculating Value Added 
wLj_n=GO.*B;                                           % ����n����j���Ͷ�������ֵ
wL_n=sum(wLj_n)';                                            % ����n���Ͷ�������ֵ

save ..\data\nodeficit_JIE.mat tau_hat taup ...
    alphas theta B G PIj_m_ni PIj_f_ni J N maxit tol wL_n Sn vfactor INVj_ni;
%%

clear
load ..\data\nodeficit_JIE.mat;
kappa_m_hat = tau_hat;
kappa_f_hat = tau_hat;
tau_mp = taup;
tau_fp = taup;
[wf0_noD,pm_noD,pf_noD,Xj_m_np_noD,Xj_f_np_noD,PIj_m_nip_noD,PIj_f_nip_noD,Sn_noD,c_noD] = ...
    main_JIE(kappa_m_hat, kappa_f_hat,tau_mp,tau_fp,alphas,theta,B,G,PIj_m_ni,PIj_f_ni,J,N,maxit,tol,wL_n,Sn,INVj_ni,vfactor);
% ��һ��������ԭ����
Xj_m_nip_noD = (Xj_m_np_noD*ones(1,N)).*PIj_m_nip_noD;
Xj_f_nip_noD = (Xj_f_np_noD*ones(1,N)).*PIj_f_nip_noD;
Yj_nip_noD = ((Xj_m_np_noD*ones(1,N))./tau_mp).*PIj_m_nip_noD + ...
    ((Xj_f_np_noD*ones(1,N))./tau_fp).*PIj_f_nip_noD + INVj_ni;
% 
% for j=1:J
%     GOp(j,:) = sum(Yj_nip(1+(j-1)*N : j*N,:));
% end
GOp_noD = sum(permute(reshape(Yj_nip_noD,N,J,N),[2 3 1]),3);


RealWage_noD = wf0_noD./(prod(pf_noD.^alphas,1))';

save('..\data\Xj_nip_nodeficit_JIE', 'Xj_f_nip_noD','Xj_m_nip_noD','Yj_nip_noD');
save('..\data\GOp_nodeficit_JIE', 'GOp_noD');
