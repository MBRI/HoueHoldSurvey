function [Res Cat]=HCost(StartYear,EndYear)
% This Would Caculate House Buying cost
% Runner
tic;
%{
[FileName,PathName,~] = uigetfile('*.*');% get file location 
Fname=[PathName FileName];
Y=str2double(FileName(1:2));
%}

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
        X=codec(Y,1,Fname); % Just Urban 
      % X=vertcat(codec(Y,0,Fname),codec(Y,1,Fname));
      %{
      % the below  code temporary removed
        %mean th data
        R=MDT(X.Shahr,X.Rent);
       % if ~( Y==63 ||  Y==64 ||  Y==65 || Y==66 || Y==67  || Y==75  || Y==76  || Y==77) % for some resson we dont have the data
         P=MDT(X.Shahr,X.Price);
          %  end
        E=MDT(X.Shahr,X.Enshurance);
        
        % Weighting the data
        Res(Y-StartYear+1,1)=Y;
        Res(Y-StartYear+1,2)=sum(R.M.*weight(R.Shahr,Y));
        Res(Y-StartYear+1,3)=sum(P.M.*weight(P.Shahr,Y));
        Res(Y-StartYear+1,4)=sum(E.M.*weight(E.Shahr,Y));
       %} 
        %unweighted mean
        Q=dataset(X.MahMorajeh(X.Rent~=0),X.Rent(X.Rent~=0));
        Q=grpstats(Q,'Var1', @mean);
        Q.Properties.VarNames{1} = 'MahMorajeh';
        Q.Properties.VarNames{2} = 'RentCount';
        Q.Properties.VarNames{3} = 'Rent';
         Rest=Q;%join(Rest,Q,'key','MahMorajeh','Type','outer','MergeKeys',true);
        %Res(Y-StartYear+1,5)=mean(X.Rent(X.Rent~=0));
        Q=dataset(X.MahMorajeh(X.Price~=0),X.Price(X.Price~=0));
        Q=grpstats(Q,'Var1', @mean);
        Q.Properties.VarNames{1} = 'MahMorajeh';
        Q.Properties.VarNames{2} = 'PriceCount';
        Q.Properties.VarNames{3} = 'Price';
         Rest=join(Rest,Q,'key','MahMorajeh','Type','outer','MergeKeys',true);
        %Res(Y-StartYear+1,6)=mean(X.Price(X.Price~=0));
        Q=dataset(X.MahMorajeh(X.Enshurance~=0),X.Enshurance(X.Enshurance~=0));
        Q=grpstats(Q,'Var1', @mean);
        Q.Properties.VarNames{1} = 'MahMorajeh';
        Q.Properties.VarNames{2} = 'EnshuranceCount';
        Q.Properties.VarNames{3} = 'Enshurance';
             Rest=join(Rest,Q,'key','MahMorajeh','Type','outer','MergeKeys',true);
             Rest.Year=Y*ones(size(Rest,1),1);
        %Res(Y-StartYear+1,7)=mean(X.Enshurance(X.Enshurance~=0));
       
      %C=codep(Y,r,Fname);
       %       eval(['T' Rg num2str(Y) '= join(X, C,''key'',''Address'',''Type'',''outer'',''MergeKeys'',true);']);
      %  if  r==0
       %       TR= X;
      %  else
     %        TU= X;
    %    end
      
         %end
 if ~exist('Res','var')
     Res=Rest;
 else
    Res=vertcat(Res,Rest);
 end
   % TT=TU;
   
   % clear TR TU;
  %  TT.Year=Y*ones(size(TT.Address,1));
  %  disp('Exporting . . . ');
 %   export(TT,'XLSfile',['T' num2str(Y)]);
 %   eval(['T' num2str(Y) '=TT;']);
  % clear TT;
  
end
   disp('Exporting . . . ');
    export(Res,'XLSfile','Maskan');
    
 Cat=[  {'Year'}, {'WRent'}, {'WPrice'}, {'WEnsurance'} , {'Rent'}, {'Price'}, {'Ensurance'}];
a=toc;
clc;
disp(['All Done in ' num2str(fix(a/60)) ':' num2str(a-60*fix(a/60))]);
%clear a Fname Rg Y r;
