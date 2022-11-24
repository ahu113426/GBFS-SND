function [product, T, datasetName,assiNum] = Copy_of_js_ms(dataIdx, delt, omega, RUNS)
%% 预处理
global DELT OMEGA;
DELT = delt;
OMEGA = omega;

global data label;
global trIdx ;
global featNum;
global Zout;
global vWeight vWeight1;
global kNeigh kNeiMatrix;
global trData trLabel teData teLabel;
global  kNeiZout 
global assiNumInside;
global Weight
global TTT TTTT
%% 数据导入
% dataIdx = 16;
[condata, label, datasetName] = myinputdatasetXD(dataIdx);
conData=condata(:,2:end);
[ACC, FNUM] = deal(zeros(RUNS, 1));
FSET = cell(RUNS+2,1);

assiNum = zeros(RUNS,1);

%% 参数设置 数据划分
zData = mapminmax(conData',0,1)'; % 使用该函数注意转置
data = zData;
% zData = zscore(conData);
featNum = size(zData, 2);

THRESHOLD = 0.5; % 切边阈值
T = zeros(RUNS,1);
kNeigh = 5;

for Rtimes = 1:RUNS
    
    fprintf('----第%d次--------\n',Rtimes );
    fprintf('     kNeigh=%d\n',kNeigh);
    assiNumInside = 0; %重置
    tic;

    row = size(zData,1);    R = randperm(row);
    trIdx = zeros(row, 1);
    trIdx(R(1:round(row*0.7)),:) = 1;    
    teIdx = ~trIdx;
    trIdx = logical(trIdx);
    
    trData = zData(trIdx,:);trLabel = label(trIdx);
    teData = zData(teIdx,:);teLabel = label(teIdx);
    

    
    [~,vWeight0] = fisherScore(trData,trLabel);% 全部特征上计算权重
    vWeight = 1+mapminmax(vWeight0,0,1); %% +1，确保不为0
    vWeight1=vWeight;
    %% 普通相关性

    adj = 1-pdist(trData', 'correlation'); % 转置以计算特征相关性
    adj(isnan(adj))=0;

    adj = abs(adj);
    Weight=squareform(adj);
%     adj = 1- adj;
%     adj = 1./(1+exp(-zscore(adj)));  
    Zout = squareform( adj);

    %=====================2019-12-12
    %增加的K近邻特征判断
    kNeiMatrix = zeros(featNum,kNeigh);
    kNeiZoutMode = zeros(size(Zout));
    
    for i = 1:size(Zout,1)
        [~,I] = sort(Zout(i,:),'descend');
        idx = I(1:kNeigh);   
        kNeiMatrix(i,:) = idx;
        kNeiZoutMode(i,idx) = 1;
    end
%     kNeiZoutMode=kNeiZoutMode+kNeiZoutMode';
    
    kNeiZout = Zout.*logical(kNeiZoutMode);
    kNeiAdj = squareform(kNeiZout);
    
    %=====================
    
%         coeff = cutAdjMatrix(Zout,THRESHOLD, 0);
    featIdx = newtry_ms(kNeiAdj, THRESHOLD,20,50); % 进化算法
%     netplot(totalRes{i+1,2},1);
%     save('C:\Users\BIMK\Desktop\SHIX\00001.mat','TTT','TTTT');
    %  统计特征结果
    selectedFeat.feature = find(featIdx~=0);
    selectedFeat.num = sum(featIdx~=0);

    %% 特征选择 评价
    % 只使用社团特征

    knnModel = fitcknn(trData(:,selectedFeat.feature), trLabel, 'NumNeighbors', 5);
    predLabel = predict(knnModel, teData(:,selectedFeat.feature));
    acc = sum(predLabel==teLabel)/length(teLabel);


    %% 输出
    ACC(Rtimes) = acc;
    FNUM(Rtimes,:) = selectedFeat.num;
    FSET{Rtimes,:} = selectedFeat.feature;
    
    T(Rtimes,1) = toc;
    assiNum(Rtimes,:) = sum(assiNumInside);
end
ACC = [ACC; mean(ACC); std(ACC)];
FNUM = [FNUM; mean(FNUM); std(FNUM)];
T = [T;mean(T);std(T)];
product = [num2cell(ACC), num2cell(FNUM), FSET,num2cell(T)]; %打包输出

assiNum = [assiNum; mean(assiNum); std(assiNum)];
end % function js