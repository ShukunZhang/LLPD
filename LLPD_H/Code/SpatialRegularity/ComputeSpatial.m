function LLPD_S = ComputeSpatial(SpatialReg)
w=SpatialReg.Width;
h=SpatialReg.Height;
r=SpatialReg.r;
sz=[w h];
LLPD_S=zeros(w*h,w*h);


for e=1:w*h
    [e_row,e_col]=ind2sub(sz,e);
    r_left=max(1,e_row-r);
    r_right=min(w,e_row+r);
    c_left=max(1,e_col-r);
    c_right=min(h,e_col+r);
    for i=r_left:r_right
        for j=c_left:c_right
            r_c=sub2ind(sz,i,j);
            LLPD_S(e,r_c)=1;
        end
    end     
end
   
    
end

