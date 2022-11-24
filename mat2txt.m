% clc
% clear
% load('Hillvalley.mat')
% % data = [LSVTvoicerehabilitation, LSVTvoicerehabilitationS1];
% data = [Hillvalley(:,1:end-1), Hillvalley(:,end:end)];  %[data  label]
dataIdx = 38;
[conData, label, datasetName] = inputdatasetXD(dataIdx);
A = [conData,label];
data = A;
fid = fopen('Urban.txt', 'wt');
for i = 1 : size(data, 1)
    for j = 1 : size(data, 2) - 1
        fprintf(fid,'%e   ',data(i, j));
    end
    fprintf(fid,'%e\n',data(i, size(data, 2)));
end
fclose(fid);
