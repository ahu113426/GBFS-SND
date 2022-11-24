function [TV] = Term2(dataset)
%TERM2 此处显示有关此函数的摘要
%   此处显示详细说明
[M,~] = size(dataset);
fAve = mean(dataset, 1);
TV = sum((dataset-fAve).^2)./M;
% 归一化
TV = 1./(1+exp(-zscore(TV)));

end

