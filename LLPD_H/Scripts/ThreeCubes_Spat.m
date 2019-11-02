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


   
   
 figure; 
 scatter3(X(:,1),X(:,2),X(:,3),[],'filled');
   
%%

 
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
 
  imagesc(reshape(X(:,200),50,60));
 
addpath(genpath('../../LLPD_H'));
 SetDefaultParameters 
 DenoisingOpts.Method='None';
 
 %using spatial 
 LLPDopts.KNN = 1400; 
SpectralOpts.SigmaScaling = 'Manual';
SpectralOpts.SigmaValues = linspace(5, 500, 2);


% SpectralOpts.SigmaScaling = 'Automatic';
%  LLPDopts.KNN = 100; 

 SpatialReg.UseReg = 1;
 SpatialReg.Width = 50;
 SpatialReg.Height = 60;
 SpatialReg.Sigma = 19;
 SpatialReg.R=1;
 SpatialReg.r=30;
 MajorV.Use = 0;

 
 ComparisonOpts.RunEucSC = 0;
 ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
% 
% 
% 
% 
  GeneralScript_LLPD_SC
  %%
 %figure;
 % scatter3(X(:,1),X(:,2),X(:,3),[],Labels_EuclideanSC_FullData,'filled');
 % figure;
 % figure;scatter3(X(:,1),X(:,2),X(:,3),[],Labels_LLPD_SC_FullData,'filled');
  figure; imagesc(reshape(Labels_LLPD_SC_FullData,50,60));
  figure; imagesc(reshape(Labels_Kmeans_FullData,50,60));
%
