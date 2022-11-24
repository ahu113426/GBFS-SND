function [ node_center_result ] = NodeCenter2( coeff,cluster )
% 计算每个节点的影响力，计算标准为简单的与自己相连的度比上整个自身社团的度
%coeff 为权值矩阵 cluster为社团划分的结果
    [~,column] = size(coeff);
    node_center_result = zeros(1,column);%存放每个节点的中心度
    
    cluster_count = max(cluster); %划分了多少个社团
    for i = 1:cluster_count     %从第一个社团开始计算其每个特征的影响力
       inter_cluster_node = [] ;%有哪些节点在同一个社团内部
        for j = 1:column
            if cluster(j) == i
                inter_cluster_node=[inter_cluster_node,j];  %找到了在同一个社团内部的节点
            end
        end
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

        el_cluster = trace(X) + 2*sum(sum(triu(W).^2));  %社团内部所含的总能量
        candidate = zeros(1,w_column);   %存放候选删除节点对所在社团的影响
        for w_i = 1:w_column             %计算如果删除某个节点后对社团的影响 
            delete_W = W ;
            delete_X = X ;
            delete_W (:,[w_i]) = [] ;
            delete_W ([w_i],:) = [] ;
            delete_X (:,[w_i]) = [] ;
            delete_X ([w_i],:) = [] ;
            
            el_dellete_node = trace(delete_X)+2*sum(sum(triu(delete_W).^2));
            
            candidate(w_i) = (el_cluster-el_dellete_node)/el_cluster ;
            
        end
        candidate(isnan(candidate)) = 1; %孤立节点
        candidate(candidate==0) = 1; %孤立社团
        candidate = 1./(1+exp(-zscore(candidate)));
        for result =1:w_column   %找到该社团所有节点的中心度
            node_center_result(inter_cluster_node(result)) = candidate(result);
        end
    end

end

