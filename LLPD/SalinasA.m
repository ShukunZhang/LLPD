clear all;

addpath(genpath('../../../../LLPD_Code'));
addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/'));
load('SalinasA_gt.mat');
%X=salinasA_gt;
%imagesc(X);
%X=reshape(X,83*86,1);

LabelsGT=salinasA_gt;

X=load('SalinasA.mat');
X=X.salinasA;
%X=LabelsGT;
%LabelsGT=reshape(LabelsGT,83*86,1);
X=reshape(X,83*86,224);

SetDefaultParameters

LLPDopts.KNN = size(X,1); %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;

DenoisingOpts.Method='None';
%DenoisingOpts.Cutoff = 10;
SpectralOpts.SigmaScaling = 'Automatic';
SpectralOpts.SigmaValues = linspace(1, 7, 20);
SpectralOpts.NumEig = 7;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
ComparisonOpts.EucSCSigmaValues = linspace(1, 5, 5);

GeneralScript_LLPD_SC;

save(['Results',date])