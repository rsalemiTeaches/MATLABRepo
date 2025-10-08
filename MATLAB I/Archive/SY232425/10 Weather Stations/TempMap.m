[data, stations] = simulateWeatherStations('10-01-2023', 10);
stations = categorical(upper(string(stations)));
data.MUNI = [categorical(upper(string({data.Station.MUNI})))]';
means = array2table(stations, "VariableNames","MUNI");
means.MUNI = upper(means.MUNI);
means.Temps = zeros(numel(stations),1);
for ii = 1:numel(stations)
    means.Temps(ii) = mean(data.Temp(data.MUNI == stations(ii)));
end
munis = readgeotable("townssurvey_shp/TOWNSSURVEY_POLY.shp");
munis.MUNI = categorical(munis.TOWN);

meansmunis = innerjoin(munis,means);
geoplot(meansmunis,ColorVariable="Temps");
colormap(jet);
colorbar;

