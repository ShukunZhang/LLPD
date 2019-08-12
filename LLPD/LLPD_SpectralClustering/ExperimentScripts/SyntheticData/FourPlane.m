close all;
clear all;

 X=zeros(4000,200);
 for i=1:4
     for j=1000
         X((i-1)*1000 + j,:)=rand(1,200);
         X((i-1)*1000 + j,200)=i*10;
     end
     
 end
 

addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering'));

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
% imagesc(reshape(Labels_LLPD_SC_FullData,50,50));
%  imagesc(reshape(Labels_EuclideanSC_FullData,50,50));
  GeneralScript_LLPD_SC
 