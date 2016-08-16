clear
GG=dataset();
% for Y=63:93
%    load(['out\' num2str(Y) '.mat']);
%    eval(['TT= T' num2str(Y) ';'])
%    export(TT,'XLSfile',['Xlsf\T' num2str(Y)]);
%    eval(['clear TT T' num2str(Y)]);
%    disp([num2str(Y) ' has Done']);
% end

for Y=63:93
    load(['out\' num2str(Y) '.mat']);
    eval(['GG=[GG; T' num2str(Y) '(:,{''Address'',''Year'',''MahMorajeh'',''Total''})];'])
    eval(['clear T' num2str(Y)]);
    disp([num2str(Y) ' has Done']);
end
export(GG,'XLSfile',['Xlsf\TCons.xlsx']);
%  
