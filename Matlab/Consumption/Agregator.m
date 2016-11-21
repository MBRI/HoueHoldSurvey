Adr='E:\MINE\GitHub\MBRI\HouseHoldSurvey\Matlab\DataLoader\out\';
A=[];
for i=69:93
   eval(['load(''' Adr num2str(i) '.mat'');']); 
   eval(['T=T' num2str(i) ';']);
   T=T(:,{'Total', 'HH' });
   T(any(isnan(double(T)),2),:)=[];
    A=[A;[sum(double(T)),i]];
  % A=grpstats(T,@);
end
A(:,4)=A(:,1)./A(:,2);