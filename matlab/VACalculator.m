clear all

%% 2005-2015 VAX and DVA
VAXt = zeros(65,11);
DVAt = zeros(65,11);
Et = zeros(65,11);
DVXt = zeros(65,11);
FVAt = zeros(65,11);
for year = 2005:1:2015
    N = 65; J = 18;
    eval(['load ..\data\X.mat X',num2str(year),';']);
    eval(['X = X',num2str(year),';']);
    Z = X(1:J*N,1:J*N);
    F = X(1:J*N,1 + J*N:(J+6)*N);
    Zj_ni3D = sum(permute(reshape(Z,J,N,J,N),[2 4 1 3]),4);                     %[exporter importer supplier]
    Fjk_ni = permute(reshape(F,J,N,6,N),[2 4 1 3]);
    INVj_ni3D = Fjk_ni(:,:,:,5);
    Fj_ni3D = sum(Fjk_ni(:,:,:,1:4),4) + Fjk_ni(:,:,:,6);
    Y = Zj_ni3D + Fj_ni3D + INVj_ni3D;
    % Y = Zj_ni3D + Fj_ni3D ;
    Yj_ni = reshape(permute(Y,[2 3 1]),J*N,N);                                  %[supplier*importer exporter]
    Zj_ni = reshape(permute(Zj_ni3D,[2 3 1]),J*N,N);
    Fj_ni = reshape(permute(Fj_ni3D,[2 3 1]),J*N,N);
    %plus ROW
    tariffdirection = ['..\data\tariff2018_',num2str(year),'.xlsx'];
    tariff = xlsread(tariffdirection);
    tau = reshape(tariff,J,N-1,N-1);                                            %[supplier exporter importer]
    tau = reshape(tau,J*(N-1),N-1);                                             %[supplier*exporter importer]
    tau = [tau,ones(J*(N-1),1)];                                                %importer + 1
    tau = reshape(permute(reshape(tau,J,N-1,N),[1 3 2]),J*N,N-1);
    tau = [tau,ones(J*N,1)];                                                    %[supplier*importer exporter+1]
    tau = reshape(permute(reshape(tau,J,N,N),[2 1 3]),J*N,N);                   %[importer*supplier exporter]
    
    Xj_m_ni = Zj_ni.*tau;
    Xj_f_ni = Fj_ni.*tau;
    
    R = sum([Z,F],2);
    GO = reshape(R,J,N);                                                        %[supplier exporter]
