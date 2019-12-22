clear all
for t = 2005:1:2015
    N = 65; J = 36;
    direction = ['../originaldata/SNA08/ICIO2018_',num2str(t),'/ICIO2018_',num2str(t),'.csv'];
    DATA = dlmread(direction,',','B2..DFP2552');
    DATA(793:828,:) = DATA(2341:2376,:) + DATA(2377:2412,:);
    DATA(1477:1512,:) = DATA(2413:2448,:) + DATA(2449:2484,:);
    DATA(:,793:828) = DATA(:,2341:2376) + DATA(:,2377:2412);
    DATA(:,1477:1512) = DATA(:,2413:2448) + DATA(:,2449:2484);
    Zinit = DATA(1:2340,1:2340);                                                %N*J = 2340
    X = [DATA(1:2340,1:2340),DATA(1:2340,2485:2874)];
    Rinit = sum(X,2);

    FIN = X(1:N*J,1 + N*J:N*(J + 6));                                           %without Deficit
    FINsum = sum(FIN,2);
    F = FIN.*(FIN > 0);
    Fsum = sum(F,2);

    A = Zinit/diag(Rinit + .000001.*(Rinit<=0.000001));
    R = (eye(N*J) - A)\Fsum;
    Z = A  * diag(R);


    AggS = xlsread('..\data\AggS2018.xlsx'); J = size(AggS,1);
    CC = kron(eye(N),AggS);
    Z = CC * Z * (CC');
    F = CC * F;
    X = [Z, F];

    Zijsk4D = permute(reshape(Z, J, N, J, N),[2 4 1 3]);                        %[exporter importer supplier demander]
    Zijs3D = sum(Zijsk4D,4);                                                    %[exporter importer supplier]
    Fijsk4D = permute(reshape(F, J,N,6,N),[2 4 1 3]); 
    Fijs3D = sum(Fijsk4D,4);
    Yijs3D = Zijs3D + Fijs3D;                                                   %[exporter importer supplier]
    Yj_ni = reshape(permute(Yijs3D,[2 3 1]),J*N,N);                             %[importer*exporter supplier]
    eval(['X',num2str(t),' = X;']);

    Yijs = reshape(Yijs3D,N*N*J,1);                                             %[exporter*importer*supplier]
    Zijs = reshape(Zijs3D,N*N*J,1);
    Fijs = reshape(sum(Fijsk4D(:,:,:,1:4),4) + sum(Fijsk4D(:,:,:,6),4),N*N*J,1);
    
    filename = ['../data/ICIO2018_',num2str(t),'.xlsx'];
    xlswrite(filename,Yijs);
    filename2 = ['../data/ICIO2018_',num2str(t),'ZF.xlsx'];
    xlswrite(filename2,[Zijs,Fijs]);
    
    if t == 2005
        eval(['save ../data/X.mat X',num2str(t),';']);
    else
        eval(['save ../data/X.mat X',num2str(t),' -append;']);
    end

end
