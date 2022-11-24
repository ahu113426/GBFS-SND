% 不同策略散点图tsne 
% 展现效果不佳

%01 33	glass           6	214     9
%02 27	wine            3	178     13
%03 30	hepatitis       2	155     19
%04 28	wdbc            2	569 	30
%05 12	Ionosphere      2	351     34
%06 02 	sonar           2	208     60
%07 35	HillValley      2   606     100
%08 38  Urban           9   168     148
%09 03  musk1           2	476     166
%10 34  LSVT            2   120     309
%11 16	madelon_train	2	2000	500

%12 13	german          2	1000	24
%13 08  Spectf          2	267 	44
%14 04  musk2           2	6598	166
%15 39  Isolet5         26  1559	617
if ~exist('finalSet','var'), load('finalSet.mat');end

dataSeq = [33,27,30,28,12,...
           02,35,38,03,34,...
           16,13,08,04,39];

% featidx = topSolt{dataIdx, 1}{1,3};
dataIdx = 1;
[data, label, datasetName] = inputdatasetXD(dataSeq(dataIdx));

rng default;

numColors = numel(unique(label));
c = lines(numColors*2);
% ND = 3;
ND = 2;

for iter = 1:3
    figure;
    
    featidx = finalSet{dataIdx, iter};
    
    Y = tsne(data(:,featidx),...
        'Exaggeration',20,...
        'Perplexity',150,...
        'Standardize', true,...
        'LearnRate',1000,...
        'NumDimensions',ND);
    
%     Y = tsne(data,'Algorithm','barneshut','NumPCAComponents',50,'Exaggeration',20);

    if ND == 2
        gscatter(Y(:,1),Y(:,2),label,c(2:2:2*numColors,:),'.',25);
    elseif ND == 3
        scatter3(Y(:,1),Y(:,2),Y(:,3),25,label,'filled');
    end
%     axis off;
%     legend('hide');
end
% f2 = f1;