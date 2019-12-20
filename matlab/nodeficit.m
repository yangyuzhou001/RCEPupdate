clear all
%%
%�����趨
% vfactor  = -0.1;        
% tol      = 1E-07;       %��Сֵ
% maxit    = 1E+10;       %���ֵ

%Inputs

% Loading trade flows

load ..\data\basic.mat

tau = taup;

% Parameters

%% Share of value added ʹ��GOVA_44_12_2002.do�ļ����ԭʼ����
%ȱ��ROW�����ݣ������趨Ϊ�������ݵ�ƽ��ֵ
load ..\data\GOp.mat;    GO = GOp;

load ..\data\alphas.mat

% calculating expenditures
load ..\data\Xj_nip.mat
Xj_ni = Xj_nip;                                 % ��1��31*31�����ǵ�1�������й���n���й���i���ڵĿ�֧

%3ά����

% Calculating X0 Expenditure
Xj_n=sum(Xj_ni');                                            % ��1��31���ǽ��ڵ�1�ֲ�Ʒ��31�����ҵ��ܽ��ڿ�֧

% Calculating Expenditure shares
Xj_n = Xj_n'*ones(1,N);                                      % ����n����j���Ų�Ʒ���ܻ���
PIj_ni=Xj_ni./Xj_n;                                          % ����n�ӹ���i����j���Ų�Ʒռ�ܽ��ڵķݶ�
PIj_ni(isnan(PIj_ni)) = 0;                                   %�ǳ���Ҫ��һ����������Ϊ��Щ���Ҷ���Щ���Ų�Ʒ���ܲ����ڳ��ڣ���������ά��
                                                             %����ʿ��ʯ�Ͳ�Ʒ�Ͳ����ڳ��ڣ������޷�������������Ҫ��Xj_n��ó�׼�ֵΪ0�����
                                                             %�ų���
PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %���ڷ���ҵ���źϲ�̫�࣬���ܻ���ֲ���Ͷ������仯�������ȫ����Ϊ����ó��Ʒ
% Calculating superavits
Yj_ni=Xj_ni./tau;                                            % ������FOB
for j      = 1:1:J
    % Imports
    M(j,:) = (sum(Yj_ni(1+N*(j-1):N*j,:)'))';                % ���ڹ��ҽ��ڲ��ŵ��ܽ���
    for n  = 1:1:N
    % Exports
    E(j,n) = sum(Yj_ni(1+N*(j-1):N*j,n))';                   % ���ڹ��ҳ��ڲ��ŵ��ܳ���
    end
end;

D_n=sum(E)'-sum(M)';                                         % ��������D_n = sum(M)' - sum(E)';
D_n = D_n.*0;                                                % ��֤deficit����0

% Calculating Value Added 
wLj_n=GO.*B;                                           % ����n����j���Ͷ�������ֵ
wL_n=sum(wLj_n)';                                            % ����n���Ͷ�������ֵ

save ..\data\nodeficit.mat tau_hat taup ...
    alpha theta B G PIj_ni J N maxit tol wL_n D_n vfactor
%%

clear
load ..\data\nodeficit.mat
[wf0_noD pf0_noD Xj_np_noD PIj_nip_noD Sn_noD c_noD wf_noD e] = main(tau_hat,taup,...
    alpha,theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);

% ��һ��������ԭ����
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
