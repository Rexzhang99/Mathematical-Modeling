
address=["40.417286 -82.907120","37.839333 -84.270020","38.597626 -80.454903","37.431572 -78.656891","35.517490 -86.580444"];
addresssplit=split(address');

figure1=plot(str2double(addresssplit(:,2)),str2double(addresssplit(:,1)),'.');

for j=1:5
for i=1:5
    % Create line
plot([str2double(addresssplit(i,2)),str2double(addresssplit(j,2))],[str2double(addresssplit(i,1)),str2double(addresssplit(j,1))],'Color',[0.4 0.5 0.6],'LineWidth',2);
hold on

end
end


plot_google_map('MapScale', 1,'MapType','roadmap')


for j=1:5
for i=1:5
stateDist(i,j)= geoDist(address(i),address(j));
end
end
