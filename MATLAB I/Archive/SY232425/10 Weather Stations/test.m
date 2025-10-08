[data, stations] = simulateWeatherStations('10-01-2023', 2);

close all
for ii = 1:numel(stations)
    if mean(data.Temp(ii)) > 53
        face = 'b';
    else
        face = 'g';
    end
    geoplot(data.Station(ii).Latitude, data.Station(ii).Longitude,'ro', ...
    'MarkerFaceColor',face);
hold on;
end
hold off
figure
plot(data.Temp);
yyaxis left;
hold on;
yyaxis right;
plot(data.Humidity);
legend(["Temp" "Humidity"])
figure
plot(data.Wind);
hold off;
title("Wind")

hold off