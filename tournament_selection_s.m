function [parent_s] = tournament_selection_s...
    (chromosome_f, chromosome_s, V_f,  V_s, featIdx, pool, tour)
%TOURNAMENT_SELECTION_S 此处显示有关此函数的摘要
%   此处显示详细说明

featIdx_obj = [featIdx,chromosome_f(:,V_f+1:V_f+2)];
featIdx_rank = non_domination_sort_mod(featIdx_obj, 2, size(featIdx,2));

ND1st_f = featIdx_rank(featIdx_rank(:,end-1)==1, :); % 特征网络的第一前沿面
ND1st_f_allNum = size(ND1st_f, 1); % 数目

if ND1st_f_allNum > floor(pool/2)
    fill_f_num = floor(pool/2);
    fill_f_chromosome = replace_chromosome(featIdx_rank, 2, V_s, fill_f_num);
else
    fill_f_num = ND1st_f_allNum;
    fill_f_chromosome = ND1st_f;
end

% fill_s_chromosome = replace_chromosome(chromosome_s, 2, V_s, pool-fill_f_num);
fill_s_chromosome = tournament_selection(chromosome_s, pool-fill_f_num, tour);
fill_s_chromosome = fill_s_chromosome(:,1:end-2);
fill_f_chromosome = fill_f_chromosome(:,1:end-2);
parent_s = [fill_s_chromosome;fill_f_chromosome];

end

