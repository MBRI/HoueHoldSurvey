function C_RunMe(StartYear,EndYear)
% extract defined personal information and cost
% output is an mat file
tic;
if nargin==1
    EndYear=StartYear;
end
if ~exist('out','dir')
    mkdir ('out');
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
for Y=StartYear:EndYear
    [~, Fname]=init0(Y,0); % initial Value
    % augment Rural and urban datasets
    TT=vertcat(join(codec(Y,0,Fname), codep(Y,0,Fname),'key','Address','Type','outer','MergeKeys',true),join(codec(Y,1,Fname), codep(Y,1,Fname),'key','Address','Type','outer','MergeKeys',true));
    eval(['T' num2str(Y) '=TT;']);
    
    %export(TT,'XLSfile',['T' num2str(Y)]);
       clear TT;
    save(['out\' num2str(Y) '.mat'], ['T' num2str(Y)]);
 
end
a=toc;
clc;
disp(['All Done in ' num2str(fix(a/60)) ':' num2str(a-60*fix(a/60))]);
clear a Fname Y;
