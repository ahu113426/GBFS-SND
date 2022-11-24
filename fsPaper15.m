function CmtyNew = fsPaper15(coeff,TV, CmtyOld, DELT, OMEGA)

CmtyNew = CmtyOld;

clusterNotChanged = true;
while (clusterNotChanged)

    LC = NodeCenter2(coeff, CmtyNew); % 拉普拉斯中心度
    infFeat = TV.*LC;
%     infFeat = sqrt(infFeat2);
    % 影响力infFeat低于阈值的特征，对应的社团位置0，准备从社团中删除
    finalSet = CmtyNew;
    finalSet(infFeat < DELT) = 0;    

    % 没有新的特征需要从上一代的社团中删除，说明社团不再变化
    if ~sum(finalSet-CmtyNew)
        clusterNotChanged = false;
        continue;
    end

    % 计算每个社团删减前后的特征数目
    CmtyNewNum = tabulate(CmtyNew);
    CmtyNewNum(CmtyNewNum(:,1) == 0,:) = [];        

    temp = tabulate(finalSet);
    clusertNum = size(CmtyNewNum,1);
    finalSetNum = cat(2,(1:clusertNum)', zeros(clusertNum,2)); % 根据CmtyNewNum重做finalSetNum，避免出现删除整个社团后统计为0的情况
    finalSetNum(nonzeros(temp(:,1)),:) = temp(temp(:,1)~=0,:);

    % 找到删除后特征数目大于阈值的社团索引
    CmtyChangeIdx = find(finalSetNum(:,2) > OMEGA);

    % 如果删除后没有一个社团中的特征数目大于阈值，说明社团不再变化
    if isempty(CmtyChangeIdx)
        clusterNotChanged = false;
        continue;
    end

    % 在需要做更改的社团中删除掉特征，其不属于任何社团
    CmtyOld = CmtyNew;
    for i = CmtyChangeIdx'
        featChangeIdx = CmtyOld == i;
        CmtyNew(featChangeIdx) = finalSet(featChangeIdx);
    end    

    % 判断是否和上次社团结构相比无变化，可以解决删除整个社团的情况
%   disp(~sum(CmtyOld-CmtyNew)); % for debug
    if ~sum(CmtyOld-CmtyNew)
        clusterNotChanged = false;
        continue;
    end
end

end