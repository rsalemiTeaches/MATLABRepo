[data, stations] = simulateWeatherStations('10-01-2023', 2);
data.MUNI = [categorical(string({data.Station.MUNI}))]';
means = table(stations);
means.Temps = zeros(numel(stations),1);
for ii = 1:numel(stations)
    means.Temps(ii) = mean(data.Temp(data.MUNI == stations(ii)));
end

