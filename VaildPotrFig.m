%% 所有数据集上不同策略精度
if ~exist('result', 'var'), load('resultofThreeMethods.mat');end

lgdtext = ({'  GMFS (original)',...
            '  GMFS (var_1)',...
            '  GMFS (var_2)'});
     
figure;
p1 = plot(result);
xticklabels({'Glass','Wine','Hepatitis','WDBC','Ionosphere',...
            'Sonar','Hill-Valley','Urban','Musk1','LSVT','Madelon'});
xtickangle(45);

xlabel('DataSets', 'FontSize',20);
ylabel('Accuracy', 'FontSize',20);
set(gca,'FontSize',12);

lgd = legend(lgdtext,'Location','northeast');
title(lgd,'Various interactive generation(s)')

grid on
ax = gca;
ax.GridLineStyle='-.';

LinW = 2;
%1 Glass
style(1).LW = LinW;
style(1).LS = '--';
style(1).CL = 'k';
style(1).MK = 'p';
%2 Wine
style(2).LW = LinW;
style(2).LS = '-.';
style(2).CL = 'g';
style(2).MK = 'o';
%3 Hepatitis
style(3).LW = LinW;
style(3).LS = '-';
style(3).CL = 'k';
style(3).MK = 'd';

c = hsv(3*3);

for j = 1:1:3
    p1(j).LineWidth = style(j).LW;
%     pic(j).LineStyle = style(j).LS;
%     p1(j).LineStyle = ':';
%     pic(j).Color = style(j).CL;
    p1(j).Color = c(3*3-(j*3-1),:);
    p1(j).Marker = style(j).MK;
    
    p1(j).MarkerFaceColor = 'auto';
    p1(j).MarkerSize = 13;
end


figure
b = bar(result);
set(b,'edgecolor','none');
xticklabels({'Glass','Wine','Hepatitis','WDBC','Ionosphere',...
            'Sonar','Hill-Valley','Urban','Musk1','LSVT','Madelon'});
xtickangle(45);
axis([0.5 11.5 0.5 1]);

xlabel('DataSets', 'FontSize',20);
ylabel('Accuracy', 'FontSize',20);
set(gca,'FontSize',12);

lgd = legend(lgdtext,'Location','northeast');
title(lgd,'Various interactive generation(s)')