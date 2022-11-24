function [ el_cluster ] = initNodeCenter2( coeff,cluster )
% 计算整个自身社团的能量
%coeff 为权值矩阵 cluster为社团划分的结果
%     [~,column] = size(coeff);
   
    cluster_count = max(cluster); %划分了多少个社团
    el_cluster = zeros(1,cluster_count);%存放每个社团的能量
    
    for i = 1:cluster_count     %从第一个社团开始计算其每个特征的影响力
%        inter_cluster_node = [] ;%有哪些节点在同一个社团内部
%         for j = 1:column
%             if cluster(j) == i
%                 inter_cluster_node=[inter_cluster_node,j];  %找到了在同一个社团内部的节点
%             end
%         end
        inter_cluster_node = find(cluster==i);%找到了在同一个社团内部的节点
        [~,w_column]=size(inter_cluster_node);  %社团内有几个点，产生一个多大的W （论文中的（2）W）
        W = zeros(w_column,w_column);
        X = W ;           %X为对角阵，为总度矩阵  论文中的(3)X
        for w_i = 1:w_column
            for w_j = 1:w_column
                W(w_i,w_j) = coeff(inter_cluster_node(w_i),inter_cluster_node(w_j));  %计算同一个社团内部的特征之间相关系数
            end
        end
        
        for w_i = 1:w_column
            X(w_i,w_i) = sum(W(w_i,1:w_column)); %计算总的度矩阵X为对角阵
        end

        el_cluster(i) = trace(X) + 2*sum(sum(triu(W).^2));  %社团内部所含的总能量

    end

end

