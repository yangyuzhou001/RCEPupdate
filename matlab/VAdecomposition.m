function [va1, va2, va3, va4, va5, va6, va7, va8, va9, Ej_ni] = VAdecomposition(PIj_m_ni, Xj_f_ni, Yj_ni, tau_m, tau_f, B, G, J, N)
 %     ajk_ni = Z./(ones(N*J,1)*sum(Z,1));                                     %[exporter*supplier demander*importer]
    ajk_ni = kron(reshape(permute(reshape(PIj_m_ni./tau_m,N,J,N),[2 3 1]),J*N,N),ones(1,J)).*...
        kron(ones(N*J,1),reshape((1-B),N*J,1)').*...
        kron(ones(N,1),reshape(permute(reshape(G,J,N,J),[1 3 2]),J,J*N));   %[exporter*supplier demander*importer]
    bjk_ni = (eye(N*J) - ajk_ni)^(-1);
    C = reshape(permute(reshape(Xj_f_ni./tau_f,N,J,N),[2 3 1]),J*N,N);      %[exporter*supplier importer]
    cj_ni = permute(reshape(C,J,N,N),[2 3 1]);
    ajk_ni4D = permute(reshape(ajk_ni,J,N,J,N),[2 4 1 3]);
    bjk_ii = (eye(J*N) - ajk_ni.*kron(eye(N),ones(J,J)))^(-1);
    bjk_ii4D = permute(reshape(bjk_ii,J,N,J,N),[2 4 1 3]);
    bjk_ni4D = permute(reshape(bjk_ni,J,N,J,N),[2 4 1 3]);                  %[exporter(i) importer(n) supplier(j) demander(k)]
%     A4D = reshape(ajk_ni,J,N,J,N);                                          %[supplier exporter demander importer]
%     B4D = reshape(bjk_ni,J,N,J,N);                                          
%     VAn = reshape(B,J*N,1)'*bjk_ni*C;                                       %test VAnjk_hi
%     VAnjk_hi = repmat((reshape(B,J*N,1)*ones(1,J*N)).*bjk_ni,[1 1 N]).*...
%         permute(repmat(reshape(C,J*N,N,1),[1 1 J*N]),[3 1 2]);              %[exporter*supplier demander*importer destination]
%     VAnk_i = sum(sum(permute(reshape(VAnjk_hi,J,N,J,N,N),[2 5 1 4 3]),5),4);
%     VAX = sum(sum(VAnk_i,3).*(1 - eye(N)),2);
    Yj_n = reshape(sum(permute(reshape(Yj_ni,N,J,N),[2 3 1]),3),J*N,1);
%     E = sum(sum(permute(reshape(C,J,N,N),[2 3 1]) + ...
%         sum(permute(reshape(ajk_ni.*kron(Yj_n',ones(J*N,1)),J,N,J,N),[2 4 3 1]),4),3).*...
%         (1 - eye(N)),2);                                                    %wrong process, right result
    Eik_n = (sum(permute(reshape(ajk_ni.*kron(Yj_n',ones(J*N,1)),J*N,J,N),[1 3 2]),3) + C).*...
        (1 - kron(eye(N),ones(J,1)));                                       %[exporter*supplier importer]
    Eik = reshape(sum(Eik_n,2),J,N);                                        %[supplier exporter]
    Ej_ni = reshape(permute(reshape(Eik_n,J,N,N),[3 1 2]),J*N,N);           %[supplier*importer exporter]
    %test E - sum(Eik,1)'; 
    
%     RDV_ih = sum(reshape(sum(sum(permute(reshape(VAnjk_hi,J,N,J,N,N),[5 4 2 3 1]),5),4),N*N,N).*kron(ones(N,1),eye(N)),2);
%     RDV = sum(reshape(RDV_ih,N,N).*(1 - eye(N)),2);
%Based on JIE 2019
%     VA1 = sum(reshape(sum((bjk_ni.*kron(eye(N),ones(J,J)))*...              %Bii
%         (C.*(1 - kron(eye(N),ones(J,1)))),2),J,N).*...                      %Cin
%         B,1)';
%     va1 = repmat(reshape(B,J*N,1,1),[1 J*N N]).*...                         %beta
%         repmat(bjk_ni.*kron(eye(N),ones(J,J)),[1 1 N]).*...                 %Bii
%         repmat(reshape((C.*(1 - kron(eye(N),ones(J,1)))),1,N*J,N),[J*N 1 1]); %Cin [(i,k)->(i,j)->(n)]
%     VA1 = sum(reshape(sum(sum(va1,3),2),J,N))';

    va1j_ni3D = zeros(N,N,J);                                               %[exporter(i) importer(n) supplier(j)]
    for i = 1:N
        for n = 1:N
            for j = 1:J
                va1j_ni3D(i,n,j) = sum(B(:,i).*reshape(bjk_ni4D(i,i,:,j),J,1).*cj_ni(i,n,j));
                va1j_ni3D(i,i,j) = 0;
            end
        end
    end
    va1 = reshape(permute(va1j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA1./sum(va1)'-1))
    
%     VA2 = sum(reshape(sum((bjk_ni.*(1 - kron(eye(N),ones(J,J))))*...
%         (C.*kron(eye(N),ones(J,1))),2),J,N).*B,1)';
%     va2 = repmat(reshape(B,J*N,1,1),[1 J*N N]).*...                         
%         repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...                 
%         repmat(reshape((C.*kron(eye(N),ones(J,1))),1,N*J,N),[J*N 1 1]);     %[(i,k)->(n,j)->(n)]
%     VA2 = sum(reshape(sum(sum(va2,3),2),J,N))';
%     
    va2j_ni3D = zeros(N,N,J);
    for i = 1:N
        for n = 1:N
            for j = 1:J
                va2j_ni3D(i,n,j) = sum(B(:,i).*reshape(bjk_ni4D(i,n,:,j),J,1).*cj_ni(n,n,j));
                va2j_ni3D(i,i,j) = 0;
            end
        end
    end
    va2 = reshape(permute(va2j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA2./sum(va2)'-1))
    
%     VA3 = sum(reshape(sum(((bjk_ni.*(1 - kron(eye(N),ones(J,J))))*...
%         (C.*(1 - kron(eye(N),ones(J,1))))).*...
%         (1 - kron(eye(N),ones(J,1))),2),J,N).*B,1)';  
%     va3 = repmat(reshape(B,J*N,1),[1 J*N N]).*...                           %beta
%         (repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...          %Bin
%         repmat(reshape(C.*(1 - kron(eye(N),ones(J,1))),1,N*J,N),[J*N 1 1])).*...    %Cnm
%         repmat(reshape(1 - kron(eye(N),ones(J,1)),J*N,1,N),[1 J*N 1]);      %[(i,k)->(n,j)->(m)]
%     VA3 = sum(reshape(sum(sum(va3,3),2),J,N))';
%   
    va3kj_mni5D = zeros(N,N,N,J,J);                                         %[exporter(i) intermediate(n) importer(m) upstream(j) downstream(k)]
    for i = 1:N
        for n = 1:N
            for m = 1:N
                for j = 1:J
                    for k = 1:J
                        va3kj_mni5D(i,n,m,j,k) = B(j,i)*bjk_ni4D(i,n,j,k)*cj_ni(n,m,k);
                        va3kj_mni5D(i,n,n,j,k) = 0;
                        va3kj_mni5D(i,n,i,j,k) = 0;
                        va3kj_mni5D(i,i,m,j,k) = 0;
                    end
                end
            end
        end
    end
    va3j_ni3D = sum(sum(permute(va3kj_mni5D,[1 2 4 3 5]),5),4);
    va3 = reshape(permute(va3j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA3./sum(va3)'-1))
    
%     VAX = VA1 + VA2 + VA3;
%     VA4 = sum(reshape(sum((bjk_ni.*(1 - kron(eye(N),ones(J,J))))*...
%         (C.*(1 - kron(eye(N),ones(J,1)))).*...
%         kron(eye(N),ones(J,1)),2),J,N).*B,1)';
%     va4 = repmat(reshape(B,J*N,1),[1 J*N N]).*...
%         repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...
%         repmat(reshape(C.*(1 - kron(eye(N),ones(J,1))),1,N*J,N),[J*N 1 1]).*...
%         repmat(reshape(kron(eye(N),ones(J,1)),J*N,1,N),[1 J*N 1]);          %[(i,k)->(n,j)->(i)]
%     VA4 = sum(reshape(sum(sum(va4,3),2),J,N))';
    va4j_ni3D = zeros(N,N,J);
    for i = 1:N
        for n = 1:N
            for j = 1:J
                va4j_ni3D(i,n,j) = sum(B(:,i).*reshape(bjk_ni4D(i,n,:,j),J,1).*cj_ni(n,i,j));
                va4j_ni3D(i,i,j) = 0;
            end
        end
    end
    va4 = reshape(permute(va4j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA4./sum(va4)'-1))
    
%     VA5 = sum(reshape(sum((((bjk_ni.*(1 - kron(eye(N),ones(J,J))))*...      %Bin
%         (ajk_ni.*(1 - kron(eye(N),ones(J,J))))).*kron(eye(N),ones(J,J)))*...%Ani
%         ((eye(N*J) - (ajk_ni.*kron(eye(N),ones(J,J))))^(-1))*...            %(I - Aii)^-1
%         (C.*kron(eye(N),ones(J,1))),2),J,N).*B,1)';                         %Cii
%     va5 = repmat(reshape(B,J*N,1),[1 J*N N]).*...
%         repmat((bjk_ni.*(1 - kron(eye(N),ones(J,J)))),[1 1 N]).*...
%         repmat(reshape((ajk_ni.*(1 - kron(eye(N),ones(J,J))))*...
%         ((eye(N*J) - (ajk_ni.*kron(eye(N),ones(J,J))))^(-1))*...
%         (C.*kron(eye(N),ones(J,1))),1,J*N,N),[J*N 1 1]).*...
%         repmat(reshape(kron(eye(N),ones(J,1)),J*N,1,N),[1 J*N 1]);          %[(i,k)->(n,j)->(i,s)->(i)]
%     VA5 = sum(reshape(sum(sum(va5,3),2),J,N))';
    va5j_ni3D = zeros(N,N,J);
    for i = 1:N
        for n = 1:N
            x = reshape(ajk_ni4D(n,i,:,:),J,J)*reshape(bjk_ii4D(i,i,:,:),J,J)*reshape(cj_ni(i,i,:),J,1);
            for j = 1:J
                va5j_ni3D(i,n,j) = sum(B(:,i).*reshape(bjk_ni4D(i,n,:,j),J,1).*x(j,1));
                va5j_ni3D(i,i,j) = 0;
            end
        end 
    end
    va5 = reshape(permute(va5j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA5./sum(va5)'-1))
    
    
    
%JIE 2019, but in Calculating Trade in Value Added, DVA = VAX + RDV = VA4 + VA5 + VA8
                                                 
%     VA6 = sum(reshape(sum((((reshape(B,J*N,1)')*...                         %beta_m
%         (bjk_ni.*(1 - kron(eye(N),ones(J,J)))))'*ones(1,N)).*...            %Bmi
%         (C.*(1 - kron(eye(N),ones(J,1)))),2),J,N),1)';                      %Cin
%     va6 = repmat(reshape(B,J*N,1),[1 J*N N]).*...
%         repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...
%         repmat(reshape(C.*(1 - kron(eye(N),ones(J,1))),1,J*N,N),[J*N 1 1]); %[(m,j)->(i,k)->(n)]
%     VA6 = sum(reshape(sum(sum(va6,3)',2),J,N))';
    va6j_ni5D = zeros(N,N,J,N,J);
    for i = 1:N
        for n = 1:N
            for m = 1:N
                for k = 1:J
                    for j = 1:J
                        va6j_ni5D(i,n,j,m,k) = B(k,m)*bjk_ni4D(m,i,k,j)*cj_ni(i,n,j);
                        va6j_ni5D(i,n,j,i,k) = 0;
                        va6j_ni5D(i,i,j,m,k) = 0;
                    end
                end
            end
        end
    end
    va6j_ni3D = sum(sum(va6j_ni5D,5),4);
    va6 = reshape(permute(va6j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA6./sum(va6)' - 1))
    
%     VA7 = sum(reshape(sum(((reshape(B,J*N,1)')*...                          %beta_m
%         (bjk_ni.*(1 - kron(eye(N),ones(J,J)))))'*ones(1,N).*...             %Bmi
%         ((ajk_ni.*(1 - kron(eye(N),ones(J,J))))*...                         %Ain
%         (eye(N*J) - (ajk_ni.*(kron(eye(N),ones(J,J)))))^(-1)*...            %(I - Aii)^-1
%         (C.*kron(eye(N),ones(J,1)))),2),J,N),1)';                           %Cnn
%     va7 = repmat(reshape(B,J*N,1,1),[1 J*N N]).*...
%         repmat(bjk_ni.*(1-kron(eye(N),ones(J,J))),[1 1 N]).*...
%         repmat(reshape((ajk_ni.*(1 - kron(eye(N),ones(J,J))))*...
%         ((eye(J*N) - (ajk_ni.*(kron(eye(N),ones(J,J)))))^(-1))*...
%         (C.*(kron(eye(N),ones(J,1)))),1,J*N,N),[J*N 1 1]);                  %[(m,j)->(i,k)->(n,s)->(n)]
%     VA7 = sum(reshape(sum(sum(va7,3))',J,N))';
    va7j_ni5D = zeros(N,N,J,N,J);
    for i = 1:N
        for n = 1:N
            x = reshape(ajk_ni4D(i,n,:,:),J,J)*reshape(bjk_ii4D(n,n,:,:),J,J)*reshape(cj_ni(n,n,:),J,1);
            for m = 1:N
                for j = 1:J
                    for k = 1:J
                        va7j_ni5D(i,n,j,m,k) = B(k,m)*bjk_ni4D(m,i,k,j)*x(j,1);
                        va7j_ni5D(i,n,j,i,k) = 0;
                        va7j_ni5D(i,i,j,m,k) = 0;
                    end
                end
            end
        end
    end
    va7j_ni3D = sum(sum(va7j_ni5D,5),4);
    va7 = reshape(permute(va7j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA7./sum(va7)'-1))

%     VA8 = sum(reshape((((bjk_ni.*(1 - kron(eye(N),ones(J,J))))*...            %Bin
%         (ajk_ni.*(1 - kron(eye(N),ones(J,J))))).*kron(eye(N),ones(J,J)))*...                          %Ani
%         (eye(J*N) - (ajk_ni.*kron(eye(N),ones(J,J))))^(-1)*...              %(I - Aii)^-1
%         reshape(Eik,J*N,1),J,N).*B,1)';                                     %beta_i e_i
%     va8 = repmat(reshape(B,J*N,1,1),[1 J*N N]).*...
%         repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...
%         repmat(sum(permute(reshape((ajk_ni.*(1 - kron(eye(N),ones(J,J)))).*...
%         (ones(J*N,1)*(((eye(J*N) - (ajk_ni.*kron(eye(N),ones(J,J))))^(-1))*...
%         reshape(Eik,J*N,1))'),1,J*N,J,N),[1 2 4 3]),4),[J*N 1 1]);          %[(i,k)->(n,j)->(i,k)->(i)]
%     VA8 = sum(reshape(sum(sum(va8,3),2),J,N))';
    va8j_ni3D = zeros(N,N,J);
    for i = 1:N
        for n = 1:N
            x = reshape(ajk_ni4D(n,i,:,:),J,J)*reshape(bjk_ii4D(i,i,:,:),J,J)*Eik(:,i);
            for j = 1:J
                va8j_ni3D(i,n,j) = sum(B(:,i).*reshape(bjk_ni4D(i,n,:,j),J,1).*x(j,1));
                va8j_ni3D(i,i,j) = 0;
            end
        end 
    end
    va8 = reshape(permute(va8j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA8./sum(va8)'-1))
    
%     VA9 = sum(reshape(((reshape(B,J*N,1)')*...                              %beta_m
%         (bjk_ni.*(1 - kron(eye(N),ones(J,J)))))'.*...                       %Bmi
%         (ajk_ni.*(1 - kron(eye(N),ones(J,J))))*...                          %Ain
%         (eye(J*N) - ajk_ni.*(kron(eye(N),ones(J,J))))^(-1)*...              %(I - Ann)^-1
%         reshape(Eik,J*N,1),J,N),1)';                                        %e_n        
%     va9 = repmat(reshape(B,J*N,1,1),[1 J*N N]).*...
%         repmat(bjk_ni.*(1 - kron(eye(N),ones(J,J))),[1 1 N]).*...
%         repmat(sum(permute(reshape((ajk_ni.*(1 - kron(eye(N),ones(J,J)))).*...
%         (ones(J*N,1)*(((eye(J*N) - ajk_ni.*(kron(eye(N),ones(J,J))))^(-1))*...
%         reshape(Eik,J*N,1))'),1,J*N,J,N),[1 2 4 3]),4),[J*N 1 1]);          %[(m,j)->(i,k)->(n,s)->(n)]
%     VA9 = sum(reshape(sum(sum(va9,3)),J,N))';
    
    va9j_ni5D = zeros(N,N,J,N,J);
    for i = 1:N
        for n = 1:N
            x = reshape(ajk_ni4D(i,n,:,:),J,J)*reshape(bjk_ii4D(n,n,:,:),J,J)*Eik(:,n);
            for m = 1:N
                for j = 1:J
                    for k = 1:J
                        va9j_ni5D(i,n,j,m,k) = B(k,m)*bjk_ni4D(m,i,k,j)*x(j,1);
                        va9j_ni5D(i,n,j,i,k) = 0;
                        va9j_ni5D(i,i,j,m,k) = 0;
                    end
                end
            end
        end
    end
    va9j_ni3D = sum(sum(va9j_ni5D,5),4);
    va9 = reshape(permute(va9j_ni3D,[2 3 1]),J*N,N);
%     max(abs(VA9./sum(va9)'-1))
end
    