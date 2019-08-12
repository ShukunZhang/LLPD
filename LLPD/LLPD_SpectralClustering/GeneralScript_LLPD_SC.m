% Before running script, data matrix X should be stored in workspace and
% the structures LLPDopts, DenoisingOpts, SpectralOpts, and ComparisonOpts
% should be defined (this can be done by running SetDefaultParameters.m).
% See the README for more details and documentation of options. If a ground truth file is
% available for accuracy quantification, it should be stored as a column 
% vector named LabelsGT. The script denoises the data and then runs LLPD
% spectral clustering; number of clusters K and scale sigma are
% automatically selected. The script can run K-means and Euclidean spectral
% clustering for comparison if desired.

profile off;
profile on;

if size(X,2)==2
    figure
    scatter(X(:,1),X(:,2),'filled')
    title('Original Data','fontsize',16)
end

%%  Compute eigenvectors of LLPD Laplacian, while denoising

if SpatialReg.UseReg
    [EigVals_LLPD,EigVecs_LLPD,Idx_Retain,Sigma_LLPD] = FastEigensolverDenoisingS(X,LLPDopts,SpectralOpts,DenoisingOpts,SpatialReg);
else
    [EigVals_LLPD,EigVecs_LLPD,Idx_Retain,Sigma_LLPD] = FastEigensolverDenoising(X,LLPDopts,SpectralOpts,DenoisingOpts);
end

if ComparisonOpts.RunEucSC
    [EigVals_Euc,EigVecs_Euc, Sigma_Euc] = EuclideanEigensolver(X(Idx_Retain,:),LLPDopts,ComparisonOpts);
end 

%% Relabel the ground truth

if exist('LabelsGT')
    LabelsGT=UniqueGT(LabelsGT); 
    K = length(unique(LabelsGT(Idx_Retain)))-1; % 0 is not a class!
end

%%  Compare K-means, Euclidean spectral clustering, and LLPD spectral clustering on the denoised data

[K_EstimateLLPD,MaxGapScaleLLPD,SizeMaxGapLLPD,SigmaIndexMaxGapLLPD,NewIndexLLPD]=ComputeEigengaps(EigVals_LLPD);
Sigma_EstimateLLPD = Sigma_LLPD(SigmaIndexMaxGapLLPD);

if ComparisonOpts.RunEucSC ==1
    [K_EstimateEuc,MaxGapScaleEuc,SizeMaxGapEuc,SigmaIndexMaxGapEuc,NewIndexEuc]=ComputeEigengaps(EigVals_Euc);
    Sigma_EstimateEuc = Sigma_Euc(SigmaIndexMaxGapEuc);
end

if exist('LabelsGT')==0
    K_LLPD = K_EstimateLLPD;   
    SigmaIndexLLPD = SigmaIndexMaxGapLLPD;
    if ComparisonOpts.RunEucSC
        K_Euc = K_EstimateEuc;
        SigmaIndexEuc = SigmaIndexMaxGapEuc;
    end
elseif exist('LabelsGT')
    K_LLPD = K;
    try
        SigmaIndexLLPD = find(EigVals_LLPD(K_EstimateLLPD+1,:)-EigVals_LLPD(K_EstimateLLPD,:)==max(EigVals_LLPD(K_EstimateLLPD+1,:)-EigVals_LLPD(K_EstimateLLPD,:)));
    catch 
        keyboard
    end
        if ComparisonOpts.RunEucSC
        K_Euc = K;
        SigmaIndexEuc = find(EigVals_Euc(K_EstimateEuc+1,:)-EigVals_Euc(K_EstimateEuc,:)==max(EigVals_Euc(K_EstimateEuc+1,:)-EigVals_Euc(K_EstimateEuc,:)));
    end
end

if SpectralOpts.RowNormalization==0
    Labels_LLPD_SC=kmeans(real(EigVecs_LLPD(:,1:K_LLPD,SigmaIndexLLPD)),K_LLPD,'Replicates',SpectralOpts.NumReplicates);
elseif SpectralOpts.RowNormalization==1
    Labels_LLPD_SC=kmeans(normr(real(EigVecs_LLPD(:,1:K_LLPD,SigmaIndexLLPD))),K_LLPD,'Replicates',SpectralOpts.NumReplicates);
end
Labels_LLPD_SC_FullData = zeros(size(X,1),1);
Labels_LLPD_SC_FullData(Idx_Retain) = Labels_LLPD_SC;
if size(X,2)==2
    figure
    scatter(X(Idx_Retain,1),X(Idx_Retain,2),[],Labels_LLPD_SC,'filled')
    title('Data Labeled by LLPD SC','fontsize',16)
end
    
