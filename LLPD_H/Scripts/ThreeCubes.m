close all;
clear all;
A=zeros(1000,3);
for i=1:10
    for j=1:10
            for k=1:10
                A((i-1)*100+(j-1)*10+k,1) = i/10;
                A((i-1)*100+(j-1)*10+k,2) = j/10;
                A((i-1)*100+(j-1)*10+k,3)= k/10;
            end
    end
end

B=zeros(1000,3);
for i=1:10
    for j=1:10
        for k=1:10
            B((i-1)*100+(j-1)*10+k,1) = i/10;
            B((i-1)*100+(j-1)*10+k,2) = j/10;
            B((i-1)*100+(j-1)*10+k,3)=  k/10+2.3;
        end
    end
end
 
%2.3, 3.6

C=zeros(1000,3);
for i=1:10
    for j=1:10
        for k=1:10
            C((i-1)*100+(j-1)*10+k,1) = i/10;
            C((i-1)*100+(j-1)*10+k,2) = j/10;
            C((i-1)*100+(j-1)*10+k,3) = k/10+3.6;
        end
    end
end


 X=vertcat(A,B,C);
 figure; 
 scatter3(X(:,1),X(:,2),X(:,3),[],'filled');
 
 X=horzcat(X,zeros(3000,196));
 

 [Q,R] = qr(randn(199));
 X=X*Q;
 X=horzcat(X,zeros(3000,1));
 for i=1:3
     for j=1:1000
         X((i-1)*1000 + j,200) = i/10;
     end
 end

 
 
addpath(genpath('../../LLPD_H'));

 SetDefaultParameters 
 DenoisingOpts.Method='None';
 LLPDopts.KNN = 100; %Number of nearest neighbors in underlying graph
 SpectralOpts.SigmaScaling = 'Automatic';

 SpatialReg.UseReg = 1;
 SpatialReg.Width = 60;
 SpatialReg.Height = 50;
 SpatialReg.Sigma = 10000;
 
%  ComparisonOpts.RunEucSC = 1;
%  ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
% 
% 
% 
% 
  GeneralScript_LLPD_SC
  figure;
  %scatter3(X(:,1),X(:,2),X(:,3),[],Labels_EuclideanSC_FullData,'filled');
  %figure;
  scatter3(X(:,1),X(:,2),X(:,3),[],Labels_LLPD_SC_FullData,'filled');
 % imagesc(reshape(Labels_LLPD_SC_FullData,50,50));
%
