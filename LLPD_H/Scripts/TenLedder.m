close all;
clear all;

 A=rand(100);
 for i=1:199
     A=cat(3,A,rand(100)/5);
 end
 
 X=A(:,:,1);
 Y=A(:,:,2);
 Z=A(:,:,3);
 B=reshape(A,10000,200);
 for i=1:9
     for j = 1:1000
       B(i*1000+j,:)=B(i*1000+j,:) + i;
     end
 end
 B(:,200)=20*rand(10000,1);
%A=zeros(100,100);

 addpath(genpath( '../../LLPD_H'));
  X=B;
SetDefaultParameters
 
 DenoisingOpts.Method='None';
 LLPDopts.KNN = 800; %Number of nearest neighbors in underlying graph
 SpectralOpts.SigmaScaling = 'Automatic';
 
 ComparisonOpts.RunEucSC = 1;
 ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
% 
% 
% 
% 
 GeneralScript_LLPD_SC
figure;
scatter(X(Idx_Retain,1),X(Idx_Retain,2),[],Labels_LLPD_SC_FullData,'filled');
figure;
scatter(X(Idx_Retain,1),X(Idx_Retain,2),[],Labels_EuclideanSC_FullData,'filled');
% imagesc(reshape(Labels_LLPD_SC_FullData,50,50));
%  imagesc(reshape(Labels_EuclideanSC_FullData,50,50));
 
