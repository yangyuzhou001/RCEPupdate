function[Welfare,ToT, VoT, ToT_ni,VoT_ni,ToTj_n,VoTj_n, ToTj_ni, VoTj_ni] = F16(Yj_ni,J,N,c,I_n,tau, taup, Xj_np_all, PIj_nip_all)
    Xj_np_all = reshape(permute(reshape(Xj_np_all,J,N),[2 1]),J*N,1);
    Yj_nip_all = (Xj_np_all*ones(1,N)).*PIj_nip_all./taup;
    Mj_ni = Yj_ni;
    for j = 1:J
        Ej_ni(1 + N*(j - 1):N*j, :) = Yj_ni(1 + N*(j - 1):N*j,:)';
    end
    logc = c - 1;
%     logMj_ni = Mj_ni - 1;
    ToTj_ni = Ej_ni.*(reshape(logc',N*J,1)*ones(1,N)) - ...
        Mj_ni.* kron(logc,ones(N,1));
    VoTj_ni = (tau - 1).*Mj_ni.*((Yj_nip_all./Mj_ni - 1) - ...
        kron(logc,ones(N,1)));
%     VoTj_ni = (tau - 1).*Mj_ni.*(logMj_ni - ...
%         kron(logc,ones(N,1)));
    ToT_ni = sum(permute(reshape(ToTj_ni,N,J,N),[1 3 2]),3);
    VoT_ni = nansum(permute(reshape(VoTj_ni,N,J,N),[1 3 2]),3);
    ToTj_n = sum(ToTj_ni,2);
    VoTj_n = nansum(VoTj_ni,2);
    ToT = sum(reshape(sum(ToTj_ni,2),N,J),2)./I_n;
    VoT = nansum(reshape(nansum(VoTj_ni,2),N,J),2)./I_n;
    Welfare = ToT + VoT;
end