function [parent_f] = tournament_selection_f...
    (chromosome_f, chromosome_s, V_f,  V_s, featIdx, pool, tour)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

ND1st_s = chromosome_s(chromosome_s(:,end-1)==1, :); % 样本网络的第一前沿面
ND1st_s_allNum = size(ND1st_s, 1); % 数目

ND1st_s_Sum = sum(ND1st_s(:,1:V_s), 1); % 1st前沿面选择的特征统计

mostChooseIdx = ND1st_s_Sum > floor(ND1st_s_allNum/2);%如果所有特征都不足allNum/2?
if sum(mostChooseIdx)==0
    % 如果所有特征都不足allNum/2, 则使用标准为，出现频率最高的特征次数的一半
    mostChooseIdx = ND1st_s_Sum > floor(max(ND1st_s_Sum)/2);
end

featIdx_obj = [featIdx,chromosome_f(:,V_f+1:V_f+2)];
featIdx_rank = non_domination_sort_mod(featIdx_obj, 2, size(featIdx,2));

featIdx_temp = featIdx_rank(:,1:V_s);

interSectNum = sum(mostChooseIdx .* featIdx_temp, 2); % 交集,点乘是因为只有两者都为1（选中）的特征，对应位的乘积才为1
allSetNum = sum(featIdx_temp,2);

condition1_temp = interSectNum./allSetNum; % 交集占总数，越多（大）越好
condition2 = featIdx_rank(:,end-1); % 同一父代中非支配的层数,越小越好
condition1 = zeros(size(condition1_temp));

rank = sort(unique(condition1_temp), 'descend');
for i  = 1:1:size(rank,1)
    condition1(rank(i)==condition1_temp,:) = i;
end
chromosome_f_rank = [chromosome_f,condition1,-condition2]; % condition2取负，为了调用函数
f = replace_chromosome(chromosome_f_rank, 2, V_f+2, pool); % M=2 目标数
parent_f = f(:,1:end-2);
end

