clear all;
close all;
addpath(genpath('../../../../LLPD_Code'));
addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering/'));
load('SalinasA_gt.mat');



LabelsGT=salinasA_gt;

X=load('SalinasA.mat');
X=X.salinasA;
%X=LabelsGT;
%LabelsGT=reshape(LabelsGT,83*86,1);
X=reshape(X,83*86,224);

SetDefaultParameters
% denosing to make the point = 5348
LLPDopts.KNN = 1500; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

%DenoisingOpts.KNN = 450;
DenoisingOpts.Method='Cutoff'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 290;
SpectralOpts.SigmaScaling = 'Manual';
%SpectralOpts.SigmaValues = linspace(10, 700, 5);
SpectralOpts.SigmaValues = linspace(20, 120, 10);
SpectralOpts.NumEig = 10;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;


SpatialReg.UseReg = 1;
SpatialReg.Width = 83;
SpatialReg.Height = 86;
SpatialReg.Sigma = 50;
SpatialReg.R=1;
SpatialReg.r=80;

MajorV.Use = 1;
MajorV.Radius = 6;
MajorV.VoteRate = 0.7;
MajorV.Width = 83;
MajorV.Height = 86;

GeneralScript_LLPD_SC;

%save(['Results',date])
%%
figure;imagesc(reshape(Labels_LLPD_SC_FullData,83,86));
figure; imagesc(reshape(Labels_LLPD_SC_FullData,83,86).*salinasA_gt);
%imagesc(reshape(LabelsGT,83,86));
%without GT, image rotated 180 degree
%imagesc(reshape(Labels_LLPD_SC_FullData,83,86));
%save(['Results-DenosingKNN450',date,]);
