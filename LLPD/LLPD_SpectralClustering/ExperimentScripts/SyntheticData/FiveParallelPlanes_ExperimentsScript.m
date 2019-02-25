clear all

addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering'));

load('ParallelPlanesMethod2_d10_D30_k5_n1_200_n2_200.mat');

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = .9;

SpectralOpts.SigmaScaling = 'Manual'; 
SpectralOpts.SigmaValues = linspace(.2, .7, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual';
ComparisonOpts.EucSCSigmaValues = linspace(.5, 2.5, 20);

GeneralScript_LLPD_SC
