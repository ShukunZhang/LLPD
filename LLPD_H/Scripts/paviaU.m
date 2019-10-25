
clear all;
close all;
addpath(genpath('../../LLPD_H'));



load('paviaU_gt.mat');
LabelsGT=paviaU_gt;

X=load('paviaU.mat');
X=X.paviaU;
figure; imagesc(LabelsGT);
figure; imagesc(sum(X,3));
%%
Y=X([300:340],[140:189],:);
L=LabelsGT([300:340],[140:189]);
%figure;imagesc(LabelsGT);
figure; imagesc(sum(Y,3));

X=reshape(Y,41*50,103);
LabelsGT=double(L);
%%
SetDefaultParameters
LLPDopts.KNN = 600 ; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

%DenoisingOpts.KNN = 100;
DenoisingOpts.Method='Cutoff'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 750;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(100, 700, 10);
SpectralOpts.NumEig = 10;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
ComparisonOpts.EucSCSigmaValues = linspace(1, 5, 5);

SpatialReg.UseReg = 1;
SpatialReg.Width = 41;
SpatialReg.Height = 50;
SpatialReg.Sigma = 100;
SpatialReg.R=1;
SpatialReg.r=15;

MajorV.Use = 1;
MajorV.Radius = 3;
MajorV.VoteRate = 0.7;
MajorV.Width = 41;
MajorV.Height = 50;

GeneralScript_LLPD_SC;


%%
figure;imagesc(reshape(LabelsGT,41,50));
%figure;imagesc(reshape(Labels_LLPD_SC_FullData_NS,41,50));
figure;imagesc(reshape(Labels_LLPD_SC_FullData,41,50));
figure;imagesc(reshape(Labels_LLPD_SC_FullData,41,50).*LabelsGT);
