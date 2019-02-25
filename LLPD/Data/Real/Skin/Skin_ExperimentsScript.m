clear all;

addpath(genpath('../../../../LLPD_Code'));

% Skin 
%http://archive.ics.uci.edu/ml/datasets/Skin+Segmentation

load('Skin.mat');
X = Skin(:,1:end-1); LabelsGT = Skin(:,end);

SetDefaultParameters

LLPDopts.ThresholdMethod = 'PercentileScaling';
LLPDopts.PercentileSize = 10;
LLPDopts.UseFixedNumScales = 0; 
LLPDopts.KNN = 1000; 

DenoisingOpts.Method='Cutoff';
DenoisingOpts.Cutoff = 2;

SpectralOpts.SigmaScaling = 'Manual'; 
SpectralOpts.SigmaValues = 30:2:100;

GeneralScript_LLPD_SC
