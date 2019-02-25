clear all;

addpath(genpath('../../../../LLPD_Code'));

% COIL
% http://www.cs.columbia.edu/CAVE/software/softlib/coil-20.php

load('COIL20.mat'); 
Classes = [1 2 4 5 6 7 10:18 20];
restrict_class_idx = find(ismember(gnd,Classes));
X = fea(restrict_class_idx,:);
LabelsGT = gnd(restrict_class_idx);

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 3.9;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(1.1, 3.5, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(3.3, 5.5, 20);

GeneralScript_LLPD_SC