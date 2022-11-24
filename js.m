function product = js(dataIdx, DELT, OMEGA, RUNS)
%% 预处理
% clear;
% clc;
% data = rand(10,5);
% dbstop if error;
% clear;
%% 数据导入
% global zData disData label;
% conData = csvread('dataR2.csv',1);
% disData = csvread('data.csv',1);
% label = conData(:,end);
% datasetName = '测试';
% conData = conData(:,1:end-1);
% disData = disData(:,1:end-1);
% % disData = conData;

% DELT = 0.2; % 影响力阈值
% OMEGA = 2; % 社团最小特征数目
% dataIdx = 27; %[27,30,28,12,22,2,31,32]
[conData, label, datasetName] = inputdatasetXD(dataIdx);
disData = [];
[ACC, FNUM] = deal(zeros(RUNS, 1));
FSET = cell(RUNS+2,1);

%% 参数设置 数据划分
zData = mapminmax(conData',0,1)'; % 使用该函数注意转置
featNum = size(zData, 2);

THRESHOLD = 0.5; % 切边阈值

for Rtimes = 1:RUNS

    row = size(zData,1);    R = randperm(row);
    trIdx = zeros(row, 1);
    trIdx(R(1:round(row*0.7)),:) = 1;    
    teIdx = ~trIdx;
    trIdx = logical(trIdx);
    
    trData = zData(trIdx,:);trLabel = label(trIdx);
    teData = zData(teIdx,:);teLabel = label(teIdx);
    %% 普通相关性
    distanceParaAll = {'correlation','spearman'};
    totalRes = {'name','adjacency', 'adjMatrix','weightGarph'};

    for i = 1:size(distanceParaAll,2)
        adj = 1-pdist(trData', distanceParaAll{1,i}); % 转置以计算特征相关性    
        % 15年对权值矩阵做了归一化
        adj = abs(adj);
        adj = 1./(1+exp(-zscore(adj)));   
        Zout = squareform( adj);

        totalRes = [totalRes; {distanceParaAll{1,i},adj, Zout, cutAdjMatrix(Zout,THRESHOLD, 0)}];
    %     netplot(totalRes{i+1,2},1);
    end

    %% 社团检测
    N = size(totalRes,2);
    for i = 2:size(totalRes,1)
        COMTY = cluster_jl(totalRes{i,4}); % 鲁文
        totalRes{i,N+2} = COMTY;
        totalRes{i,N+1} = graph(totalRes{i,4});
    end
    totalRes{1,N+1} = 'globalGraph';
    totalRes{1,N+2} = 'community';
    N = N+2;
    %% 复现15年迭代
    % DELT = 0.2; % 影响力阈值
    % OMEGA = 2; % 社团最小特征数目

    CmtyOld = totalRes{2,6}.COM{1,end}; % 社团划分的最终输出（鲁文）
    CmtyNew = CmtyOld;

%     TV = Term2(conData(CVO.training,:)); % 项方差
%     TV = Term2(trData); % 训练集上的项方差
    [~,TV] = fisherScore(trData,trLabel);
%     TV = 1./(1+exp(-zscore(TV)));
    coeff = totalRes{2,4};

    clusterNotChanged = true;
    while (clusterNotChanged)

%         LC = NodeCenter2(totalRes{2,4}, CmtyNew); % 拉普拉斯中心度
        LClocal = NodeCenter2(coeff, CmtyNew); % 拉普拉斯中心度
        LClocal(isnan(LClocal)) = 1;
        [outFac,LCglobal] = globalCenter(coeff,CmtyNew);
        
        infFeat = TV.*(LClocal+outFac.*LCglobal);
        infFeat = 1./(1+exp(-zscore(infFeat)));
%         infFeat = TV.*LC;
    %     infFeat = sqrt(infFeat2);
        % 影响力infFeat低于阈值的特征，对应的社团位置0，准备从社团中删除
        finalSet = CmtyNew;
        finalSet(infFeat < 0.5) = 0;    

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
        CmtyChangeIdx = find(finalSetNum(:,2) >= OMEGA);

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

    %  统计特征结果
    selectedFeat.feature = find(CmtyNew~=0);
    selectedFeat.num = sum(CmtyNew~=0);

    totalRes{1,N+1} = 'selectedFeat';
    totalRes{2,N+1} = selectedFeat;
    N = N+1;

    %% 特征选择 评价
    % 只使用社团特征

    knnModel = fitcknn(trData(:,totalRes{2,N}.feature), trLabel, 'NumNeighbors', 5);
    predLabel = predict(knnModel, teData(:,totalRes{2,N}.feature));
    totalRes{1,N+1} = 'CMTYFitness';
    acc = sum(predLabel==teLabel)/length(teLabel);
    totalRes{2,N+1} = acc;
    N = N+1;
    %% 作图
    % for i = 2:size(totalRes,1)
    %     figure('Name',totalRes{i,1});
    % %     G = graph(totalRes{i,4});
    % %     plot(G,'Layout','force','EdgeLabel',G.Edges.Weight);
    %     plot(totalRes{i,5},'Layout','force');
    %     title(totalRes{i,1});
    % end

    %% 输出
    ACC(Rtimes) = acc;
    FNUM(Rtimes) = totalRes{2,7}.num;
    FSET{Rtimes} = totalRes{2,7}.feature;
end
ACC = [ACC; mean(ACC); std(ACC)];
FNUM = [FNUM; mean(FNUM); std(FNUM)];
product = [num2cell(ACC), num2cell(FNUM), FSET];


end % function js