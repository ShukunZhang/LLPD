clear all

addpath(genpath('../../../../LLPD_Code'));

% DrivFace

load('DrivFaceData.mat'); load('LabelsJMM.mat'); LabelsGT = Labels';

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 10;

SpectralOpts.SigmaScaling = 'Manual'; 
SpectralOpts.SigmaValues = linspace(2, 7, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual';
ComparisonOpts.EucSCSigmaValues = linspace(5, 12, 20);

GeneralScript_LLPD_SC