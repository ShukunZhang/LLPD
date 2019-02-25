clear all

addpath(genpath('../../../../LLPD_Code'));

load('EmbeddedSpheres_d2_D1000_r_1_1.5_2_nmin250_nnoise_2000.mat')

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 2;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(.08, .25, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(.4, 1.5, 20);

GeneralScript_LLPD_SC