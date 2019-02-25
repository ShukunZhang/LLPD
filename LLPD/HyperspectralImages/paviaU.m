clear all;

addpath(genpath('../../../../LLPD_Code'));

load('paviaU_gt.mat');
LabelsGT=paviaU_gt;

X=load('paviaU.mat');
X=X.paviaU;

X=reshape(X,610*340,103);

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 4.5;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(1.1, 3.5, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(3.3, 6, 20);

GeneralScript_LLPD_SC