function [ term ] = Term( train_set )
    [data_row,data_column] = size(train_set);
         term = zeros(1,data_column);        %每个特征的项方差
         for i = 1:data_column
                a =sum(train_set(:,i)) ;
                feature_mean = mean(train_set(:,i));
            %sum / 行
                term(i) = sum((train_set(:,i)-feature_mean).^2); %先求每一位特征与均值的方差在求和，得这一项的方差
                term(i) = term(i)/data_row ;   %计算项方差
         end
end

