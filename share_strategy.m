function [offspring_chromosome_f2s,offspring_chromosome_s2f] = ...
    share_strategy(code,offspring_chromosome_f,offspring_chromosome_s,V_f,V_s,featIdx_f,M)

switch code

    case 1 % 全部
    temp_idx = featIdx_f;
    temp_s = offspring_chromosome_s;

    case 2 % 精英解
    ND_f = non_domination_sort_mod(offspring_chromosome_f, M, V_f);
    ND_s = non_domination_sort_mod(offspring_chromosome_s, M, V_s);

%     temp_idx = featIdx_f(ND_f(:,end-1)==1,:); % 仅选第一前沿面上的所有。
    ND_f_pop = ND_f(ND_f(:,end-1)==1,1:V_f);
    [ND_N,~] = size(ND_f_pop);
    for i = 1 : ND_N
        temp_idx(i,:) = get_first_front_pop(ND_f_pop(i,1:V_f));
    end
    temp_s = ND_s(ND_s(:,end-1)==1,:);
    
    case 3 % 交集                                                                                                              

    otherwise
        error("参数错误\n");
end

offspring_chromosome_f2s = f_2_s(temp_idx, M);
offspring_chromosome_s2f = s_2_f(temp_s(:,1:V_s), M);

end