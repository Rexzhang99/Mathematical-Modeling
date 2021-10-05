function [value] = geoDist(startaddress,endaddress)

startaddress=char(startaddress);
endaddress=char(endaddress);

startaddress = regexprep(startaddress, ' ', '+');
endaddress = regexprep(endaddress, ' ', '+');
SERVER_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=';
queryUrl = sprintf('%s%s&destinations=%s',SERVER_URL, startaddress,endaddress);
queryUrl = sprintf('%s&key=%s', queryUrl, 'AIzaSyDn06hjcJEFz2HRfPI463e7oVIY5ZKGPss');

queryUrlContent=urlread(queryUrl);
value = jsondecode(queryUrlContent);
end
