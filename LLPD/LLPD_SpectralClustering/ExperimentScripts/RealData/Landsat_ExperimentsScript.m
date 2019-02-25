clear all;

addpath(genpath('../../../../LLPD_Code'));

% Landsat

%The classes are:
% 1	red soil 
% 2	cotton crop 
% 3	grey soil 
% 4	damp grey soil 
% 5	soil with vegetation stubble 
% 6	mixture class (all types present) NONE in data set
% 7	very damp grey soil 

load('Landsat.mat'); 
X = Landsat(:,1:end-1); LabelsGT = Landsat(:,end);
Classes = [1 2 4 5];
% Only consider classes 1,2,4,5:
restrict_class_idx = find(ismember(LabelsGT,Classes));
X = X(restrict_class_idx,:);
LabelsGT = LabelsGT(restrict_class_idx);

SetDefaultParameters

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 32;

SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(8, 80, 20);

ComparisonOpts.RunEucSC = 1;
ComparisonOpts.EucSCSigmaScaling = 'Manual'; 
ComparisonOpts.EucSCSigmaValues = linspace(20, 150, 20);

GeneralScript_LLPD_SC