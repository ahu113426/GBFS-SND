function [outFac,LCglobal] = globalCenter(coeff,CmtyNew)
%GLOBALCENTER 此处显示有关此函数的摘要
%   此处显示详细说明
[dotLink,cmLinkC,cmLinkW] = globalLink(CmtyNew, coeff);

cmaw = cmLinkW./cmLinkC;
cmaw(isnan(cmaw)) = 0;
LCglobal = zeros(size(CmtyNew));
cmCenter = NodeCenter2(squareform(cmaw) ,ones(1,max(CmtyNew)));
for i = 1:1:max(CmtyNew)
    LCglobal(1,CmtyNew==i) = cmCenter(1,i);

end
    if size(LCglobal,2)~= size(coeff,2)
        error('出错');
    end
    %
    if any(isnan(LCglobal))
        error('全局权重出现Nan');
% LCglobal(isnan(LCglobal)) = 1;%孤立社团
    end
    %
outFac = ones(1,size(dotLink,2));
Nzero = dotLink(3,:)~=0;
outFac(1,Nzero) = dotLink(2,Nzero)./dotLink(3,Nzero);
outFac(1,CmtyNew==0) = 0;
end

