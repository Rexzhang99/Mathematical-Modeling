function [lng,lat,value] = geoCode(address, key)

address=char(address);
if isempty(address) || ~ischar(address) || ~isvector(address)
    error('Invalid address provided, must be a string');
end

address = regexprep(address, ' ', '+');

SERVER_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
queryUrl = sprintf('%s%s',SERVER_URL, address);
if ~isempty(key)
    queryUrl = sprintf('%s&key=%s', queryUrl, key);
end
queryUrlContent=urlread(queryUrl);
value = jsondecode(queryUrlContent);
if length(value.results)<2 && ~isempty(value.results)
    lat=value.results.geometry.location.lat;
    lng=value.results.geometry.location.lng;
elseif isempty(value.results)
    lat=0;
    lng=0;
    warning('value.results is empty');
else
    lat=value.results{1, 1}.geometry.location.lat;
    lng=value.results{1, 1}.geometry.location.lng;
end
%         parseFcn = @parseGoogleMapsXML;


end


