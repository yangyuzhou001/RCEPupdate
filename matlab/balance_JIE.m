function [wf0, wfmax] = balance_JIE(wf0, wL_n, Xj_m_np, Xj_f_np, tau_mp, tau_fp, PIj_m_nip, PIj_f_nip, Sn, vfactor, J, N)
    RHS = sum(sum(permute(reshape(PIj_m_nip.*(Xj_m_np*ones(1,N))./tau_mp + PIj_f_nip.*(Xj_f_np*ones(1,N))./tau_fp,N,J,N),[3 2 1]),3),2);
    Ftilde_mp = sum(PIj_m_nip./tau_mp,2);                    % differ from expenditure.m
    Ftilde_fp = sum(PIj_f_nip./tau_fp,2);
    LHS = sum(reshape(Ftilde_mp.*Xj_m_np + Ftilde_fp.*Xj_f_np,N,J),2) + Sn;
    ZW = RHS - LHS;
    wf1 = wf0.*(1 - vfactor*(ZW./wL_n)./wf0);
    wfmax = sum(abs(ZW));
%     disp(num2str(wfmax));
    wf0 = wf1;
end
