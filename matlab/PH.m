function [c, pm, pf] = PH(wf0, B, G, PIj_m_ni, PIj_f_ni, kappa_m_hat, kappa_f_hat, theta, maxit, tol, J, N)
    pf = ones(J, N);
    pm = ones(J, N);
    it = 1;
    pmax = 1;
    c = zeros(J,N);
    while (it <= maxit) && (pmax > tol)
        lw = log(wf0);
        lpm = log(pm);
        logc = B.*kron(ones(J,1),lw') + ...
            sum(permute(reshape((kron((1-B)',ones(J,1)).*G).*kron(reshape(lpm,J*N,1),ones(1,J)),J,N,J),[3 2 1]),3);
%         for i = 1:N                                         % equation 10
%             logc(:,i) = VAShare(:,i)*lw(i) + ...            %可用矩阵方法做，也不直观，但速度可以增加
%                 (1-VAShare(:,i)).*(IO(1+(i-1)*J:J*i,:)'*lp(:,i));
%         end
        c = exp(logc);
        % equation 11
        PI_tauj_ni = PIj_m_ni.*( kappa_m_hat.^(-(kron(theta,ones(N,N)))));  % PIj_ni*KAPPAj_ni^(-theta)
        x = sum(reshape(PI_tauj_ni.* kron(c.^(-theta*ones(1,N)),ones(N,1)),N,J,N),3)';
        x(~x) = 1;
        pm1 = (x).^((-1./theta)*ones(1,N));
%         for j = 1:J
%             for n = 1:N
%                 pf1(j,n) = PI_tauj_ni(n + (j-1) * N , :)*(c(j,:).^(-theta(j)))';
%                 
%                 if pf1(j,n) == 0
%                     pf1(j,n) = 1;
%                  else
%                     pf1(j,n) = pf1(j,n)^(-1./(theta(j)));            % equation 11完成
%                 end
%             end
%         end
        pmax = max(max(abs(pm1 - pm)));                       % 
        pm = pm1;
        it = it + 1;
    end
    PI_tauj_ni = PIj_f_ni.*( kappa_f_hat.^(-(kron(theta,ones(N,N)))));  % PIj_ni*KAPPAj_ni^(-theta)
    x = sum(reshape(PI_tauj_ni.* kron(c.^(-theta*ones(1,N)),ones(N,1)),N,J,N),3)';
    x(~x) = 1;
    pf = (x).^((-1./theta)*ones(1,N));
end