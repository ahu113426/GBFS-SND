function [PP,name,Ptop]=runn(dataIdx)
% 尝试修改共享策略 branch:dev_tr_share
% global featMAXCG;
% global arNum;
% arNum = 0;
%% 初始化结果保存路径


global GAPGEN;
GAPGEN=5;
fileTime = now;
saveTime = datestr(fileTime, 'HH-MM-SS');

% baseDir = [pwd,'\',num2str(GAPGEN),'_GapGens','\',datestr(fileTime,'yyyy-mm-dd')];
baseDir = [pwd,'\',num2str(GAPGEN),'_GapGens'];
matDir = [baseDir,'\','data'];
pfDir = [baseDir,'\','pf'];

if ~exist(baseDir,'dir')
    mkdir(matDir);
    mkdir(pfDir);
end


%%
DELT = 0.2; % 影响力阈值


count = size(dataIdx,2);
PallRec = cell(count,1);
P = zeros(count*2,2);
AN = zeros(count*2,1);

pfSwithch = false; % 探查结果保存开关
% pfSwithch = true;
RUNS =30;
% d = setdiff([1:1:9],[9]);
for idx = [1]
    
    fprintf('正在处理第 %2d 个数据集....\n', idx);
    if pfSwithch,  profile on; end
    
        % p = js(dataIdx(idx),DELT, OMEGA(idx), RUNS);
%     [p,T,dataName] = Copy_of_js(dataIdx(idx),DELT, OMEGA(idx), RUNS);
    [p,T,dataName,assiNum] = Copy_of_js_ms(dataIdx(idx),DELT, 0, RUNS);
    PP=p;
    name=dataName;
    % p1 = testall(dataIdx(idx),RUNS);
    PallRec{idx,1} = p; % 历次结果记录
    AN(idx*2-1:idx*2,:) = assiNum(end-1:end,1); % 额外评价的解个数
    P(idx*2-1:idx*2,1:3) = cell2mat(p(end-1:end,[1,2,4])); % 均值方差
    time(idx,:) = T(end-1:end,1)'; % 时间均值方差

    if pfSwithch
        profile off; % profile viewer;
        pfName = [pfDir,'\', saveTime,'\', dataName];
        if (~exist(pfName,'dir')), mkdir(pfName); end
        profsave(profile('info'), pfName);
        profile clear;
    end
    
    clearvars p T dataName;
end
% 
% %% 解排序，提取优质解
% 
% if RUNS > 10
%     topK = 10; % 解多取前十
% else
%     topK = ceil(RUNS/2); % 取半
% end
% 
% topSolt = cell(size(PallRec));
% for i = 1:1:size(PallRec,1)
%     if isempty(PallRec{i,1}), topSolt{i,1} = []; continue; end
%     [~,tmpI] = sort(cell2mat(PallRec{i,1}(1:end-2,1)),'descend');
%     accTop = cell2mat( PallRec{i,1}(tmpI(1:topK),1));
%     featnTop = cell2mat( PallRec{i,1}(tmpI(1:topK),2));
%     featsTop = cell(topK+2,1);
%     featsTop(1:size(tmpI(1:topK),1),:) = PallRec{i,1}(tmpI(1:topK),3);
%     timeTop = cell2mat( PallRec{i,1}(tmpI(1:topK),4));
%     
%     ta = num2cell([accTop;mean(accTop);std(accTop)]);
%     tfn = num2cell([featnTop;mean(featnTop);std(featnTop)]);
%     tt = num2cell([timeTop;mean(timeTop);std(timeTop)]);
%     topSolt{i,1} = [ta, tfn, featsTop, tt];
%     
%     Ptop(i*2-1:i*2,1:3) = cell2mat(topSolt{i,1}(end-1:end,[1,2,4])); % 均值方差
% end
% 
% %% .mat文件保存代码
% 
% matName = [matDir,'\',saveTime,'.mat'];
% save(matName);
% alltime = sum(time(:,1))*RUNS;
% toptime = sum(Ptop([1:2:end],3))*topK;
% fprintf('结果已保存.\n%s\n', matName)
% fprintf('%d runs time: %.4f 秒\n', RUNS, alltime)
% fprintf('%d topK time: %.4f 秒\n', topK, toptime)

