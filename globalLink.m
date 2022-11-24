function [dotLink,cmLinkC,cmLinkW] = globalLink(Cmty,NodeMatrix)
%GLOBALWEIGHT 此处显示有关此函数的摘要
%   此处显示详细说明
%   输入：社团检测的输出（鲁文）
%       ：网络矩阵
%   输出：以社团为点的网络矩阵，值为社团间的权值

% CmtyNum = tabulate(Cmty);
comNum = max(Cmty);


%% 社团整体对外的连接
cmtyWeight = [];%
cmtyCount = [];
for i = 1:1:comNum % 第一个社团开始
    inodeIdx = find(Cmty(:,:)==i);
    
    for j = i+1:1:comNum % 与其他社团（不重复）
        
        jnodeIdx = find(Cmty(:,:)==j);
        outaction = NodeMatrix(jnodeIdx,inodeIdx);
        
        iNodeAllWeight = sum(outaction,1);
        iNodeAllCount = sum(outaction~=0,1);
        
        cmtyWeight = [cmtyWeight, sum(iNodeAllWeight)];
        cmtyCount = [cmtyCount, sum(iNodeAllCount)];
    end

end

%% 确定社团中点对外的连接
nodeweight = zeros(size(Cmty));
nodecount = zeros(size(Cmty));

for i = 1:1:comNum % 第一个社团开始
    inodeIdx = find(Cmty(:,:)==i);
    
    inner = 1:1:comNum;
    inner(inner==i) = [];
    for j = inner % 与其他社团
        
        jnodeIdx = find(Cmty(:,:)==j);
        outaction = NodeMatrix(jnodeIdx,inodeIdx);
        
        iNodeAllWeight = sum(outaction,1);
        iNodeAllCount = sum(outaction~=0,1);

    for k = 1:1:size(inodeIdx,2)
        nodeweight(inodeIdx(k)) = nodeweight(inodeIdx(k))+iNodeAllWeight(k);
        nodecount(inodeIdx(k)) = nodecount(inodeIdx(k))+iNodeAllCount(k);
    end
    
    end
end

dotLink = [Cmty;nodeweight;nodecount];
% ZZ = [];
% for i = unique(GWeight(1,:))
%     e = dotLink(3,dotLink(1,:)==i);
%     ZZ(i,:) = [i,sum(e)];
% end
% ZZ
% squareform(cmtyCount)
% cmLinkW = squareform(cmtyWeight);
% cmLinkC = squareform(cmtyCount);

cmLinkW = cmtyWeight;
cmLinkC = cmtyCount;
end

