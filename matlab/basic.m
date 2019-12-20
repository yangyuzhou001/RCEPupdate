%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Main Program Counterfactuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load ..\data\basic.mat
% load alpha.mat
% theta = 1./(1./theta);

[wf0,pf0,Xj_np,PIj_nip,Sn,c,wf,e,PIj_nip_history,c_history,pfmat] = main(tau_hat,taup,alpha,...
    theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor);
%这一步用于还原贸易流数据
% Xj_np = Xj_np.*100000;
save ..\data\main.mat wf0 pf0 Xj_np PIj_nip Sn c taup


%%
clear all
J = 18;
N = 65;
load ..\data\main.mat
load ..\data\basic.mat
Xj_np2D = reshape(Xj_np,J,N);
Yj_nip = ((reshape(Xj_np2D',J*N,1)*ones(1,N))./taup).*PIj_nip;
Xj_nip = Yj_nip.*taup;


for j=1:J
    GOp(j,:) = sum(Yj_nip(1+(j-1)*N : j*N,:));
end
% 
% for j=1:J
%     for n = 1:N
%         Xj_nip(n+(j-1)*N,n) = 0;
%     end   
% end

RealWage = wf0./(prod(pf0.^alpha,1))';

save('..\data\Xj_nip', 'Xj_nip','PIj_nip','Yj_nip')
save('..\data\alphas', 'alpha')
save('..\data\GOp', 'GOp')

