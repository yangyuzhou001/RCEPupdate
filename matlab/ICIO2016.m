clear all
for t = 1995:1:2011
    N = 64; J = 34;
    direction = ['..\originaldata\SNA93\ICIO2016_',num2str(t),'\ICIO2016_',num2str(t),'.csv'];
    DATA = dlmread(direction,',','B2..DCR2417');
    DATA(715:748,:) = DATA(2177:2210,:) + DATA(2211:2244,:) + DATA(2245:2278,:); %MEX = MX1 + MX2 + MX3
    DATA(:,715:748) = DATA(:,2177:2210) + DATA(:,2211:2244) + DATA(:,2245:2278);
    DATA(1327:1360,:) = DATA(2279:2312,:) + DATA(2313:2346,:) + ...
        DATA(2347:2380,:) + DATA(2381:2414,:);                                 %CHN = CN1 + CN2 + CN3 + CN4
    DATA(:,1327:1360) = DATA(:,2279:2312) + DATA(:,2313:2346) + ...
        DATA(:,2347:2380) + DATA(:,2381:2414);                                 %CHN = CN1 + CN2 + CN3 + CN4
    Zinit = DATA(1:N*J,1:N*J);                                                 %N*J = 
    X = [DATA(1:N*J,1:N*J),DATA(1:N*J,N*J+1:N*J + 6*N + 1)];
    Rinit = sum(X,2);

    FIN = X(1:N*J,1 + N*J:N*(J + 6));                                           %without Deficit
    FINsum = sum(FIN,2);
    F = FIN.*(FIN > 0);                                                         %[exporter*supplier ]
    Fsum = sum(F,2);

    A = Zinit/diag(Rinit + .00001.*(Rinit<=0.00001));
    R = (eye(N*J) - A)\Fsum;
    Z = A  * diag(R);


    AggS = xlsread('..\data\AggS2016.xlsx'); J = size(AggS,1);
    CC = kron(eye(N),AggS);
    Z = CC * Z * (CC');
    F = CC * F;
    X = [Z, F];

    Zijsk4D = permute(reshape(Z, J, N, J, N),[2 4 1 3]);                        %[exporter importer supplier demander]
    Zijs3D = sum(Zijsk4D,4);                                                    %[exporter importer supplier]
    Fijsk4D = permute(reshape(F, J, N, N, 6),[2 3 1 4]);                        %[exporter importer supplier demander]
    Fijs3D = sum(Fijsk4D,4);
    Yijs3D = Zijs3D + Fijs3D;                                                   %[exporter importer supplier]
    Yj_ni = reshape(permute(Yijs3D,[2 3 1]),J*N,N);                             %[supplier*importer exporter]
    eval(['X',num2str(t),' = X;']);

    Yijs = reshape(Yijs3D,N*N*J,1);                                             %[supplier*importer*exporter]
    Zijs = reshape(Zijs3D,N*N*J,1);
    Fijs = reshape(sum(Fijsk4D(:,:,:,1:4),4) + sum(Fijsk4D(:,:,:,6),4),N*N*J,1);
    
    filename1 = ['../data/ICIO2016_',num2str(t),'.xlsx'];
    xlswrite(filename1,Yijs);
    filename2 = ['../data/ICIO2016_',num2str(t),'ZF.xlsx'];
    xlswrite(filename2,[Zijs,Fijs]);
    
%     if t == 2005
%         eval(['save ../data/X.mat X',num2str(t),';']);
%     else
%         eval(['save ../data/X.mat X',num2str(t),' -append;']);
%     end

end
