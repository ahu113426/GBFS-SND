function [featidx] = newtry_ms(inputAdj,THRESHOLD, pop, times)
%NEWTRY 
%用k近邻方法简化网络
%然后用NSGA2编码节点，找到一个最优的特征网络，产生特征子集
global trData trLabel teData teLabel;
global  featNum kNeigh;


V_f = featNum*kNeigh;
if nargin < 3
    pop = 20;
    times = 40;
end

templateAdj = inputAdj;
% templateAdj(templateAdj<THRESHOLD) = 0;

% chromes = en_nsga_2(pop,times,templateAdj);  % 双种群
% chromes = en_nsga_2_mating_strategy(pop,times,templateAdj); % 一半精度
chromes = Copy_of_en_nsga_2_mating_strategy(pop,times,templateAdj,V_f); % 前沿面

[m,n] = size(chromes(:,1:end-2));


 % 取解策略
alpha = 0.9; % 精度权重，为0表示不考虑精度，1表示只考虑精度
fits = alpha.*abs(chromes(:,end-1))+...
    (1-alpha).*(1-chromes(:,end)./n);
selected = find(fits==max(fits));
idx = selected(1,:);
featidx = chromes(idx,1:end-2);

% feature = logical(chromes(:,1:end-2));
% for i = 1:1:m
%     knnModel = fitcknn(trData(:,feature(i,:)), trLabel, 'NumNeighbors', 5);
%     predLabel = predict(knnModel, teData(:,feature(i,:)));
%     acc(i,:) = sum(predLabel==teLabel)/length(teLabel);
% end
% check = [chromes(:,end-1:end),acc];
% sprintf('选择的最佳：%.2f  %d', abs(chromes(idx,end-3)), chromes(idx,end-2))
end
