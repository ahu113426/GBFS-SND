% 编号	数据集名称	类别数	样本数	特征数
% 1     breast          2	683     10
% 2 	sonar           2	208     60
% 3     musk1           2	476     166
% 4     musk2           2	6598	166
% 5 	image           2	6500	18
% 6     HVwithnoise     2	1212	100     Hill_Valley_with_noise_full
% 7     titanic         2	750 	3
% 8     Spectf          2	267 	44
% 9     splice          2	5000	60
% 10	dna             2	3186	180
% 11	magic           2	19020	10
% 12	Ionosphere      2	351     34
% 13	german          2	1000	24
% 14	svmguide3       2	1243	22
% 15	protein         2	17766	357
% 16	madelon_train	2	2000	500
% 17	banana          2	5300	2
% 18	ecoli1          2	336     7
% 19	ecoli2          2	336 	7
% 20	ecoli3          2	336     7
% 21	magic           2	19020	10
% 22	spambase        2	4601	57
% 23	vehicle1        2	846 	18
% 24	vehicle2        2	846 	18
% 25	vehicle3        2	846     18
% 26	wisconsin       2	683     9
% 27	wine            3	178     13
% 28	wdbc            2	569 	30
% 29	australian      2	690     14
% 30	hepatitis       2	155     19
% 31	Arrhythmia      13	452     279
% 32	Colon           2	62      2000
% 33	glass           6	214     9
% 34    LSVT            2   120     309
% 35	HillValley          606     100
% 36    SCADI               70      206
% 37	Dermatology         366     34
% 38    Urban           9   168     148
% 39    Isolet5         26  1559	617

function [dataset,whether,datasetName]=inputdatasetXD(i)

%说明：函数根据输入的序号来读取相应的数据集，序号与数据集对应如上
%输入：i:所需要读取的数据集的序号
%输出：dataset:      读取的数据（样本数*属性）
%      whether:      读取出的数据标签（样本数*标签）
%      datasetName:  数据集的名称