% test
% max(max(sum(permute(reshape(Yj_ni,N,J,N),[2 3 1]),3) - GO))

    Zjk_ni = reshape(Z,J,N,J,N);
    Zjk_n = sum(permute(Zjk_ni,[1 4 3 2]),4);
    Zjk_n2D = reshape(Zjk_n,J*N,J);
    Zj_n = sum(permute(Zjk_n,[2 3 1]),3);
    
    G = Zjk_n2D./kron(Zj_n,ones(J,1));                                          %IO [nation*upstream downstream]
    G(isnan(G)) = 0;
    %check IO, Singapore does not have minnig goods export
    %sum(permute(reshape(G,J,N,J), [2 3 1]),3)
    
    B = 1 - sum(sum(permute((permute(Zjk_ni,[4 1 2 3]).*(repmat(reshape(tau,N,J,N),[1 1 1 J]))),[4 1 2 3]),4),3)./(GO + 0.00000001*(GO == 0));                                 %Value Added Share [sector nation]

    %for JIE 2019
    Xj_m_n = sum(Xj_m_ni,2);
    Xj_f_n = sum(Xj_f_ni,2);

    %for JIE 2019
    PIj_m_ni = Xj_m_ni./(Xj_m_n*ones(1,N));
    PIj_m_ni(1 + (J-1)*N :J*N, :) = eye(N);

    [VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
    VAXt(:,year - 2004) = VAX;
    DVAt(:,year - 2004) = VAX + RDV;
    Et(:,year - 2004) = E;
    DVXt(:,year - 2004) = DVX;
    FVAt(:,year - 2004) = FVA;
end
xlswrite('..\data\VAXandE2005-2015.xlsx',[VAXt,DVAt,Et,DVXt,FVAt]);
%% CP 2015
% clear all
% load '..\data\basic.mat' B G N J;
% load '..\data\rcep.mat' PIj_nip_rcep Xj_np_rcep;
% load ..\data\Xj_nip_nodeficit.mat
% Xj_ni = Xj_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
% 
% %3维处理
% % Calculating X0 Expenditure
% Xj_n=sum((Xj_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支
% 
% % Calculating Expenditure shares
% PIj_ni=Xj_ni./(Xj_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
% PIj_ni(isnan(PIj_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
%                                                              %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
%                                                              %排除掉
% % PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
% 
% % Calculating superavits
% Yj_ni=Yj_nip_noD;                                            % 总收益FOB
% 
% load '..\data\tau.mat' taup tau_rcep_tariff;
% Xj_nip_rcep = (Xj_np_rcep*ones(1,N)).*PIj_nip_rcep;
% Yj_nip_rcep = Xj_nip_rcep./tau_rcep_tariff ;
% [VAX, RDV, E, DVX, FVA] = VA(PIj_ni, Xj_ni, Yj_ni, taup, taup, B, G, J, N);
% [VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
% DVA = VAX + RDV;
% DVAp = VAXp + RDVp;
% xlswrite('..\result\Why different trade type is important\VAXandEchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
%% JIE 2019 without heterogeneous trade cost change
clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
xlswrite('..\result\Why different trade type is important\VAXandEchange.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
%% counterfactal with different trade cost between intermediate and final use
clear all
load '..\data\basic.mat' B G N J;
load '..\data\rcep_JIE_diff.mat' PIj_m_nip_rcep PIj_f_nip_rcep Xj_m_np_rcep Xj_f_np_rcep;
load ..\data\Xj_nip_nodeficit_JIE.mat
Xj_m_ni = Xj_m_nip_noD;                                          % 第1个65*65矩阵是第1个部门行国家n从列国家i进口的开支
Xj_f_ni = Xj_f_nip_noD;
%3维处理
% Calculating X0 Expenditure
Xj_m_n=sum((Xj_m_ni'));                                            % 第1个31列是进口第1种产品的31个国家的总进口开支

% Calculating Expenditure shares
PIj_m_ni=Xj_m_ni./(Xj_m_n'*ones(1,N));                                          % 国家n从国家i进口j部门产品占总进口的份额
PIj_m_ni(isnan(PIj_m_ni)) = 0;                                   %非常重要的一个调整，因为有些国家对有些部门产品可能不存在出口，比如拉托维亚
                                                             %和瑞士对石油产品就不存在出口，甚至无法生产，所以需要将Xj_n的贸易价值为0的情况
                                                             %排除掉
% PIj_ni((J-1)*N + 1:J*N, :) = eye(N);                         %由于服务业部门合并太多，可能会出现部门投入产出变化过大，因此全部变为不可贸易品
Xj_f_n=sum((Xj_f_ni'));                                          
PIj_f_ni=Xj_f_ni./(Xj_f_n'*ones(1,N));                           
PIj_f_ni(isnan(PIj_f_ni)) = 0;                                   


% Calculating superavits
Yj_ni=Yj_nip_noD;                                            % 总收益FOB

load '..\data\tau_JIE.mat' tau tau_rcep_mtariff tau_rcep_ftariff;
Xj_m_nip_rcep = (Xj_m_np_rcep*ones(1,N)).*PIj_m_nip_rcep;
Xj_f_nip_rcep = (Xj_f_np_rcep*ones(1,N)).*PIj_f_nip_rcep;
Yj_nip_rcep = Xj_m_nip_rcep./tau_rcep_mtariff + Xj_f_nip_rcep./tau_rcep_ftariff;
[VAX, RDV, E, DVX, FVA] = VA(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[va1, va2, va3, va4, va5, va6, va7, va8, va9, Ej_ni] = VAdecomposition(PIj_m_ni, Xj_f_ni, Yj_ni, tau, tau, B, G, J, N);
[VAXp, RDVp, Ep, DVXp, FVAp] = VA(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
[va1p, va2p, va3p, va4p, va5p, va6p, va7p, va8p, va9p, Ej_nip] = VAdecomposition(PIj_m_nip_rcep, Xj_f_nip_rcep, Yj_nip_rcep, tau_rcep_mtariff, tau_rcep_ftariff, B, G, J, N);
DVA = VAX + RDV;
DVAp = VAXp + RDVp;
xlswrite('..\result\baseline\VAXandEchange_diff.xlsx',[VAX DVA DVX FVA E VAXp DVAp DVXp FVAp Ep]);
xlswrite('..\result\baseline\VAdecomposition_before.xlsx',[va1 va2 va3 va4 va5 va6 va7 va8 va9 Ej_ni]);
xlswrite('..\result\baseline\VAdecomposition_after.xlsx',[va1p va2p va3p va4p va5p va6p va7p va8p va9p Ej_nip]);


%% 1995-2011 VAX and DVA
