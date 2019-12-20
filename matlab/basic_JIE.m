clear
load '..\data\basic.mat' alphas B G J maxit N PIj_f_ni PIj_m_ni Rn tau_hat taup theta tol wL_n Sn In vfactor INVj_ni3D;
kappa_m_hat = tau_hat;
kappa_f_hat = tau_hat;
tau_mp = taup;
tau_fp = taup;
INVj_ni = reshape(permute(INVj_ni3D,[2 3 1]),J*N,N);
[wf0,pm,pf,Xj_m_np,Xj_f_np,PIj_m_nip,PIj_f_nip,Sn,c] = ...
    main_JIE(kappa_m_hat, kappa_f_hat,tau_mp,tau_fp,alphas,theta,B,G,PIj_m_ni,PIj_f_ni,J,N,maxit,tol,wL_n,Sn,INVj_ni,vfactor);
save ..\data\main_JIE.mat wf0 pm pf Xj_m_np Xj_f_np PIj_m_nip PIj_f_nip Sn c tau_mp tau_fp;
% 
Xj_m_nip = (Xj_m_np*ones(1,N)).*PIj_m_nip;
Xj_f_nip = (Xj_f_np*ones(1,N)).*PIj_f_nip;
Yj_nip = ((Xj_m_np*ones(1,N))./tau_mp).*PIj_m_nip + ...
    ((Xj_f_np*ones(1,N))./tau_fp).*PIj_f_nip + INVj_ni;
% 
% for j=1:J
%     GOp(j,:) = sum(Yj_nip(1+(j-1)*N : j*N,:));
% end
GOp = sum(permute(reshape(Yj_nip,N,J,N),[2 3 1]),3);


RealWage = wf0./(prod(pf.^alphas,1))';

save('..\data\Xj_nip_JIE', 'Xj_f_nip','Xj_m_nip','Yj_nip')
save('..\data\GOp_JIE', 'GOp')