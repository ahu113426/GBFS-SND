function [f,featIdx_f] = initialize_variables_f(N, M, V, templateAdj)

K = M + V;
% kNeiZoutMode = zeros(size(squareform( templateAdj)));
f = randi([0,1], N, V); % f 为种群,V 为长度


% f = f.*logical(templateAdj).*templateAdj;

for i = 1 : N
    p = decodeNet(f(i,1:V),templateAdj); %01个体转化为网络表示
    [f(i,V + 1: K),featIdx_f(i,:)] = evaluate_objective_f(M, p);
end