switch i
    case 1  %   breast  683*10
       load('E:\dataset\breast.mat');
       dataset =  full(Xtr') ;
       whether =  Ytr'; 
       datasetName='breast';
              
    case 2  %   sonar   208*60
        load('E:\dataset\sonar.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';  
        datasetName = 'sonar';
         
    case 3  %   musk1   476*166
        fid = fopen('E:\dataset\musk1\clean1\clean1.data','r');
        juzhen=textscan(fid,'%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2));
        whether=whether';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        fclose(fid);
        datasetName = 'musk1';
        
    case 4  %   musk2   6598*166
        fid = fopen('E:\dataset\musk1\clean2\clean2.data','r');
        juzhen=textscan(fid,'%*s%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2));
        whether=whether';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        fclose(fid);
        datasetName = 'musk2';  
        
    case 5  %   image   6500*18
        load('E:\dataset\image.mat');
        dataset = X' ;
        whether =   Y';        
        datasetName = 'image';
        
    case 6  %   Hill_Valley_with_noise_full     1212*100
        fid = fopen('E:\dataset\hillvalley\Hill_Valley_with_noise_full.data','r');
        juzhen=textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2):size(dataset,2));
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        whether=whether';
        fclose(fid);
        datasetName = 'Hill_Valley_with_noise_full';
 
   case 7  %   titanic   750*3
         load('E:\dataset\titanic.mat');
         dataset = X' ;
         whether =  Y';          
         datasetName = 'titanic';
        
    case 8  %   Spectf  267*44
        fid = fopen('E:\dataset\xxs\V6 Spectf.txt','r');
        juzhen=textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter', ',');
        dataset=cell2mat(juzhen);
        whether=dataset(:,size(dataset,2));
        whether=whether';
        dataset=dataset(:,1:size(dataset,2)-1);
        dataset=dataset';
        fclose(fid);
        datasetName = 'Spectf';
        
   case 9   %   splice  5000*60
       load('E:\dataset\splice.mat');
       dataset = X' ;
       whether =  Y'; 
       datasetName = 'splice';
       
   case 10 %    dna    3186*180
       load('E:\dataset\dna.mat');
       dataset =  instance' ;
       whether =  label'; 
       datasetName = 'dna';
       
    case 11 %   magic   19020*10
        % function [dataset,whether]=inputdataset()
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,whethertemp] =textread('E:\dataset\magic.txt','%f%f%f%f%f%f%f%f%f%f%s','delimiter', ',');
        whethertemp=whethertemp';
        whether=zeros(1,size(whethertemp,2));
        for i=1:size(whethertemp,2)
            if whethertemp{i}=='g'
                whether(i)=1;
            else
                whether(i)=0;
            end
        end
        
        dataset=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10];
        dataset=dataset';
        datasetName = 'magic';
        % end
        
    case 12  %  Ionosphere  351*34
       load('E:\dataset\ionosphere.mat');
       dataset =  instance' ;
       whether =   label';  
       datasetName = 'ionosphere';
       
   case 13  %   german  1000*24
       load('E:\dataset\german.mat');
       dataset=  instance' ;
       whether =   label';         
       datasetName = 'german';
       
     case 14  %  svmguide3      1243*22
       load('E:\dataset\svmguide3.mat');
       dataset = instance' ;
       whether =   label';        
       datasetName = 'svmguide3';
       
    case 15  %  protein     17766*357
       load('E:\dataset\protein.mat');
       dataset = instance' ;
       whether =   label';        
       datasetName = 'protein';
   
    case 16  %  madelon_train   2000*500
       load('E:\dataset\madelon.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName = 'madelon_train';
       
    case 17  %  banana  5300*2
       load('E:\dataset\banana.mat');
       dataset = A(:,1:2)' ;
       whether =  A(:,end)'; 
       datasetName='banana';
       
    case 18  %  ecoli1  336*7
       load('E:\dataset\ecoli1.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName='ecoli1';
       
    case 19  %  ecoli2  336*7
       load('E:\dataset\ecoli2.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName='ecoli2';
       
    case 20  %  ecoli3  336*7
       load('E:\dataset\ecoli3.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)'; 
       datasetName='ecoli3'; 
       
    case 21  %  magic  19020*10
       load('E:\dataset\magic1.mat');
       dataset = A(:,1:end-1)' ; %于magic有区别，但名字没有区别
       whether =  A(:,end)';    
       datasetName='magic';
       
    case 22   %  spambase  4601*57
        load('E:\dataset\spambase.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';  %spambase.old样本数为4597
       datasetName='spambase';
       
    case 23   %  vehicle1  846*18
       load('E:\dataset\vehicle1.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName='vehicle1';
       
    case 24   %  vehicle2  846*18
       load('E:\dataset\vehicle2.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName='vehicle2';
       
    case 25   %  vehicle3  846*18
        load('E:\dataset\vehicle3.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';    
       datasetName='vehicle3'; 
       
    case 26   %  wisconsin  683*9
       load('E:\dataset\wisconsin.mat');
       dataset = A(:,1:end-1)' ;
       whether =  A(:,end)';  
       whether((whether==2))=0;%%负样本标签为0
       whether((whether==4))=1;%%正样本标签为1
       datasetName='wisconsin'; 
       
   case 27   %  wine  178*13
        load('E:\dataset\wine.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';    
        datasetName='wine'; 
        
   case 28   %  wdbc  569*30
        load('E:\dataset\wdbc.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';    
        datasetName='wdbc'; 

   case 29  %   australian   690*14
        load('E:\dataset\australian.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='australian';
        
   case 30  %	hepatitis	155*19
        load('E:\dataset\hepatitis.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='hepatitis';
        
    case 31     %	Arrhythmia	452*279
        load('E:\dataset\arrhythmia.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='arrhythmia';
        
    case 32     %   Colon   62*2000
        load('E:\dataset\colon.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='colon';
        
    case 33    %  glass  217*9
        load('E:\dataset\glass.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='glass';
        
    case 34     %   LSVT 126*309
        load('E:\dataset\LSVT.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='LSVT';
        
    case 35     %   HillValley 606*100
        load('E:\dataset\hillvalley.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='HillValley';
        
    case 36     %   SCADI 70*206
        load('E:\dataset\SCADI.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='SCADI';

    case 37     %   Dermatology 366*34
        load('E:\dataset\SCADI.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='Dermatology';
        
    case 38     %   Urban  168*148
        load('E:\dataset\Urban.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='Urban';
        
    case 39     %   Isolet5 1559*617
        load('E:\dataset\isolet.mat');
        dataset = A(:,1:end-1)' ;
        whether =  A(:,end)';
        datasetName='Isolet5';
        
    otherwise
            error('没有与 编号%d 对应的数据集.',i);
end % switch

if size(whether, 2)~=1
    dataset = dataset';
    whether = whether';
end

if size(dataset,1)~= size(whether,1)
    error('Error. 数据集和标签维度不一致.')
end

whether(whether==-1)=0; %对whether进行处理，把-1变为0
datasetName = cat(2,upper(datasetName(1)), lower(datasetName(2:end)));
end