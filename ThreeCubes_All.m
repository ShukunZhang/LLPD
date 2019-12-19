close all;
clear all;
X=zeros(1000,3);

for i=1:10
    for j=1:10
        for k=1:10
            X((i-1)*100+(j-1)*10+k,1) = i/10;
            X((i-1)*100+(j-1)*10+k,2) = j/10;
            X((i-1)*100+(j-1)*10+k,3) = k/10;
        end
    end
end
X=vertcat(X,X,X);

X([1001:2000],3) = X([1001:2000],3)+1.2;
X([2001:3000],3) = X([2001:3000],3)+2.4;


 
 X=horzcat(X,zeros(3000,196));
 

 [Q,R] = qr(randn(199));
 X=X*Q;
 X=horzcat(X,ones(3000,1));
 for i=1:3
     for j=1:1000
         X((i-1)*1000 + j,200) = i/10; 
     end
 end

%  
  C_1=X(randi([500 600],30,1),:);
  C_2=X(randi([2500 2600],30,1),:);
%  
  X(randi([500 600],30,1),:)=C_2;
  X(randi([2500 2600],30,1),:) = C_1;

 %%
addpath(genpath('../LLPD-master 4'));
load('ThreeCubes_gt.mat');
LabelsGT=TCGT;
 SetDefaultParameters 
 DenoisingOpts.Method='None';
 
 %using spatial 
 LLPDopts.KNN = 1400; 
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(5, 500, 2);



 SpatialReg.UseReg = 1;
 SpatialReg.Width = 50;
 SpatialReg.Height = 60;

 SpatialReg.r=30;
 MajorV.Use = 0;

 
 ComparisonOpts.RunEucSC = 1;
  ComparisonOpts.Kmeans = 1;
 ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
% 
% 
% 
  GeneralScript_LLPD_SC

 %% Do PCA dimension reduction first, then compute Kmeans
V=GetPC(X);
Labels_PCA=kmeans(X*V(:,1:2),K,'Replicates', SpectralOpts.NumReplicates)';
Labels_PCA=reshape(Labels_PCA,50*60,1);
[OA_PCA,AA_PCA,Kappa_PCA]=GetAccuracies(Labels_PCA(LabelsGT>0),reshape(LabelsGT,50*60,1),K);
%% Compute Gaussian Mixture Model
gmfit=fitgmdist(X,K, 'CovarianceType', 'full',  'RegularizationValue', 1e-10);
Labels_GMM= cluster(gmfit,X);
[OA_GMM,AA_GMM,Kappa_GMM]=GetAccuracies(Labels_GMM(LabelsGT>0),reshape(LabelsGT,50*60,1),K);
%% Compute Hierarchical NMF
Labels_NMF=hierclust2nmf((X-min(min(X)))',K);
 [OA_NMF,AA_NMF,KappaNMF]=GetAccuracies(Labels_NMF(LabelsGT>0),reshape(LabelsGT,50*60,1),K);
%
%% 
%% Compute Diffusion Learning
Y=LabelsGT;
Yuse=UniqueGT(LabelsGT(LabelsGT>0));
GT=Y;
Y=reshape(Y,size(Y,1)*size(Y,2),size(Y,3));
Y=Y';

Y=Y(Y>0);
Y=UniqueGT(Y);
    
K_GT=max(Y);
    
Y=LabelsGT';  
%X=permute(X,[2,1,3]); 
M=50;
N=60;
PeakOpts.Window_Diffusion = 20;


%%
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
K_Learned=K;

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
[CentersDiffusion, G_dif, DistStructDiffusion] = DensityPeaksEstimation(X, K_Learned, DensityNN, PeakOpts, M, N);
Labels_DL=FSFclustering(X,K,DistStructDiffusion,CentersDiffusion);
Labels_DL=reshape(Labels_DL,50*60,1);
% 
% % Spatial-Spectral Diffusion Learning
 [Labels_DLSS,Labels_DLSS_Pass1]=SpatialSpectralDiffusionLearning(X,K_GT,DistStructDiffusion,CentersDiffusion,I,J,M,N,SpatialWindowSize);
 Labels_DLSS=reshape(Labels_DLSS,50*60,1);
% 
% % Euclidean distances
 PeakOpts.ModeDetection='Euclidean';
 [CentersEuclidean, G_euc, DistStructEuclidean] = DensityPeaksEstimation(X, K_Learned, DensityNN, PeakOpts, M, N);
 Labels_FSFDPC=FSFclustering(X,K_GT,DistStructEuclidean,CentersEuclidean);
 Labels_FSFDPC=reshape(Labels_FSFDPC,50*60,1);
% 
% % Diffusion distances with spatial regularization
 PeakOpts.ModeDetection='SpatialDiffusion';
 [CentersSpatialDiffusion, G_Spatialdif, DistStructSpatialDiffusion] = DensityPeaksEstimation(X, K_Learned, DensityNN, PeakOpts, M, N);
 [Labels_SRDL,Labels_SRDL_Pass1]=SpatialSpectralDiffusionLearning(X,K_GT,DistStructSpatialDiffusion,CentersSpatialDiffusion,I,J,M,N,SpatialWindowSize);
 Labels_SRDL=reshape(Labels_SRDL,50*60,1);
% 
% %Compute OA, AA, Kappa after aligning
% %Diffusion Learning
 [OA_DL,AA_DL,Kappa_DL]=GetAccuracies(Labels_DL(LabelsGT>0),Yuse,K);
 [OA_FSFDPC,AA_FSFDPC,Kappa_FSFDPC]=GetAccuracies(Labels_FSFDPC(LabelsGT>0),Yuse,K_Learned);
 [OA_SRDL,AA_SRDL,Kappa_SRDL]=GetAccuracies(Labels_SRDL(LabelsGT>0),Yuse,K_Learned);
 [OA_DLSS,AA_DLSS,Kappa_DLSS]=GetAccuracies(Labels_DLSS(LabelsGT>0),Yuse,K_Learned);
% 
%  