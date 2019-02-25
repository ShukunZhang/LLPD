clear all;

addpath(genpath('../../../../LLPD_Code'));

% PenDigits
% https://archive.ics.uci.edu/ml/datasets/Pen-Based+Recognition+of+Handwritten+Digits

load('pendigits.mat');
X = pendigits(:,1:end-1);
LabelsGT = pendigits(:,end);
digits_idx = find(ismember(LabelsGT, [0 2 3 4 6])==1);
X = X(digits_idx,:); 
LabelsGT = LabelsGT(digits_idx);
LabelsGT = LabelsGT+1;

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 60;

SpectralOpts.SigmaScaling = 'Manual'; 
SpectralOpts.SigmaValues = linspace(8, 34, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(20, 100, 20);

GeneralScript_LLPD_SC