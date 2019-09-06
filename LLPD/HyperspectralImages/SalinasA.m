clear all;

addpath(genpath('C:\Users\zhang\Desktop\LLPD-master'));
load('SalinasA_gt.mat');
LabelsGT=salinasA_gt;

X=load('SalinasA.mat');
X=X.salinasA;
X=reshape(X,83*86,224);

SetDefaultParameters

LLPDopts.KNN = 1500; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 290;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(20, 120, 20);
SpectralOpts.NumEig = 20;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;


SpatialReg.UseReg = 1;
SpatialReg.Width = 83;
SpatialReg.Height = 86;
SpatialReg.Sigma = 150;


GeneralScript_LLPD_SC;
figure;imagesc(reshape(Labels_LLPD_SC_FullData,83,86));


% SpatialReg.UseReg = 0;
% SpectralOpts.SigmaValues = linspace(10, 700, 20);
% GeneralScript_LLPD_SC;
