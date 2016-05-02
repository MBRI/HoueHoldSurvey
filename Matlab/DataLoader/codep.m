function [X89]=codep(Y,r,Fname)
% return the some houshold infomation
[~, Rg ,~]=init1(Y,r); % initial Value
disp(['Loading ' Rg num2str(Y) 'P1']);
%%

[~, ~, Data] = readacc( Fname,[Rg num2str(Y) 'P1']);           % open access file


%{
to ensure about cols' name
%}
if Y~=92
   Data.Properties.VarNames={'Address','DYCOL01','DYCOL03','DYCOL04','DYCOL05','DYCOL06','DYCOL07','DYCOL08','DYCOL09','DYCOL10'};
else
    Data.Properties.VarNames={'Address','DYCOL01','DYCOL02','DYCOL03','DYCOL04','DYCOL05','DYCOL06','DYCOL07','DYCOL08','DYCOL09','DYCOL10'};
    Data(:,'DYCOL02') = [];
end
Data.Region(:,1)=r;

%clear Du Dr;
Data.Year(:,1)=Y;
disp('Load Done');
%}
%convert to num: Just important cols
Data.DYCOL01=cell2num(Data.DYCOL01);
%Data.DYCOL03=str2num(cell2mat(Data.DYCOL03));
%Data.DYCOL04(strcmp(Data.DYCOL04,{''}))={'0'};
Data.DYCOL04=cell2num(Data.DYCOL04);
%Data.DYCOL05(strcmp(Data.DYCOL05,{''}))={'00'};
Data.DYCOL05=cell2num(Data.DYCOL05);
%Data.DYCOL06=str2num(cell2mat(Data.DYCOL06));
%Data.DYCOL07=str2num(cell2mat(Data.DYCOL07));
%Data.DYCOL08(strcmp(Data.DYCOL08,{'-'}))={'0'};
%Data.DYCOL08(strcmp(Data.DYCOL08,{''}))={'0'};
%Data.DYCOL08=str2num(cell2mat(Data.DYCOL08)); %#ok<*ST2NM>
%Data.DYCOL09=str2num(cell2mat(Data.DYCOL09));
%Data.DYCOL10=str2num(cell2mat(Data.DYCOL10));
%create Dataset
%Data = dataset(Data(2:end,1),[cell2mat(Data(2:end,2:end)) Data(1,2:end)] );
X89=Data(Data.DYCOL01==1,:);
X89.DYCOL01=[];
X89.DYCOL03=[];
X89.DYCOL06=[];
X89.DYCOL07=[];
X89.DYCOL09=[];
X89.DYCOL10=[];
%X89.DYCOL08(strcmp(strtrim(X89.DYCOL08),{'-'}))={'000'};
%X89.DYCOL08(strcmp(strtrim(X89.DYCOL08),{''}))={'000'};
%X89.DYCOL08(strcmp(X89.DYCOL08,{'31b'}))={'319'};
X89.DYCOL08=cell2num(X89.DYCOL08); %#ok<*ST2NM>
disp('count male and female');
ah =dataset(Data.Address,Data.DYCOL04);% dataset(Data(2:end,1),[cell2mat(Data(2:end,4)) Data(1,4)] );
ah.Properties.VarNames{1} = 'Address';
ah.Properties.VarNames{2} = 'DYCOL04';
%count mal and female
fm = join(grpstats(ah(ah.('DYCOL04')==1,1),'Address'),grpstats(ah(ah.('DYCOL04')~=1,1),'Address'),'key','Address','Type','outer','MergeKeys',true);
fm.Properties.VarNames{2} = 'male';
fm.Properties.VarNames{3} = 'female';
X89 = join(X89,fm,'key','Address','Type','outer','MergeKeys',true);
X89.male(isnan(X89.male))=0;
X89.female(isnan(X89.female))=0;
X89.HH=X89.male+X89.female;
X89.F_H=X89.female./X89.HH;
clear ah fm;
disp('count ages between 16-64');
% count ages 16-64
ag = dataset(Data.Address,Data.DYCOL05);%dataset(Data(2:end,1),[cell2mat(Data(2:end,5)) Data(1,5)] );
ag.Properties.VarNames{1} = 'Address';
ag.Properties.VarNames{2} = 'DYCOL05';
X89 = join(X89, grpstats(ag(and(ag.('DYCOL05')>15,ag.('DYCOL05')<65),1),'Address'),'key','Address','Type','outer','MergeKeys',true);
X89.Properties.VarNames{end} = 'B16_64';
X89.B16_64(isnan(X89.B16_64))=0;
X89.W_H=X89.B16_64./X89.HH;
%%%statarray =grpstats(ds,{'Sex','Smoker'},{'min','max'},'DataVars','Weight')%this is an example
clear ag aa Data;
% count education
disp('count education');
%%{
ed=dataset(X89.Address,X89.DYCOL08);
ed.Properties.VarNames{1} = 'Address';
ed.Properties.VarNames{2} = 'DYCOL08';
e1=grpstats(ed(ed.('DYCOL08')<=410,1),'Address');
%e1.Properties.VarNames{2} = 'UnderD';
e2=grpstats(ed(and(ed.('DYCOL08')==411,ed.('DYCOL08')==412),1),'Address');
%e2.Properties.VarNames{2} = 'Dipl';
e3=grpstats(ed(and(ed.('DYCOL08')==521,ed.('DYCOL08')==522),1),'Address');
%e3.Properties.VarNames{2} = 'Tech';
e4=grpstats(ed(and(ed.('DYCOL08')>=511,ed.('DYCOL08')<=513),1),'Address');
%e4.Properties.VarNames{2} = 'BS';
e5=grpstats(ed(and(ed.('DYCOL08')>=514,ed.('DYCOL08')<=516),1),'Address');
%e5.Properties.VarNames{2} = 'MS';
e6=grpstats(ed(and(ed.('DYCOL08')>=517,ed.('DYCOL08')<=606),1),'Address');
%e6.Properties.VarNames{2} = 'PHD';
try
    e1 = join(e1,e2,'key','Address','Type','outer','MergeKeys',true);
    e3 = join(e3,e4,'key','Address','Type','outer','MergeKeys',true);
    e5 = join(e5,e6,'key','Address','Type','outer','MergeKeys',true);
    e1 = join(e1,e3,'key','Address','Type','outer','MergeKeys',true);
    e1 = join(e1,e5,'key','Address','Type','outer','MergeKeys',true);
end
if size(e1,2)<2
    e1.UnderD=zeros(size(e1,1),1);
else
e1.Properties.VarNames{2} = 'UnderD';
end

if size(e1,2)<3
    e1.Dipl=zeros(size(e1,1),1);
else
e1.Properties.VarNames{3} = 'Dipl';
end

if size(e1,2)<4
    e1.Tech=zeros(size(e1,1),1);
else
e1.Properties.VarNames{4} = 'Tech';
end

if size(e1,2)<5
    e1.BS=zeros(size(e1,1),1);
else
e1.Properties.VarNames{5} = 'BS';
end

if size(e1,2)<6
    e1.MS=zeros(size(e1,1),1);
else
e1.Properties.VarNames{6} = 'MS';
end

if size(e1,2)<7
    e1.PhD=zeros(size(e1,1),1);
else
e1.Properties.VarNames{7} = 'PhD';
end

X89 = join(X89,e1,'key','Address','Type','outer','MergeKeys',true);
clear ed e1 e2 e3 e4 e5 e6;
X89.UnderD(isnan(X89.UnderD))=0;
X89.Dipl(isnan(X89.Dipl))=0;
X89.Tech(isnan(X89.Tech))=0;
X89.BS(isnan(X89.BS))=0;
X89.MS(isnan(X89.MS))=0;
X89.PhD(isnan(X89.PhD))=0;
%}
disp('Recognize province');
X89.Province=cellfun(@(x)x(2:3),X89.Address, 'UniformOutput' , false);
disp('Dummy for every province');
for i=0:35
    x=find(str2num(cell2mat(X89.Province))==i);
    X89.(['P' num2str(i)])(x,1)=1;
end
%------------------------------------------------------
%%
X89.Properties.VarNames{2} = 'Sex';
X89.Properties.VarNames{3} = 'Age';
X89.Properties.VarNames{4} = 'Education';
disp('Personal inf Done');
end