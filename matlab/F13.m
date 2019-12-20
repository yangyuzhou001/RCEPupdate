function Xj_np    = F13(wf0,alphas,VAShare,IO,PIj_nip,taup,wL_n,D_n,J,N)

    alphasD         = reshape(alphas,J*N,1);
    PIj_niptilde    = PIj_nip./(taup);
    Fj_np           = 1 - sum(PIj_niptilde,2);
    Ftilde          = reshape(Fj_np,N,J);
    gammakj_n       = kron((1 - VAShare)',ones(J,1)).* IO;
    Delta_what      = alphasD.*kron((wf0.* wL_n - D_n),ones(J,1));
    F = zeros(J*N,J*N);
    for n = 1:N
        F(1 + (n - 1)*J:n*J,1 + (n - 1)*J:n*J) = ...
            alphasD(1 + (n - 1)*J:n*J,:)*Ftilde(n,:);
    end
    PIj_niptilde = reshape(permute(reshape(PIj_niptilde,N,J,N),[2 1 3]),J*N,N);
    Htilde = kron(ones(1,N),gammakj_n).* kron((PIj_niptilde)',ones(J,1));
    Omega_what = eye(J*N) - F - Htilde;
    Xj_np = (Omega_what^(-1))*Delta_what;
    

%简单迭代法实验失败，出现无穷值溢出
%     Xj_np = zeros(J,N); %reshape(Xj_n(:,1),J,N);
%     Xj_npmax = 1;
%     gammakj_n = (reshape((1 - VAShare),J*N,1)*ones(1,J)).* IO;
%     while Xj_npmax > tol
%         I_np = wf0.*wL_n + ...
%             sum(reshape(sum(((taup - 1).*PIj_nip./taup).*(reshape(Xj_np',N*J,1)*ones(1,N)),2),N,J),2) + D_n;
%         Ej_np = sum(permute(reshape(PIj_nip./taup.*...
%             (reshape(Xj_np',N*J,1)*ones(1,N)),N,J,N),[2 3 1]),3);
%         for n = 1:N
%             for j = 1:J
%                 Xj_np1(j,n) = gammakj_n(j + (n - 1)*J,:)*Ej_np(:,n) + ...
%                     alphas(j,n)*I_np(n);
%             end
%         end
%         Xj_npmax = sum(sum(abs(Xj_np - Xj_np1),2),1);        
%         Xj_np = Xj_np1;
%     end
end