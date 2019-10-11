clear all;
close all;

addpath(genpath('../../../../LLPD_Code'));
addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering/'));

load('Indian_pines_gt.mat');
L=indian_pines_gt;
%LabelsGT=L;
X=load('Indian_pines_corrected.mat');
X=X.indian_pines_corrected;
figure; imagesc(L);



Y=X([31:70],[3:37],:);
LabelsGT=L([31:70],[3:37]);
figure;imagesc(LabelsGT);
figure; imagesc(sum(Y,3));
X=reshape(Y,40*35,200);

%%
SetDefaultParameters
LLPDopts.KNN = 600 ; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

%DenoisingOpts.KNN = 100;
DenoisingOpts.Method='ExamineFigure'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 1000;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(100, 300, 10);
SpectralOpts.NumEig = 10;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
ComparisonOpts.EucSCSigmaValues = linspace(1, 5, 5);

SpatialReg.UseReg = 1;
SpatialReg.Width = 40;
SpatialReg.Height = 35;
SpatialReg.Sigma = 100;
SpatialReg.R=0;
MajorV.Use = 0;
GeneralScript_LLPD_SC;



%figure;imagesc(reshape(L,145,145));
%figure;imagesc(reshape(LabelsGT,145,145));
%figure;imagesc(reshape(Labels_LLPD_SC_FullData,145,145));

