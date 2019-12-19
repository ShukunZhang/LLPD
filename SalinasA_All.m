
profile off;
profile on;
addpath(genpath('../LLPD-master 4'));

clear all;
close all;

load('SalinasA_gt.mat');
LabelsGT=salinasA_gt;
X=load('SalinasA.mat');
X=X.salinasA;
X=reshape(X,83*86,224);
Yuse=UniqueGT(LabelsGT(LabelsGT>0));
%% Compute Ultrametric SC with LLPD 
% The Kmeans and SC with Euc distance will be computed among our method
SetDefaultParameters

LLPDopts.KNN = 1500; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;
DenoisingOpts.Method='Cutoff'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 290;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(10, 700, 20);
SpectralOpts.NumEig = 20;
ComparisonOpts.RunEucSC = 1;
ComparisonOpts.RunKmeans = 1;
SpatialReg.UseReg = 1;
SpatialReg.Width = 83;
SpatialReg.Height = 86;
SpatialReg.r=65;
MajorV.Use = 1;
MajorV.Radius = 6;
MajorV.VoteRate = 0.7;
MajorV.Width = 83;
MajorV.Height = 86;
GeneralScript_LLPD_SC;

%% Do PCA dimension reduction first, then compute Kmeans
V=GetPC(X);
Labels_PCA=kmeans(X*V(:,1:10),K,'Replicates', SpectralOpts.NumReplicates)';
Labels_PCA=reshape(Labels_PCA,83*86,1);
[OA_PCA,AA_PCA,Kappa_PCA]=GetAccuracies(Labels_PCA(LabelsGT>0),Yuse,K);
%% Compute Gaussian Mixture Model
gmfit=fitgmdist(X,K, 'CovarianceType', 'full',  'RegularizationValue', 1e-10);
Labels_GMM= cluster(gmfit,X);
[OA_GMM,AA_GMM,Kappa_GMM]=GetAccuracies(Labels_GMM(LabelsGT>0),Yuse,K);
%% Compute Hierarchical NMF
Labels_NMF=hierclust2nmf((X-min(min(X)))',K);
 [OA_NMF,AA_NMF,Kappa_NMF]=GetAccuracies(Labels_NMF(LabelsGT>0),Yuse,K);
%% Compute Diffusion Learning
DataInput.datasource='HSI';
DataInput.HSIname='SalinasA';
[X_d,Y,Ytuple,K_GT,d,DataParameters,PeakOpts.Window_Diffusion]=GenerateData(DataInput);
Y=Y';
Ytuple=Ytuple';
GT=DataParameters.GT;
M=DataParameters.M;
N=DataParameters.N;

% Set Parameters

%Data name
PeakOpts.Data=DataInput.HSIname;

%Should we plot everything or not?  Should we save things?
UserPlot=0;
SavePlots=0;
PeakOpts.UserPlot=UserPlot;

%Detect number of eigenvectors to use automatically
PeakOpts.DiffusionOpts.K='automatic'; 

%How many nearest neighbors to use for diffusion distance
PeakOpts.DiffusionOpts.kNN=100;

%Force probability of self-loop to exceed .5.
PeakOpts.DiffusionOpts.LazyWalk=0;

%Set epsilon for weight matrix; use same one for spectral clustering
PeakOpts.DiffusionOpts.epsilon=1;

% Set time to evaluate diffusion distance
PeakOpts.DiffusionTime=30;

%Kmeans parameters
NumReplicates=10;
MaxIterations=100;

%Set how many cores we want to learn.  If K_Learned is different from
%K_GT, it will not be possible to compare easily and immediately against
%the ground truth, though other patterns may be studied in this way.
K_Learned=K_GT;

%How many nearest neighbors to use for KDE
DensityNN=20;

%Spatial window size for labeling regime
SpatialWindowSize=3;

if isempty(LabelsGT)
    [I,J]=find(sum(DataParameters.RawHSI,3)~=0);
else
   [I,J]=find(LabelsGT>-1);
end

% Diffusion distances
PeakOpts.ModeDetection='Diffusion';
[CentersDiffusion, G_dif, DistStructDiffusion] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
Labels_DL=FSFclustering(X,K,DistStructDiffusion,CentersDiffusion);
Labels_DL=reshape(Labels_DL,83*86,1);

% Spatial-Spectral Diffusion Learning
[Labels_DLSS,Labels_DLSS_Pass1]=SpatialSpectralDiffusionLearning(X_d,K_GT,DistStructDiffusion,CentersDiffusion,I,J,M,N,SpatialWindowSize);
Labels_DLSS=reshape(Labels_DLSS,83*86,1);

% Euclidean distances
PeakOpts.ModeDetection='Euclidean';
[CentersEuclidean, G_euc, DistStructEuclidean] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
Labels_FSFDPC=FSFclustering(X,K_GT,DistStructEuclidean,CentersEuclidean);
Labels_FSFDPC=reshape(Labels_FSFDPC,83*86,1);

% Diffusion distances with spatial regularization
PeakOpts.ModeDetection='SpatialDiffusion';
[CentersSpatialDiffusion, G_Spatialdif, DistStructSpatialDiffusion] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
[Labels_SRDL,Labels_SRDL_Pass1]=SpatialSpectralDiffusionLearning(X_d,K_GT,DistStructSpatialDiffusion,CentersSpatialDiffusion,I,J,M,N,SpatialWindowSize);
Labels_SRDL=reshape(Labels_SRDL,83*86,1);

%Compute OA, AA, Kappa after aligning
%Diffusion Learning
[OA_DL,AA_DL,Kappa_DL]=GetAccuracies(Labels_DL(Y>0),Yuse,K);
[OA_FSFDPC,AA_FSFDPC,Kappa_FSFDPC]=GetAccuracies(Labels_FSFDPC(Y>0),Yuse,K_Learned);
[OA_SRDL,AA_SRDL,Kappa_SRDL]=GetAccuracies(Labels_SRDL(Y>0),Yuse,K_Learned);
[OA_DLSS,AA_DLSS,Kappa_DLSS]=GetAccuracies(Labels_DLSS(Y>0),Yuse,K_Learned);
%% Compute ...
