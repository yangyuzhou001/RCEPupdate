clear all
%%
%参数设定

load '..\data\basic.mat' alphas B G J maxit N tau_hat taup theta tol vfactor;

tau = taup;

% Parameters

%% Share of value added 使用GOVA_44_12_2002.do文件获得原始数据
%缺少ROW的数据，暂且设定为其他数据的平均值
load ..\data\GOp_JIE.mat;    GO = GOp;

% calculating expenditures
load ..\data\Xj_nip_JIE.mat
Xj_m_ni = Xj_m_nip;                                 % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip;

%3维处理

% Calculating X0 Expenditure
Xj_m_n=sum(Xj_m_ni');                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
Xj_f_n=sum(Xj_f_ni');

% Calculating Expenditure shares
Xj_m_n = Xj_m_n'*ones(1,N);                                      % 国家n进口j部门产品的总花销
PIj_m_ni=Xj_m_ni./Xj_m_n;                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
PIj_m_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品

Xj_f_n = Xj_f_n'*ones(1,N);
PIj_f_ni=Xj_f_ni./Xj_f_n;
PIj_f_ni(isnan(PIj_f_ni)) = 0;
PIj_f_ni((J-1)*N + 1:J*N, :) = eye(N);

% Calculating superavits
Yj_ni=Yj_nip;                                            % 总收益FOB
Sn = sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),2) - ...
    sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),1)';    %for JIE 2019
Sn = Sn.*0;                                                % 保证surplus等于0
INVj_ni = Yj_ni - Xj_f_ni./tau - Xj_m_ni./tau;
INVj_ni = INVj_ni.*0;

% Calculating Value Added 
wLj_n=GO.*B;                                           % 国家n部门j的劳动力附加值
wL_n=sum(wLj_n)';                                            % 国家n的劳动力附加值

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
% 这一步用来还原数据
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
