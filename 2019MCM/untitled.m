l=1;
clear a;
for i=1:8
a(l:l+length(BadCountyData{i,1}.StateCountyName)-1,1)=BadCountyData{i,1}.StateCountyName ;
l=length(a);
end
tabulate(a);

plot(str2double(BadCountyData{i,1}.YYYY),BadCountyData{i,1}.TotalDrugReportsCounty,'.')