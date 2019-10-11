function newLabels = MajorVote(X,L,MajorV)
    r=MajorV.Radius;
    v=MajorV.VoteRate;
    w=MajorV.Width;
    h=MajorV.Height;
   
    figure; imagesc(reshape(L,83,86));
    %give each unlabeled point a label by finding the nearest neighbor's L
    unLabeled_idx = find(L==0);
    labeled_idx = find(L~=0);
    
    
    A=zeros(w*h,2);
    for j=1:h
       for i=1:w
            A((j-1)*w+i,1)=i;
            A((j-1)*w+i,2)=j;
       end
    end
    Labeled=A(labeled_idx,:);
    unLabeled=A(unLabeled_idx,:);
    Idx=knnsearch(Labeled,unLabeled,'K',1);
    Idx=Labeled(Idx,1)+(Labeled(Idx,2)-1)*w;
     L(unLabeled_idx)=L(Idx);
%     Idx=knnsearch(X(labeled_idx),X(unLabeled_idx),'K',1);
%     L(unLabeled_idx)=L(Idx);
    

    L=reshape(L,w,h);
    
    figure; imagesc(L);
    newLabels=L;
    for i=1:size(L,1)
        m=zeros(1,length(unique(L)));

        for j=1:size(L,2)
            ii=max(1,i-r);
            fi=min(size(L,1),i+r);
            ij=max(1,j-r);
            fj=min(size(L,2),j+r);
            nbh=L([ii:fi],[ij:fj]);
            for idx = 1:numel(nbh)
                element=nbh(idx);
                m(element)=m(element) + 1;
            end
            [l,f] = mode(nbh(:));
            if f >= numel(nbh)* v
                newLabels(i,j)=l;
            end
        end
   
    end
    newLabels=reshape(newLabels,w*h,1);




end
