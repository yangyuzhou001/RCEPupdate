clear all

N = 65; J = 18;
load ..\data\X.mat X2015;
Z = X2015(1:J*N,1:J*N);
F = X2015(1:J*N,1 + J*N:(J+6)*N);
Zj_ni3D = sum(permute(reshape(Z,J,N,J,N),[2 4 1 3]),4);                     %[exporter importer supplier]
Fjk_ni = permute(reshape(F,J,N,6,N),[2 4 1 3]);
INVj_ni3D = Fjk_ni(:,:,:,5);
Fj_ni3D = sum(Fjk_ni(:,:,:,1:4),4) + Fjk_ni(:,:,:,6);
Y = Zj_ni3D + Fj_ni3D + INVj_ni3D;
% Y = Zj_ni3D + Fj_ni3D ;
Yj_ni = reshape(permute(Y,[2 3 1]),J*N,N);                                  %[supplier*importer exporter]
Zj_ni = reshape(permute(Zj_ni3D,[2 3 1]),J*N,N);
Fj_ni = reshape(permute(Fj_ni3D,[2 3 1]),J*N,N);
%plus ROW
tariff = xlsread('..\data\tariff.xlsx');
tau = reshape(tariff,J,N-1,N-1);                                            %[supplier exporter importer]
tau = reshape(tau,J*(N-1),N-1);                                             %[supplier*exporter importer]
tau = [tau,ones(J*(N-1),1)];                                                %importer + 1
tau = reshape(permute(reshape(tau,J,N-1,N),[1 3 2]),J*N,N-1);
tau = [tau,ones(J*N,1)];                                                    %[supplier*importer exporter+1]
tau = reshape(permute(reshape(tau,J,N,N),[2 1 3]),J*N,N);                   %[importer*supplier exporter]

Xj_ni = Yj_ni.*tau;
Xj_m_ni = Zj_ni.*tau;
Xj_f_ni = Fj_ni.*tau;

R = sum([Z,F],2);
GO = reshape(R,J,N);                                                        %[supplier exporter]
% test
% max(max(sum(permute(reshape(Yj_ni,N,J,N),[2 3 1]),3) - GO))

Zjk_ni = reshape(Z,J,N,J,N);
Zjk_n = sum(permute(Zjk_ni,[1 4 3 2]),4);
Zjk_n2D = reshape(Zjk_n,J*N,J);
Zj_n = sum(permute(Zjk_n,[2 3 1]),3);
ajk_ni = Z./(ones(N*J,1)*sum(Z,1));                                         %[exporter*supplier demander*importer]
% test the relation between ajk_ni and G
% reshape(sum(kron(reshape(permute(reshape(tau,N,J,N),[2 3 1]),J*N,N),ones(1,J)).*ajk_ni,2),N,J)';
% test = kron(reshape(permute(reshape(tau,N,J,N),[2 3 1]),J*N,N),ones(1,J)).*ajk_ni;
% test(isnan(test) == 1) = 0;
% test = reshape(sum(permute(reshape(test,J,N,J,N),[1 4 3 2]),4),J*N,J)./kron(reshape(sum(test,1),J,N)',ones(J,1));


G = Zjk_n2D./kron(Zj_n,ones(J,1));                                          %IO [nation*upstream downstream]
G(isnan(G)) = 0;
%check IO, Singapore does not have minnig goods export
%sum(permute(reshape(G,J,N,J), [2 3 1]),3)

B = 1 - sum(sum(permute((permute(Zjk_ni,[4 1 2 3]).*(repmat(reshape(tau,N,J,N),[1 1 1 J]))),[4 1 2 3]),4),3)./(GO + 0.00000001*(GO == 0));                                 %Value Added Share [sector nation]

% x = sum(permute(reshape(Yj_ni,N,J,N),[2 3 1]),3);
% GO = max(GO,x);

Xj_n = sum(Xj_ni,2);
%for JIE 2019
Xj_m_n = sum(Xj_m_ni,2);
Xj_f_n = sum(Xj_f_ni,2);
%test whether Xj_n has zero values
%min(Xj_n)
PIj_ni = Xj_ni./(Xj_n*ones(1,N));
%for JIE 2019
PIj_m_ni = Xj_m_ni./(Xj_m_n*ones(1,N));
PIj_f_ni = Xj_f_ni./(Xj_f_n*ones(1,N));
%test whether PIj_ni has NaN
%max(max(isnan(PIj_ni))) 
PIj_ni(1 + (J-1)*N :J*N, :) = eye(N);
%for JIE 2019
PIj_m_ni(1 + (J-1)*N :J*N, :) = eye(N);
PIj_f_ni(1 + (J-1)*N :J*N, :) = eye(N);

M = reshape(sum(Yj_ni,2),N,J)';
E = sum(permute(reshape(Yj_ni,N,J,N),[2 3 1]),3);
D_n=sum(E)'-sum(M)';                                                        %Surplus 
Sn = sum(sum(Zj_ni3D + Fj_ni3D,3),2) - sum(sum(Zj_ni3D + Fj_ni3D,3),1)';    %for JIE 2019
%Sn = sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),2) - sum(sum(permute(reshape((Xj_m_ni + Xj_f_ni)./tau,N,J,N),[3 1 2]),3),1)';
%sum(D_n)
%sum(Sn)


wLj_n=GO.*B;                                                                %国家n部门j的劳动力附加值
wL_n=sum(wLj_n)';                                                           %国家n的劳动力附加值

% I_n = sum(reshape(Xj_n,N,J) - reshape(sum((1 - kron(B',ones(J,1))).*G.*kron(E',ones(J,1)),2),J,N)',2);
R_n = sum(sum(permute(reshape((tau - 1).*Yj_ni,N,J,N),[1 3 2]),3),2);
I_n = R_n + wL_n - D_n; 
alpha = (reshape(Xj_n,N,J)' - reshape(sum((1 - kron(B',ones(J,1))).*G.*kron(E',ones(J,1)),2),J,N))./(ones(J,1)*I_n');
% for JIE2019
Rn = sum(reshape(Xj_m_n.*(1 - sum(PIj_m_ni./tau,2)) + Xj_f_n.*(1 - sum(PIj_f_ni./tau,2)),N,J),2);
In = Rn + wL_n - Sn - sum(sum(INVj_ni3D,3),2);                                
alphas = (reshape(sum(Xj_f_ni,2),N,J)./(In*ones(1,J)))';                   % for JIE2019

tau_hat = tau./tau;
taup = tau;
theta = [-xlsread('..\data\theta-mu.xlsx','A1:A17');5];
maxit = 1E+10; tol = 1E-07; vfactor = -0.1;

save ..\data\basic.mat tau_hat taup alpha alphas theta B G PIj_ni PIj_m_ni ...
    PIj_f_ni J N maxit tol wL_n D_n Sn vfactor R_n Rn In INVj_ni3D Yj_ni Xj_f_ni;

