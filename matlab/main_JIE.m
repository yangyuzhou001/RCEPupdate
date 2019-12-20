function [wf0,pm,pf,Xj_m_np,Xj_f_np,PIj_m_nip,PIj_f_nip,Sn,c] = ...
    main_JIE(kappa_m_hat, kappa_f_hat,tau_mp,tau_fp,alphas,theta,B,G,PIj_m_ni, PIj_f_ni,J,N,maxit,tol,wL_n,Sn,INVj_ni,vfactor)
    wf0 = ones(N,1);
    wfmax = 1;
    e = 1;
    while (e < maxit) && (wfmax > tol)
        [c, pm, pf] = PH(wf0, B, G, PIj_m_ni, PIj_f_ni, kappa_m_hat, kappa_f_hat, theta, maxit, tol, J, N); %[sector nation]
        PIj_m_nip = Dinprime(c, pm, kappa_m_hat, PIj_m_ni, theta, J, N);
        PIj_f_nip = Dinprime(c, pf, kappa_f_hat, PIj_f_ni, theta, J, N);           % [supplier*importer exporter]
        [Xj_m_np, Xj_f_np] = ...                                            % [supplier*importer]
            expenditure(B, G, PIj_m_nip, PIj_f_nip, tau_mp, tau_fp, alphas, wf0, wL_n, Sn, INVj_ni, J, N);
        [wf0, wfmax] = balance_JIE(wf0, wL_n, Xj_m_np, Xj_f_np, tau_mp, tau_fp, PIj_m_nip, PIj_f_nip, Sn, vfactor, J, N);
        e = e + 1;
    end
end
