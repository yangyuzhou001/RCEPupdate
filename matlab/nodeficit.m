clear all
%%
%参数设定
% vfactor  = -0.1;        
% tol      = 1E-07;       %最小值
% maxit    = 1E+10;       %最大值

%Inputs

% Loading trade flows

load ..\data\basic.mat

tau = taup;

% Parameters

%% Share of value added 使用GOVA_44_12_2002.do文件获得原始数据
%缺少ROW的数据，暂且设定为其他数据的平均值
load ..\data\GOp.mat;    GO = GOp;

load ..\data\alphas.mat

% calculating expenditures
load ..\data\Xj_nip.mat
Xj_ni = Xj_nip;                                 % 第1个31*31矩阵是第1个部门行国家n从列国家i进口的开支

%3维处理

% Calculating X0 Expenditure
Xj_n=sum(Xj_ni');                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
Xj_n = Xj_n'*ones(1,N);                                      % 国家n进口j部门产品的总花销
PIj_ni=Xj_ni./Xj_n;                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_ni(isnan(PIj_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% Calculating superavits
Yj_ni=Xj_ni./tau;                                            % 总收益FOB
for j      = 1:1:J
    % Imports
    M(j,:) = (sum(Yj_ni(1+N*(j-1):N*j,:)'))';                % 进口国家进口部门的总进口
    for n  = 1:1:N
    % Exports
    E(j,n) = sum(Yj_ni(1+N*(j-1):N*j,n))';                   % 出口国家出口部门的总出口
    end
end;

D_n=sum(E)'-sum(M)';                                         % 论文中是D_n = sum(M)' - sum(E)';
D_n = D_n.*0;                                                % 保证deficit等于0

% Calculating Value Added 
wLj_n=GO.*B;                                           % 国家n部门j的劳动力附加值
wL_n=sum(wLj_n)';                                            % 国家n的劳动力附加值

save ..\data\nodeficit.mat tau_hat taup ...
    alpha theta B G PIj_ni J N maxit tol wL_n D_n vfactor
%%

clear
load ..\data\nodeficit.mat
[wf0_noD pf0_noD Xj_np_noD PIj_nip_noD Sn_noD c_noD wf_noD e] = main(tau_hat,taup,...
    alpha,theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);

% 这一步用来还原数据
% Xj_np_noD = Xj_np_noD.* 100000;
Xj_np_noD_2D = reshape(Xj_np_noD,J,N);
Yj_nip_noD = ((reshape(Xj_np_noD_2D',J*N,1)*ones(1,N))./taup).*PIj_nip_noD;
Xj_nip_noD = Yj_nip_noD.*taup;


for j=1:J
    GOp_noD(j,:) = sum(Yj_nip_noD(1+(j-1)*N : j*N,:));
end
% 
% for j=1:J
%     for n = 1:N
%         Xj_nip_noD(n+(j-1)*N,n) = 0;
%     end   
% end

save('..\data\Xj_nip_nodeficit', 'Xj_nip_noD','PIj_nip_noD','Yj_nip_noD')
save('..\data\alphas_nodeficit', 'alpha')
save('..\data\GOp_nodeficit', 'GOp_noD')
