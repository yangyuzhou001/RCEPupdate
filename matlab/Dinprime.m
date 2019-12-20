function PIj_nip = Dinprime(c, p, kappa_hat, PIj_ni, theta, J, N)
    PIj_nip = PIj_ni.*((kron(c,ones(N,1)).* kappa_hat)./(reshape(p',N*J,1)*ones(1,N))).^(-(kron(theta,ones(N,N))));
end