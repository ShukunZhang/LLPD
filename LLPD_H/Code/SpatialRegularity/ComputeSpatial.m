function LLPD_S = ComputeSpatial(SpatialReg)
w=SpatialReg.Width;
h=SpatialReg.Height;
sigma=SpatialReg.Sigma;

    LLPD_S=zeros(w*h,w*h);
    
    if SpatialReg.R == 1
        r=SpatialReg.r;

        for e=1:w*h %for each data point
            q=floor(e/w); 
            R=[max(mod(e,w)-r,1):min(mod(e,w)+r,w)];
            for i=0:r
            % add the index of points with radius = i 
                idx_l=max((q-i),0)*w +R;
                idx_r=min((q+i),h)*w+R;
                LLPD_S(e,idx_l)=1;
                LLPD_S(e,idx_r)=1;
        
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

