m=83;
n=86;
r=1;
A=linspace(1,m*n,m*n);
A=reshape(A,m,n);
B=zeros(m*n,m*n);
for e=1:m*n
    for i=0:r
        l1=max(e-i*m-r,1);
        r1=min(e-i*m+r,m*n);
        B(e,[l1:r1])=1;
        l2=max(e+i*m-r,1);
        r2=min(e+i*m+r,m*n);
        B(e,[l2:r2])=1;
    end
end
