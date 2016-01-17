function [CC]=codeI(Y,r,Fname)
% Return Cost element. for the year Y in r area,
% r=0 is rural
% r=1 is urban
[M_tp, Rg, tnam]=init1(Y,r,0); % initial Value
disp(['Loading Data from ' num2str(Y) ' in ' Rg]);
CC=dataset({''}); %Data Collector will vanish after the end
CC.Properties.VarNames{1} = 'Address';
%%
for i=1:M_tp
    if Y<84
        nm=num2str(i);
    else
        nm=init2(i);
    end
    
    try
        
        [~, ~, Data] = readacc( Fname,[tnam  nm]);  % Read Access File
        
    catch %#ok<CTCH>
        continue;
    end
    disp(['Load '  tnam  nm ' Done' ]);
    %{
    convert to num
    %}
    
    %Ss=Data.Properties.VarNames{end+Oo};% find the Header of the Golden Col
    % there were many error in original Data come from human mistakes which
    % entered the Unknown charachter among the Data two line below remove such
    % data by 0 but may cuase reduce speed
    Oo=size(Data,2);
    Data.Properties.VarNames{1}='Address';
    for o=2:Oo
        if Y==69 && i==1 && o>5
            switch o
                case 6
                    TabelNameCorrec=0;
                case 7
                    TabelNameCorrec=1;
                case 8
                    TabelNameCorrec=2;
                case 9
                    TabelNameCorrec=3;
                otherwise
                    TabelNameCorrec=-1;
            end
            
        else
            TabelNameCorrec=-1;
        end
        Ss=['Y' tnam(2:end)  nm '_Col' num2str(o+TabelNameCorrec)];
        Data.Properties.VarNames{o}=Ss;
        Data.(Ss)=cell2num(Data.(Ss));
    end
    clear Ss
    
    
    %%
    % Remove Nan in Address
    Data(cellfun(@(x) any(isnan(x)),Data.Address),:)=[];
    % in 1374 the address 00010001 becames 00
    if Y==74
        Data.Address=cellfun(@filladdress,Data.Address,'uniformoutput',false);
    end
    Data=grpstats(Data,'Address',@sum,'VarNames',Data.Properties.VarNames(2:end)); % Income summation  for every households
    Data.GroupCount=[];%remove useless col
    Data.Properties.ObsNames=[];
%     for o=2:Oo % Remove sum_ from the begining of header
%         Data.Properties.VarNames{o}=Data.Properties.VarNames{o}(5:end);
%     end
%     
    %------------------------------------------------------
    CC = join(CC,Data,'key','Address','Type','outer','MergeKeys',true); %add to data collector
    clear Data;
    if i==1 % delete the '' from the first row
        CC(1,:)=[];
    end
end
%% fill Nan With zeo
Oo=size(CC,2);
for o=2:Oo
    Ss=CC.Properties.VarNames{o};
    Aa=isnan(CC.(Ss));
    CC.(Ss)(Aa)=~Aa(Aa);
    %Data.(Ss)=cell2num(Data.(Ss));
end

%%
% catch th parameter mahe morajee
CC = join(CC,MRet(CC.Address,Y,Fname,tnam),'key','Address','Type','outer','MergeKeys',true); %add to data collector
%%

aa=sum(isnan(double(CC(:,2:end))),2); %remove nan
CC(aa>1,:)=[]; % 1 is set to avoid noise
CC.Region=r*ones(size(CC,1),1);

disp('Cost Done');
end

function Y=filladdress(x)
% it is just happen in year 1374
if length(x)<4
    Y='00010001';
else
    Y=x;
end
end
