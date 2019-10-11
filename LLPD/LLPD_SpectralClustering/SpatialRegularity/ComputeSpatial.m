function LLPD_S = ComputeSpatial(SpatialReg)
w=SpatialReg.Width;
h=SpatialReg.Height;
sigma=SpatialReg.Sigma;

    LLPD_S=zeros(w*h,w*h);
    
    if SpatialReg.R == 1
        r=SpatialReg.r;
        for e=1:w*h
            for i=0:r
                l1=max(e-i*w-r,1);
                r1=min(e-i*w+r,w*h);
                LLPD_S(e,[l1:r1])=1;
                l2=max(e+i*w-r,1);
                r2=min(e+i*w+r,w*h);
                LLPD_S(e,[l2:r2])=1;
            end
        end

    
    else
        for m = 1:w*h
            i1 = floor((m-1)/h);
            j1= mod(m-1,w);
            for n=1:w*h
                i2 = floor((n-1)/h);
                j2= mod(n-1,w);
                LLPD_S(m,n) = exp(-((i1-i2)^2 + (j1-j2)^2)/sigma.^2);
            end
        end
    
    end

end

