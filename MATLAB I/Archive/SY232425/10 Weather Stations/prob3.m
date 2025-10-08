[wdata, stations] = simulateWeatherStations('01-13-2024', 10);
% getStationVariables() adds the MUNI, Lat, and Lon variables to wdata.
wdata = getStationVariables(wdata);
mine = mean(wdata.Temp(wdata.MUNI == "Amesbury"))
test = groupsummary(wdata, "MUNI", "mean", "Temp")
test;