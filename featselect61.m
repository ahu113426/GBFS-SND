function select=featselect61(W)
global Weight vWeight
  %%
 featnum=size(W,2);
  FeatIdx=1:featnum;
  select=[];
  
%   load('C:\Users\BIMK\Desktop\周工作\MLP\2d2.mat')
%   W=kNeiWeight;

Z=sparse(W);
Z = tril(Z+Z');
%   view(biograph(Z,[],'ShowArrows','off','ShowWeights','on'))

[ST,pred] = graphminspantree(Z);

% view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

S=full(ST);
MinTree=S+S';
TreeA=MinTree;
TreeA(TreeA>0)=1;
D=sum(TreeA,1);
% Outlier=find(D==0);
% Outlier_num=size(Outlier,1);
% select=[select,FeatIdx(Outlier)];
V=vWeight;
while(1)
    Didx=find(D==1);
    if isempty(Didx)
        break;
    end
    Gain=V'.*W(:,Didx);
    V=V+sum(Gain,2)';
    D(Didx)=0;
%     X=find(D==1);
%     Y=size(X);
%     if Y==0
%         break;
%     end
end

[~,I] = sort(V,'descend');
select=[select,FeatIdx(I(1))];
i=2;
while(1)
    
    w=Weight(FeatIdx(I(i)),select);
    if mean(w)<0.3
       select=[select,FeatIdx(I(i))];
       i=i+1;
    else
        break;
    end
    if i==featnum
        break;
    end
end

