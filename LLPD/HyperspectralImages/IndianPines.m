clear all;
close all;

addpath(genpath('../../../../LLPD_Code'));
addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering/'));

load('Indian_pines_gt.mat');
L=indian_pines_gt;
LabelsGT=L;
X=load('Indian_pines_corrected.mat');
X=X.indian_pines_corrected;

X=reshape(X,145*145,200);
% 
% for i=1:20
%     for j=1:20
%         Y(i,j,:)=X(i+6,j+28,:);
%         LabelsGT(i,j)=L(i+6,j+28);
%     end
% end
%         
% X=reshape(Y,400,200);


SetDefaultParameters
LLPDopts.KNN = 1000 ; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

%DenoisingOpts.KNN = 450;
DenoisingOpts.Method='Cutoff'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 1000;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(100, 800, 20);
SpectralOpts.NumEig = 20;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
ComparisonOpts.EucSCSigmaValues = linspace(1, 5, 5);

SpatialReg.UseReg = 0;
SpatialReg.Width = 20;
SpatialReg.Height = 20;
SpatialReg.Sigma = 1000;
GeneralScript_LLPD_SC;



%figure;imagesc(reshape(L,145,145));
figure;imagesc(reshape(LabelsGT,145,145));
figure;imagesc(reshape(Labels_LLPD_SC_FullData,145,145));

