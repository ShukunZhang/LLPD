clear all

addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering'));

load('FourLinesWithMedNoise.mat');

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = .03;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(.005, .1, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(.02, .17, 20); 

GeneralScript_LLPD_SC
