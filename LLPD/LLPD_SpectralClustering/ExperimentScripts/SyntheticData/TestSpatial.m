addpath(genpath('/Users/shukunzhang/Desktop/Research/annavlittle-llpd_code-5d8ee720b9f2/LLPD_SpectralClustering'));


A=zeros(10,10);
for i=1:10
    for j=1:10
        A(i,j) = (i-1)*10 + j;
    end
end
B=reshape(A,100,1);


X=A;
SetDefaultParameters;
SpatialReg.Sigma = 1;
S=ComputeSpatial(SpatialReg);

%Todo:
% 1. In SetDefaultParameters, add SpetialReg parameters, (default)
% 2. try different parameters
% 3. add module in fastEigen, if ... else 
