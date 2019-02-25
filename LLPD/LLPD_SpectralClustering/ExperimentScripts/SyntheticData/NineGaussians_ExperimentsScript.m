clear all

addpath(genpath('../../../../LLPD_Code'));

load('NineGaussiansUnequalDensity2WithNoise.mat')

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = .13;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(.02, .32, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(.1, 1, 20);

GeneralScript_LLPD_SC