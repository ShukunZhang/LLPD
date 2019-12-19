
addpath(genpath('../LLPD-master 4'));
clear all;
close all;

load('paviaU.mat');
X=paviaU([300:340],[140:189],:);
load('paviaU_gt.mat');
LabelsGT=double(paviaU_gt([300:340],[140:189]));
X=reshape(X,41*50,103);
Yuse=UniqueGT(LabelsGT(LabelsGT>0));
%% Compute Ultrametric SC with LLPD 
% The Kmeans and SC with Euc distance will be computed among our method

SetDefaultParameters
LLPDopts.KNN = 600 ; %Number of nearest neighbors in underlying graph
LLPDopts.UseFixedNumScales = 0; %Forces a fixed number of scales in LLPD approximation
LLPDopts.LogRatio=1.1;
DenoisingOpts.Method='Cutoff'; %Look at figure to denoise, or set a cutoff?
DenoisingOpts.Cutoff = 750;
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(100, 700, 10);
SpectralOpts.NumEig = 10;
ComparisonOpts.RunEucSC = 1;
ComparisonOpts.RunKmeans = 1;
ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 


SpatialReg.UseReg = 1;
SpatialReg.Width = 41; %41
SpatialReg.Height = 50; %50
SpatialReg.r=30;

MajorV.Use = 1;
MajorV.Radius = 3;
MajorV.VoteRate = 0.7;
MajorV.Width = 41;
MajorV.Height = 50;

GeneralScript_LLPD_SC;
%% Do PCA dimension reduction first, then compute Kmeans
V=GetPC(X);
Labels_PCA=kmeans(X*V(:,1:10),K,'Replicates', SpectralOpts.NumReplicates)';
Labels_PCA=reshape(Labels_PCA,41*50,1);
[OA_PCA,AA_PCA,Kappa_PCA]=GetAccuracies(Labels_PCA(LabelsGT>0),Yuse,K);
%% Compute Gaussian Mixture Model
gmfit=fitgmdist(X,K, 'CovarianceType', 'full',  'RegularizationValue', 1e-10);
Labels_GMM= cluster(gmfit,X);
[OA_GMM,AA_GMM,Kappa_GMM]=GetAccuracies(Labels_GMM(LabelsGT>0),Yuse,K);
%% Compute Hierarchical NMF
Labels_NMF=hierclust2nmf((X-min(min(X)))',K);
 [OA_NMF,AA_NMF,KappaNMF]=GetAccuracies(Labels_NMF(LabelsGT>0),Yuse,K);
%
%% Compute Diffusion Learning
DataInput.datasource='HSI';
DataInput.HSIname='Pavia';
[X_d,Y,Ytuple,K_GT,d,DataParameters,PeakOpts.Window_Diffusion]=GenerateData(DataInput);
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

if isempty(GT)
    [I,J]=find(sum(DataParameters.RawHSI,3)~=0);
else
   [I,J]=find(GT>-1);
end

% Diffusion distances
PeakOpts.ModeDetection='Diffusion';
[CentersDiffusion, G_dif, DistStructDiffusion] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
Labels_DL=FSFclustering(X,K,DistStructDiffusion,CentersDiffusion);
Labels_DL=reshape(Labels_DL,41*50,1);

% Spatial-Spectral Diffusion Learning
[Labels_DLSS,Labels_DLSS_Pass1]=SpatialSpectralDiffusionLearning(X_d,K_GT,DistStructDiffusion,CentersDiffusion,I,J,M,N,SpatialWindowSize);
Labels_DLSS=reshape(Labels_DLSS,41*50,1);

% Euclidean distances
PeakOpts.ModeDetection='Euclidean';
[CentersEuclidean, G_euc, DistStructEuclidean] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
Labels_FSFDPC=FSFclustering(X,K_GT,DistStructEuclidean,CentersEuclidean);
Labels_FSFDPC=reshape(Labels_FSFDPC,41*50,1);

% Diffusion distances with spatial regularization
PeakOpts.ModeDetection='SpatialDiffusion';
[CentersSpatialDiffusion, G_Spatialdif, DistStructSpatialDiffusion] = DensityPeaksEstimation(X_d, K_Learned, DensityNN, PeakOpts, M, N);
[Labels_SRDL,Labels_SRDL_Pass1]=SpatialSpectralDiffusionLearning(X_d,K_GT,DistStructSpatialDiffusion,CentersSpatialDiffusion,I,J,M,N,SpatialWindowSize);
Labels_SRDL=reshape(Labels_SRDL,41*50,1);

%Compute OA, AA, Kappa after aligning
%Diffusion Learning
[OA_DL,AA_DL,Kappa_DL]=GetAccuracies(Labels_DL(LabelsGT>0),Yuse,K);
[OA_FSFDPC,AA_FSFDPC,Kappa_FSFDPC]=GetAccuracies(Labels_FSFDPC(LabelsGT>0),Yuse,K_Learned);
[OA_SRDL,AA_SRDL,Kappa_SRDL]=GetAccuracies(Labels_SRDL(LabelsGT>0),Yuse,K_Learned);
[OA_DLSS,AA_DLSS,Kappa_DLSS]=GetAccuracies(Labels_DLSS(LabelsGT>0),Yuse,K_Learned);


%% Compute ...
