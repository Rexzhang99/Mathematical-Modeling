
function [lng,lat,value] = geoDistance(address, key)
%GEOCODE look up the latitude and longitude of a an address
%
%   COORDS = GEOCODE( ADDRESS ) returns the geocoded latitude and longitude 
%   of the input address. 
%
%   COORDS = GEOCODE( ADDRESS, SERVICE) performs the look up using the
%   specified SERVICE. Valid services are
%       google  - Google Maps  (default service)
%       osm     - OpenStreetMap
%       yahoo   - Yahoo! Place Finder 
%
%   COORDS = GEOCODE( ..., SERVICE, APIKEY) allows the specifcation of an AppId
%   API key if needed.

% Copyright(c) 2012, Stuart P. Layton <stuart.layton@gmail.com>
% https://stuartlayton.com
%
% Revision History
%   2012/08/20 - Initial Release
%   2012/08/20 - Simplified XML parsing code


% Validate the input arguments

% Check to see if address is a valid string
address=char(address);
if isempty(address) || ~ischar(address) || ~isvector(address)
    error('Invalid address provided, must be a string');
end

%replace white spaces in the address with '+'
address = regexprep(address, ' ', '+');

% Switch on the specified service, construct the Query URL, and specify the
% function that will be used to parse the resulting XML 
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


