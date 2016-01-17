function A_InitIncomeLoader(StartYear,EndYear)
% extract defined personal Income All without any Concern
% output is an mat file
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
for Y=StartYear:EndYear
    [~, Fname]=init0(Y,0); % initial Value
    % augment Rural and urban datasets
    TT=vertcat(codeI(Y,0,Fname), codeI(Y,1,Fname));
    eval(['T' num2str(Y) '=TT;']);
    %export(TT,'XLSfile',['T' num2str(Y)]);
    save(['out\T' num2str(Y)],['T' num2str(Y)]);
    clear TT;
end
a=toc;
clc;
disp(['All Done in ' num2str(fix(a/60)) ':' num2str(a-60*fix(a/60))]);
clear a Fname Y;
