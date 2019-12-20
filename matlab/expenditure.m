function [Xj_m_np, Xj_f_np] = expenditure(B, G, PIj_m_nip, PIj_f_nip, tau_mp, tau_fp, alphas, wf0, wL_n, Sn, INVj_ni, J, N)
    gamma = G.*kron((1 - B'),ones(J,1));
    Dintilde_m = reshape(permute(reshape(PIj_m_nip./tau_mp,N,J,N),[3 2 1]),N,J*N);
    Dintilde_f = reshape(permute(reshape(PIj_f_nip./tau_fp,N,J,N),[3 2 1]),N,J*N);
    Hm = kron(ones(1,N),gamma).*kron(Dintilde_m,ones(J,1));
    Hf = kron(ones(1,N),gamma).*kron(Dintilde_f,ones(J,1));
    Ftilde_m = reshape((1 - sum(PIj_m_nip./tau_mp,2))',N,J);
    Ftilde_f = reshape((1 - sum(PIj_f_nip./tau_fp,2))',N,J);
    Fm = zeros(J*N,J*N);
    Ff = Fm;
    for n = 1:N
        Fm(1 + (n - 1)*J: n*J, 1 + (n - 1)*J: n*J) = alphas(:,n)*Ftilde_m(n,:);
        Ff(1 + (n - 1)*J: n*J, 1 + (n - 1)*J: n*J) = alphas(:,n)*Ftilde_f(n,:);
    end
%     Fm = kron(alphas,Ftilde_m).*kron(eye(N),ones(J,J));
%     Ff = kron(alphas,Ftilde_f).*kron(eye(N),ones(J,J));
    Omega = eye(2*N*J) - [Hm, Hf; Fm, Ff];
    Invj_ni = reshape(INVj_ni,N,J,N);
    Invj_n = sum(Invj_ni,3);
    Inv_n = sum(Invj_n,2);
    Delta = [sum(gamma.*kron(Invj_n,ones(J,1)),2); reshape(alphas,J*N,1).*kron((wf0.*wL_n - Sn - Inv_n),ones(J,1))];
    X = Omega^(-1)*Delta;
    Xj_m_np = reshape(reshape(X(1:J*N,1),J,N)',J*N,1);
    Xj_f_np = reshape(reshape(X(1 + J*N:2*J*N,1),J,N)',J*N,1);
end
