clear all;

addpath(genpath('../../../LLPD/'));
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
DenoisingOpts.Cutoff = 300;
SpectralOpts.SigmaScaling = 'Automatic';
SpectralOpts.SigmaValues = linspace(10, 700, 20);
SpectralOpts.NumEig = 15;
ComparisonOpts.RunEucSC = 0;
ComparisonOpts.RunKmeans = 0;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
ComparisonOpts.EucSCSigmaValues = linspace(1, 5, 5);

GeneralScript_LLPD_SC;

save(['Results',date])
