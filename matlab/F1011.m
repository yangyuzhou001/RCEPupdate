function [c,pf0,pfw]  = F1011(wf0,tau_hat,PIj_ni,theta,VAShare,IO,J,N,maxit,tol)
    pf0 = ones(J, N);
    it = 1;
    pfmax = 1;
    c = zeros(J,N);
    while (it <= maxit) && (pfmax > tol)
        lw = log(wf0);
        lp = log(pf0);
        logc = VAShare.*kron(ones(J,1),lw') + ...
            sum(permute(reshape((kron((1-VAShare)',ones(J,1)).*IO).*kron(reshape(lp,J*N,1),ones(1,J)),J,N,J),[3 2 1]),3);
%         for i = 1:N                                         % equation 10
%             logc(:,i) = VAShare(:,i)*lw(i) + ...            %可用矩阵方法做，也不直观，但速度可以增加
%                 (1-VAShare(:,i)).*(IO(1+(i-1)*J:J*i,:)'*lp(:,i));
%         end
        c = exp(logc);
        % equation 11
        PI_tauj_ni = PIj_ni.*( tau_hat.^(-(kron(theta,ones(N,N)))));  % PIj_ni*KAPPAj_ni^(-theta)
        x = sum(reshape(PI_tauj_ni.* kron(c.^(-theta*ones(1,N)),ones(N,1)),N,J,N),3)';
        x(~x) = 1;
        pf1 = (x).^((-1./theta)*ones(1,N));
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
        pfmax = max(max(abs(pf1 - pf0)));                       % 
        pf0 = pf1;
        pfw = pf1;
        it = it + 1;
    end
end