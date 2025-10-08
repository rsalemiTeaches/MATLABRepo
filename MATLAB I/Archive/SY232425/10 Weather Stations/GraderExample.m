[data, stations] = simulateWeatherStations('10-01-2023', 10);
data.MUNI = [categorical(string({data.Station.MUNI}))]';
data.LAT = [data.Station.Latitude]';
data.LON = [data.Station.Longitude]';

means = array2table(stations, 'VariableNames', {'MUNI'});
means.Temps = zeros(numel(stations),1);
means.LAT = zeros(numel(stations),1);
means.LON = zeros(numel(stations),1);
for ss = 1:numel(stations)
    means.Temps(ss) = mean(data.Temp(data.MUNI == stations(ss)));
    lats = data.LAT(data.MUNI == means.MUNI(ss));
    lons = data.LON(data.MUNI == means.MUNI(ss));
    means.LAT(ss) = lats(1);
    means.LON(ss) = lons(1);
    if means.Temps(ss) > 54.3
        means.Face(ss) = 'g';
    else
        means.Face(ss) = 'b';
    end
    geoplot(means.LAT(ss), means.LON(ss), 'bo','MarkerFaceColor', ...
            means.Face(ss));
    hold on
end
hold off
