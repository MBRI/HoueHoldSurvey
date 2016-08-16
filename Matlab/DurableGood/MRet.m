function [Result]=MRet(X,Y,Fname,tnam,Quarter)
% this would extract the Season of moraje
% to do;
%   X=Housholds address
%   Y=year
%   Fname is the file name and address
%   tnam is from init1
%   Quarter: 0 for monthly and 1 for quarterly, default is 1
%   Result is a data set
% for example after exracting data from houshold micro data of 1380, save it to
% a dataset variable like M, then use the command
% A=MRet(M.Address,80)
% A.Address is assighn to X
% A.MahMorajeh is the season when houshold  fullfill the quastinaries

if ~exist('Quarter','var')
    Quarter=1;
end

if nargin<4
    Y=X;
end

if Y<87
    if ~isa(X,'cell')
        error('I Feed by cell');
    end
    % Appoint which character shows the season
    if Y>76
        Ctr=6 ;
    elseif Y>62
        Ctr=4;
    end
    Result=cellfun(@(x)x(Ctr),X, 'UniformOutput' , false);
    Result=dataset(X,Result);
    %Result.Properties.VarNames{1} = 'Address';
    %Result.Properties.VarNames{2} = 'MahMorajeh';
    
elseif Y<92
     [~, ~, Result] = readacc( Fname,tnam(1:3));  % Read Access File
else
     [~, ~, Result] = readacc( Fname,[tnam(1:3) 'Data']);  % Read Access File
     Result=Result(:,{'Address' 'MahMorajeh'});
end

    disp('Load MaheMoraje Done' );
    %this the number of Cost table for the year between 1386:1391
    Oo=0; %M_tp(14);RsName(0,M_tp);
    Ss=Result.Properties.VarNames{size(Result,2)+Oo};% find the Header of the Golden Col
    Result.(Ss)=cell2num(Result.(Ss));
    Result.Properties.VarNames{1} = 'Address';
    Result.Properties.VarNames{2} = 'MahMorajeh';

    
if Y>86 && Quarter==1 %convert month to season
    Result.MahMorajeh= ceil(Result.MahMorajeh/3);
end

Result=unique(Result,'Address');
end