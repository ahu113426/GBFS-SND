function select=featselect622(W)
 

global vWeight Weight;
featnum=size(vWeight,2);

W_v=vWeight';
A=W;
% A(A~=0)=1;
[X,Y]=eig(A);
lambda=diag(Y);
num=find(lambda==max(lambda));
V=X(:,num)';

V=V+vWeight;
select=[];
[~,I] = sort(V,'descend');
select=[select,I(1)];
i=2;
while(1)
    w=Weight(I(i),select);
    w = 1./(1+exp(-zscore(w)));
    if mean(w)<0.3
       select=[select,I(i)];
       i=i+1;
    else
        break;
    end
    if i==featnum
        break;
    end
end


% tic
% W=round(rand(2000,2000)*10);
% A=W;
% A(A~=0)=1;
% [X,Y]=eig(A);
% t=toc


