%     state=convertCharsToStrings(MCMNFLISDataS1.State);
% import data
[~, ~, MCMNFLISDataS1] = xlsread('/Users/rexzhang/Downloads/2019_MCM-ICM_Problems/2018_MCMProblemC_DATA/MCM_NFLIS_Data.xlsx','Data');
MCMNFLISDataS1 = MCMNFLISDataS1(2:end,:);

MCMNFLISDataS1 = string(MCMNFLISDataS1);
MCMNFLISDataS1(ismissing(MCMNFLISDataS1)) = '';
% search for location
FIPS_Combined=unique(MCMNFLISDataS1(:,6));

county=MCMNFLISDataS1(:,3);
county=strcat(county, " County");

state=MCMNFLISDataS1(:,2);
state=strrep(state,'OH','Ohio State');
state=strrep(state,'KY','Kentucky State');
state=strrep(state,'WV','WestVirginia State');
state=strrep(state,'PA','Pennsylvania State');
state=strrep(state,'VA','Virginia State');


StateCountyName=unique(strcat(state," ", county));
%连接Google Map API获取地点的经纬度数据
% for i=1:length(StateCountyName)
% %         for i=[209:274]
% %    i,StateCountyName(i)
%     [lng(i),lat(i),value(i)] = geoCode(StateCountyName(i),'AIzaSyDn06hjcJEFz2HRfPI463e7oVIY5ZKGPss');
% end
%CombinedGeoData = [StateCountyName FIPS_Combined lng' lat'] ;

%已经获取数据，直接导入
% Import the data
[~, ~, raw] = xlsread('/Users/rexzhang/Desktop/CombinedGeoData.xlsx','Sheet1');
stringVectors = string(raw(:,1));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[2,3,4]);
data = reshape([raw{:}],size(raw));
CombinedGeoData = table;
CombinedGeoData.StateCountyName = stringVectors(:,1);
CombinedGeoData.FIPS_Combined = data(:,1);
CombinedGeoData.lng = data(:,2);
CombinedGeoData.lat = data(:,3);
clearvars data raw stringVectors;


% array2table
MCMNFLISDataS1 =array2table(MCMNFLISDataS1,'VariableNames',{'YYYY','	State','	COUNTY','	FIPS_State','	r','	FIPS_Combined','	SubstanceName','	DrugReports	','TotalDrugReportsCounty','	TotalDrugReportsState'});
CombinedFinalData=outerjoin(MCMNFLISDataS1,CombinedGeoData);
% plot and record

% plot(str2double(CombinedFinalData.lng),str2double(CombinedFinalData.lat),'.r', 'MarkerSize', 20);
% h = scatter3(str2double(CombinedFinalData.lng),str2double(CombinedFinalData.lat),str2double(CombinedFinalData.TotalDrugReportsCounty));
% plot_google_map('MapScale', 1,'MapType','roadmap')

vedio = VideoWriter('test.avi'); %初始化一个avi文件
vedio.FrameRate = 1;
open(vedio);
maxTotalDrugReportsCounty=max(str2double(CombinedFinalData.TotalDrugReportsCounty));
BadCountyData=cell(8,1);
for j=2010:2017
    a=CombinedFinalData(CombinedFinalData.YYYY==num2str(j),{'YYYY','StateCountyName','TotalDrugReportsCounty','TotalDrugReportsState','lat','lng'});
    a.TotalDrugReportsCounty=str2double(a.TotalDrugReportsCounty);
    a.lat=a.lat;
    a.lng=a.lng;
    BadCountyData{j-2009}=sortrows(unique(a(a.TotalDrugReportsCounty>5000,:)),3,'descend') ;
    
    
%         figure
%         geobubble(figure,a.lat,a.lng,a.TotalDrugReportsCounty,'BubbleWidthRange',[1 20],'MapLayout','normal',...
%             'SizeLimits',[0 maxTotalDrugReportsCounty],'Basemap','grayland',...
%             'SizeLegendTitle','Maximum Reports in 2010-2017','Title',sprintf('%s%s','Total Drug Reports Graph of ',num2str(j))...
%             );
%     %     text(figure,BadCountyData{1, 1}.lat,BadCountyData{1, 1}.lng,BadCountyData{1, 1}.StateCountyName)
%         annotation(figure,'textbox',[0.798118847539015 0.598993288590604 0.177871548619448 0.216442953020134],'String',{'geobubble'},'FitBoxToText','on');
%     set(0,'DefaultFigureVisible', 'off')
    figure=createfigure(a.lat, a.lng, a.TotalDrugReportsCounty,BadCountyData{j-2009},j);
    
    saveas(figure,sprintf('%s%s%s','TotalDrugReportsCounty',num2str(j),'.png'));
    
    
    fname=strcat('TotalDrugReportsCounty',num2str(j),'.png');
    frame = imread(fname);
    writeVideo(vedio,frame);
end
close(vedio);

%统计2010-2017大于5000次毒品案的县的频数
l=1;

for i=1:8
lagthan5000name(l:l+length(BadCountyData{i,1}.StateCountyName)-1,1)=BadCountyData{i,1}.StateCountyName ;
l=length(lagthan5000name);
end
tabulate(lagthan5000name);





