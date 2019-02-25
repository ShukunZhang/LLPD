clear all;

addpath(genpath('../../../../LLPD_Code'));

% COIL
% http://www.cs.columbia.edu/CAVE/software/softlib/coil-20.php

load('COIL20.mat'); 
X = fea; LabelsGT = gnd;

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 4.5;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(1.1, 3.5, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(3.3, 6, 20);

GeneralScript_LLPD_SC