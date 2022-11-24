clear
clc

 matDir = ['C:\Users\BIMK\Desktop\GBFS（十折）11.20\1'];
if ~exist(matDir,'dir')
    mkdir(matDir);
end
for i=1:14%23%21%[13,14,15,16,18,19,20]
    [PP,datasetname,Ptop]=runn(i);
    ACC=cell2mat(PP(1:end-2,[1,2,4]));
    ACC_m=cell2mat(PP(end-1,[1,2,4]));
    ACC_s=cell2mat(PP(end,[1,2,4]));
    selectfeat=PP(:,3);
    matName = [matDir,'\',num2str(datasetname),'.mat'];
    save(matName,'ACC','ACC_m','ACC_s','selectfeat','Ptop');
end