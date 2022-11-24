tempACC = [];
for j = 1:5
    Mdlknn = fitcknn(conData(CVO.training(j),:),label(CVO.training(j)),'NumNeighbors',1);MDL = Mdlknn;

    pLabel = predict(MDL, conData(CVO.test(j),:));
    acc = sum(pLabel == label(CVO.test(j)))/length(pLabel);

%     [rez, reo,fscore] = getRecall(pLabel, label(CVO.test(j)));
    tempACC = [tempACC;acc];
end
1-mean(tempACC)

Mdl = fitcknn(conData,label,'CVPartition',CVO, 'NumNeighbors',1);
Mdl.kfoldLoss