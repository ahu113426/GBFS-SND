function [product, T] = Copy_of_js(dataIdx, DELT, OMEGA, RUNS)
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
% zData = zscore(conData);
featNum = size(zData, 2);

THRESHOLD = 0.5; % 切边阈值
T = zeros(RUNS,1);
for Rtimes = 1:RUNS
    tic;

    row = size(zData,1);    R = randperm(row);
    trIdx = zeros(row, 1);
    trIdx(R(1:round(row*0.7)),:) = 1;    
    teIdx = ~trIdx;
    trIdx = logical(trIdx);
    
    trData = zData(trIdx,:);trLabel = label(trIdx);
    teData = zData(teIdx,:);teLabel = label(teIdx);
    %% 普通相关性
    distanceParaAll = {'correlation'};
    totalRes = {'name','adjacency', 'adjMatrix','weightGarph'};

%         [~,TV] = fisherScore(trData,trLabel);
%     TV = 1./(1+exp(-zscore(TV)));
    
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
    TV = 1./(1+exp(-zscore(TV)));
    coeff = totalRes{2,4};

%     R = 0.3;
%     K = round(featNum*R);
%     K = max(CmtyNew)*OMEGA; % 特征数=社团数*最小社团特征数
    sfNum = 0;
    sfCount = zeros(1,max(CmtyOld));
%     clusterNotChanged = true;
%     initEng = initNodeCenter2(coeff,CmtyOld);%社团初始能量
%     sfEng = zeros(1,max(CmtyOld));%已选特征在社团内的能量
    cmtyFulled = zeros(1,max(CmtyOld));%社团是否已选满
%     cmtyFulled(initEng==0) = 1;%单独点的社团直接选中
    
    tabu = tabulate(CmtyOld);
    aloneVecCom = tabu(tabu(:,2)==1)';
    cmtyFulled(aloneVecCom) = 1;
    for ai = aloneVecCom
        CmtyNew(CmtyNew==ai) = 0;
    end
    
    
    ratioEng = zeros(1,max(CmtyOld));% 代表/全部
    rEhold = 0.5;
    while (~all(cmtyFulled))

%         LC = NodeCenter2(totalRes{2,4}, CmtyNew); % 拉普拉斯中心度
        LClocal = NodeCenter2(coeff, CmtyNew); % 拉普拉斯中心度
%         LClocal(isnan(LClocal)) = 1; %孤立节点;应该
        [outFac,LCglobal] = globalCenter(coeff,CmtyNew);
        
        infFeat = TV.*(LClocal+outFac.*LCglobal);
%         infFeat = TV.*(LClocal.*outFac.*LCglobal);
%         infFeat = 1./(1+exp(-zscore(infFeat)));

        % 已满社团的影响力置0，这样就不会选到
        inftemp = infFeat;
        fulledidx = find(cmtyFulled~=0);
        for r = fulledidx
            inftemp(r==CmtyNew) = 0;
        end
        
        idseq = find(inftemp(:) == max(inftemp(:)));
        if length(idseq)>1
            error('2');
        end
%         id = randperm(length(idseq),1); %随机选一个。假设考虑用TV最高的，而不是用随机?
        id = randperm(length(idseq),1); %用TV最高的，而不是用随机

        
        updateCmtyIdx = CmtyNew(1,idseq(id));% 选中特征所对应的社团
        CmtyNew(1,idseq(id)) = 0;%选中idseq(id)个特征
        sfNum = sfNum+1; %特征数+1
        sfCount(updateCmtyIdx) = sfCount(updateCmtyIdx)+1;
        % 需要更新特征能量的特征索引
        fIdx = CmtyOld == updateCmtyIdx;
%         sfEng(updateCmtyIdx) = featEng(coeff(fIdx,fIdx),CmtyNew(fIdx));
%         ratioEng(updateCmtyIdx) = 1-sfEng(updateCmtyIdx)/initEng(updateCmtyIdx);
        ratioEng(updateCmtyIdx) = featEng(coeff(fIdx,fIdx),CmtyNew(fIdx));
        if ratioEng(updateCmtyIdx) >= rEhold
            cmtyFulled(updateCmtyIdx) = 1;
        end       


    end

    %  统计特征结果
    selectedFeat.feature = find(CmtyNew==0);
    selectedFeat.num = sum(CmtyNew==0);

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
    
    T(Rtimes,1) = toc;
end
ACC = [ACC; mean(ACC); std(ACC)];
FNUM = [FNUM; mean(FNUM); std(FNUM)];
product = [num2cell(ACC), num2cell(FNUM), FSET];


end % function js