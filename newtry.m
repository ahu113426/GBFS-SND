function [bestAdj] = newtry(inputAdj,THRESHOLD, pop, times)
%NEWTRY 
%用较低的阈值切分网络，去掉一部分相关性较低的边，简化网络
%然后用NSGA2编码节点，找到一个最优的特征网络，产生特征子集
%   此处显示详细说明
if nargin < 3
    pop = 20;
    times = 40;
end

templateAdj = inputAdj;
templateAdj(templateAdj<THRESHOLD) = 0;

% chromes = en_nsga_2(pop,times,templateAdj);  % 双种群
chromes = en_nsga_2_mating_strategy(pop,times,templateAdj);

[~,n] = size(squareform(chromes(1,1:end-4)));


alpha = 0.6;
fits = alpha.*abs(chromes(:,end-3))+...
    (1-alpha).*(1-chromes(:,end-2)./n);
selected = find(fits==max(fits));
idx = selected(1,:);
bestAdj = chromes(idx,1:end-4);

% sprintf('选择的最佳：%.2f  %d', abs(chromes(idx,end-3)), chromes(idx,end-2))
end