if ComparisonOpts.RunEucSC==1
   if SpectralOpts.RowNormalization==0 
       Labels_EuclideanSC=kmeans(real(EigVecs_Euc(:,1:K_Euc,SigmaIndexEuc)),K_Euc,'Replicates',ComparisonOpts.EucSCNumReplicates); 
   elseif SpectralOpts.RowNormalization==1
       Labels_EuclideanSC=kmeans(normr(real(EigVecs_Euc(:,1:K_Euc,SigmaIndexEuc))),K_Euc,'Replicates',ComparisonOpts.EucSCNumReplicates);
   end
   Labels_EuclideanSC_FullData = zeros(size(X,1),1);
   Labels_EuclideanSC_FullData(Idx_Retain) = Labels_EuclideanSC;  
   if size(X,2)==2
       figure
       scatter(X(Idx_Retain,1),X(Idx_Retain,2),[],Labels_EuclideanSC,'filled')
       title('Data Labeled by Euclidean SC','fontsize',16)
   end
end

if ComparisonOpts.RunKmeans==1
    [Labels_Kmeans,Centroids_Kmeans]=kmeans(X(Idx_Retain,:),K_LLPD,'Replicates',SpectralOpts.NumReplicates);
    Labels_Kmeans_FullData = zeros(size(X,1),1);
    Labels_Kmeans_FullData(Idx_Retain) = Labels_Kmeans;
    if size(X,2)==2
        figure
        scatter(X(Idx_Retain,1),X(Idx_Retain,2),[],Labels_Kmeans,'filled')
        title('Data Labeled by K-means','fontsize',16)
    end    
end

%% Get accuracies if Labels are available

if exist('LabelsGT')
    
    % Define confusion matrix:
     M = confusionmat(LabelsGT(Idx_Retain),Labels_LLPD_SC);
     ClusterCounts = M(any(M,2),any(M,1));

    LabelsGT_Retained=LabelsGT(Idx_Retain);
    [OA_LLPD_SC,AA_LLPD_SC,Kappa_LLPD_SC]=GetAccuracies(Labels_LLPD_SC(LabelsGT_Retained>0),LabelsGT_Retained(LabelsGT_Retained>0),K_LLPD);

    if ComparisonOpts.RunKmeans==1
        [OA_Kmeans,AA_Kmeans,Kappa_Kmeans]=GetAccuracies(Labels_Kmeans(LabelsGT_Retained>0),LabelsGT_Retained(LabelsGT_Retained>0),K_LLPD);
    end

    if ComparisonOpts.RunEucSC==1
        [OA_EuclideanSC,AA_EuclideanSC,Kappa_EuclideanSC]=GetAccuracies(Labels_EuclideanSC(LabelsGT_Retained>0),LabelsGT_Retained(LabelsGT_Retained>0),K_Euc);
    end
    
end

%% Plot Multiscale Eigenvalues LLPD SC:

if length(Sigma_LLPD) > 1
    if isempty(NewIndexLLPD)
        figure
        plot(Sigma_LLPD,real(EigVals_LLPD(1,:)),'linewidth',2)
        hold on
        xlim([min(Sigma_LLPD) max(Sigma_LLPD)])
        ylim([-.1 1.1])
        for i=2:SpectralOpts.NumEig
            plot(Sigma_LLPD,real(EigVals_LLPD(i,:)),'linewidth',2);
        end
    else
        figure
        plot(Sigma_LLPD(NewIndexLLPD),real(EigVals_LLPD(1,NewIndexLLPD)),'linewidth',2)
        hold on
        xlim([min(Sigma_LLPD(NewIndexLLPD)) max(Sigma_LLPD(NewIndexLLPD))])
        ylim([-.1 1.1])
        for i=2:SpectralOpts.NumEig
            plot(Sigma_LLPD(NewIndexLLPD),real(EigVals_LLPD(i,NewIndexLLPD)),'linewidth',2);
        end
    end
    title('Multiscale Eigenvalues for LLPD SC','fontsize',16)
end

% Plot Multiscale Eigenvalues Euc SC:
if ComparisonOpts.RunEucSC == 1
    if length(Sigma_Euc)>1
        if isempty(NewIndexEuc)
            figure
            plot(Sigma_Euc,EigVals_Euc(1,:),'linewidth',2)
            hold on
            xlim([min(Sigma_Euc) max(Sigma_Euc)])
            ylim([-.1 1.1])
            for i=2:ComparisonOpts.EucSCNumEig
                plot(Sigma_Euc,real(EigVals_Euc(i,:)),'linewidth',2);
            end
        else
            figure
            plot(Sigma_Euc(NewIndexEuc),real(EigVals_Euc(1,NewIndexEuc)),'linewidth',2)
            hold on
            xlim([min(Sigma_Euc(NewIndexEuc)) max(Sigma_Euc(NewIndexEuc))])
            ylim([-.1 1.1])
            for i=2:ComparisonOpts.EucSCNumEig
                plot(Sigma_Euc(NewIndexEuc),real(EigVals_Euc(i,NewIndexEuc)),'linewidth',2);
            end
        end
        title('Multiscale Eigenvalues for Euc SC','fontsize',16)
    end
end
