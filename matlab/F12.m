function PIj_nip  = F12(c,pfw,PIj_ni,tau_hat,theta,J,N)
    PIj_nip = PIj_ni.*((kron(c,ones(N,1)).* tau_hat)./(reshape(pfw',N*J,1)*ones(1,N))).^(-(kron(theta,ones(N,N))));
%     T = 1./theta;
%     for   j    = 1:1:J;
%         idx  = 1+(j-1)*N:1:N*j;
%         LT(idx,1) = ones(N,1)*T(j);
%     end
% 
%     for n=1:1:N
%         cp(:,n) = c(:,n).^( - 1./T );
%     end
% 
%     Din_om = PIj_ni.*( tau_hat.^(-1./(LT*ones(1,N))));
%   
%     for n = 1:1:N
%         idx = n:N:length(PIj_ni)-(N-n);
%         DD(idx,:) = Din_om(idx,:).*cp;
%     end
%  
%     phat = sum(DD')'.^-LT;
%  
%     for n = 1:1:N
%         PIj_nip(:,n) = DD(:,n).*(phat.^(1./LT));
%     end
end