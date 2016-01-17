function II=B_DisposableIncomeGen(StartYear,EndYear)
%Load A_InitIncomeLoader output from \out\T*.mat
% Also it loads "IncomeCategories.xlsx" which is includ the weights of each
% Column
% output is an xls file in out\DisIncome.xlsx
tic;
if nargin==1
    EndYear=StartYear;
end
%{
% uncomment to see the browser and choose the access file
[FileName,PathName,~] = uigetfile('*.*');% get file location
Fname=[PathName FileName];
Y=str2double(FileName(1:2));
%}
%%
%the below code is ok just in my pc
% you have to change the address in init0.m
Cat=dataset('xlsfile','IncomeCategories.xlsx');
% Cat.TableName tables names
%Cat.Disposable==1 Weight for each
for Y=StartYear:EndYear
    load(['out\T' num2str(Y)]);
    eval(['TT=T' num2str(Y) ';']);
    eval(['clear T' num2str(Y)]);
    %export(TT,'XLSfile',['T' num2str(Y)]);
    tNu=size(TT,2); % Coulmn Number
    tNa=TT.Properties.VarNames; % Coulmns Name
    TT.Disposable=zeros(size(TT,1),1);
    TT.Year=ones(size(TT,1),1)*Y;
    for i=1:tNu
        ind=strcmp(Cat.TableName,tNa{i});
        if sum(ind)>0
            TT.(tNa{i})=TT.(tNa{i})*Cat.Disposable(ind);
            TT.Disposable=TT.Disposable+TT.(tNa{i});
            TT.(tNa{i})=[];
        end
        
    end
    %TT=grpstats(TT,'Address','sum', 'DataVars','Disposable','VarNames','Disposable');
    if exist('II','var')
        II=[II;TT];
    else
        II=TT;
    end
    clear TT;
end
a=toc;
clc;
export(II,'xlsfile','out\DisIncome.xlsx');
disp(['All Done in ' num2str(fix(a/60)) ':' num2str(a-60*fix(a/60))]);
clear a Fname Y;
