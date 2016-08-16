%function [Res]=DCost(StartYear,EndYear)
% it is the main function
% This Would Caculate House Buying cost

tic;
StartYear=69
EndYear=93
%{
[FileName,PathName,~] = uigetfile('*.*');% get file location 
Fname=[PathName FileName];
Y=str2double(FileName(1:2));
%}
%{
%for iteration
%Y=76;
tic;
if nargin==1 
    EndYear=StartYear;
end
% check some thing
if StartYear>EndYear
    a=StartYear;
    StartYear=EndYear;
    EndYear=a;
    clear a;
end
if StartYear<63
    StartYear=63;
end
if StartYear>93
    StartYear=93;
end
if EndYear>93
    EndYear=93;
end
if EndYear<63
    EndYear=63;
end

%}

%
%Res(EndYear-StartYear+1,3)=0;
%Res=dataset();
%Res.MahMorajeh=0;
for Y=StartYear:EndYear

%if  Y==63 ||  Y==64 ||  Y==65 || Y==66 || Y==67  || Y==75  || Y==76  || Y==77 % for some resson we dont have the data
 %   continue;
%end
[~, Fname]=init0(Y,0); % initial Value
    %for r=0:1
        
        %[Rg, ~]=init0(Y,r); % initial Value
        X0=codec(Y,0,Fname);
        X0=grpstats(X0,{'MahMorajeh' 'Region' 'R8'},'sum','DataVars','Cost');
        X0.Properties.ObsNames =[];
        
        X1=codec(Y,1,Fname);
        X1=grpstats(X1,{'MahMorajeh' 'Region' 'R8'},'sum','DataVars','Cost');
        X1.Properties.ObsNames =[];
        % X=[codec(Y,0,Fname);codec(Y,1,Fname)]; 
        X=[X0;X1];
        X.Year=Y*ones(size(X,1),1);
        % X=grpstats(X,{'Year' 'MahMorajeh' 'Region' 'R8'},'sum','DataVars','Cost');
        %X.Properties.ObsNames =[];
 if ~exist('Res','var')
     Res=X;
 else
    Res=vertcat(Res,X);
 end
  
end
   disp('Exporting . . . ');
   export(Res,'XLSfile',['out\Dur' num2str(StartYear) '.xlsx']);
  
a=toc;
clc;
disp(['All Done in ' num2str(fix(a/60)) ':' num2str(a-60*fix(a/60))]);
%clear a Fname Rg Y r;
