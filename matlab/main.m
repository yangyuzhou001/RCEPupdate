function [wf0,pf0,Xj_np,PIj_nip,Sn,c,wf,e, PIj_nip_history,c_history,pfmat] = main(tau_hat,taup,alpha,theta,B,G,PIj_ni,J,N,maxit,tol,wL_n,D_n,vfactor)
%      wL_n = wL_n./100000; D_n = D_n./100000;
    wf0 = ones(N,1);
    e = 1; wfmax = 1;
    wf=wf0;
    PIj_nip_history = PIj_ni;
    c_history = [];
    pfmat = [];
    while (e < maxit) && (wfmax > tol)
        [c,pf0,pfw]  = F1011(wf0,tau_hat,PIj_ni,theta,B,G,J,N,maxit,tol);
%       用于跟踪消费品的变动轨迹
%       c_history = [c_history, c];
        PIj_nip  = F12(c,pfw,PIj_ni,tau_hat,theta,J,N);
        Xj_np    = F13(wf0,alpha,B,G,PIj_nip,taup,wL_n,D_n,J,N);
        Xj_np2D = permute(reshape(Xj_np,J,N),[2 1]);
        LHS = D_n + ...
            sum(Xj_np2D.*reshape(sum(PIj_nip./taup,2),N,J),2);
        PIj_inp_taup_Xj_i = (PIj_nip./taup).*...
            (reshape(Xj_np2D,J*N,1)*ones(1,N));
        RHS = sum(sum(permute(reshape(PIj_inp_taup_Xj_i,N,J,N),[3 2 1]),3),2);
        Sn = LHS - RHS;
        wf1 = wf0.*(1 + vfactor*(Sn./wL_n)./wf0);
%         wL_n1 = sum(sum(permute(reshape((PIj_nip./taup).*(reshape(reshape(Xj_np,J,N)',J*N,1)*ones(1,N)),N,J,N),[3 2 1]),3)'.*B)';
%         wf1 = wL_n1./wL_n;
        e = e + 1;
        wfmax = sum(abs(Sn));         %wf0 - wf1
%         wfmax = sum(abs(wf0 - wf1));
        wf0 = wf1;
%         wL_n = wL_n1;
%        wf = [wf,wf0];
%       用于跟踪贸易份额的变动轨迹        
%       PIj_nip_history = [PIj_nip_history,PIj_nip];                     
%        pfmat = [pfmat,pf0];
    end
end
