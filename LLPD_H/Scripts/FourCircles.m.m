clear all;
n=2500; % number of points that you want

 radius = 1.7; % radius of the circle
 angle = 2*pi*rand(n,1);
 A=rand(10000,2);
for i=1:99
     center1 = [1,3];
    r1 = radius*sqrt(rand(n,1));
    X_1 = r1.*cos(angle)+ center1(1);
    Y_1 = r1.*sin(angle)+ center1(2);

    center2 = [1,5];
    r2 = radius*sqrt(rand(n,1));
    X_2 = r2.*cos(angle)+ center2(1);
    Y_2 = r2.*sin(angle)+ center2(2);
 
     center3 = [1,7];
    r3 = radius*sqrt(rand(n,1));
    X_3 = r3.*cos(angle)+ center3(1);
    Y_3 = r3.*sin(angle)+ center3(2);

    center4 = [5,5];
    r4 = radius*sqrt(rand(n,1));
    X_4 = r4.*cos(angle)+ center4(1);
    Y_4 = r4.*sin(angle)+ center4(2);
 
    X=vertcat(X_1,X_2,X_3,X_4);
    Y=vertcat(Y_1,Y_2,Y_3,Y_4);
    A=horzcat(A,X,Y);
end;
%   %A(:,200)=100*rand(1000,1); %% 1
 
  
  
  
addpath(genpath( 'C:\Users\zhang\Desktop\LLPD-master\LLPD-master\LLPD\LLPD_SpectralClustering'));
X=A;
SetDefaultParameters
 
 DenoisingOpts.Method='None';
 LLPDopts.KNN = 2000; %Number of nearest neighbors in underlying graph
 SpectralOpts.SigmaScaling = 'Automatic';
 
 ComparisonOpts.RunEucSC = 1;
 ComparisonOpts.EucSCSigmaScaling = 'Automatic'; 
% 
% 
% 
% 
 GeneralScript_LLPD_SC
 
 figure;
 scatter(X(Idx_Retain,3),X(Idx_Retain,4),[],Labels_EuclideanSC_FullData,'filled')
 figure;
 scatter(X(Idx_Retain,3),X(Idx_Retain,4),[],Labels_LLPD_SC_FullData,'filled')
%  
 