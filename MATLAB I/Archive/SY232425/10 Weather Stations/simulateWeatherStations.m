%{
                The Simulate Weather Stations Function

simulateWeatherStations simulates up to 50 weather stations in the 
Boston area over a set of days.  The function returns two data elements:

[weatherData, stationList] = simulateWeatherStations(startDate, 
                                                     numDays,
                                                     numStations)

INPUTS

startDate—This contains a character array in date format. The format
          is 'MM-dd-yyyy'
numDays—The number of days of data.  The weather stations return data 
        every hour starting at midnight and running through 11 PM. 
        One station returing one day of data returns 24 hours.
numStations—The number of stations up to 54. 

The simulated weather stations return numDays*24*numStations worth of 
data.

OUTPUTS

weatherData—WeatherData is a table of weather data described below.

stationList—This is a categorical list of stations.  If you choose fewer
            than 54 stations you'll get a randomized subset of stations.
            stationList is the list of the subset.

weatherData TABLE FORMAT

simulateWeatherStations returns a table that contains the weather data.
The table has the following variables:

          DateTime           Station      Temp    Humidity    Wind
    ____________________    __________    ____    ________    ____

    01-Oct-2023 01:00:00    1x1 struct     57       0.17       7  

DateTime—The date and time of the weather reading.
Station—A struct that contains information about the weather station.
Temp—The temperature of the reading.
Humidity—The humidity of the reading.
Wind—The magnitude of the wind speed (no direction)

THE STATION STRUCT

The Station variable contains structs with the following fields:

  struct with fields:

     Latitude: 42.3601
    Longitude: -71.0589
         MUNI: 'Boston'

The MUNI field matches the stationList categorical. 

%}


function [weatherData, stationList] = simulateWeatherStations(startDate, ...
                                        numDays, numStations)
    % Geographic coordinates for locations in Massachusetts
    startDatetime = datetime(startDate, 'InputFormat', 'MM-dd-yyyy');
    allStations ={
    42.3601, -71.0589, 'Boston';
    42.2626, -71.8023, 'Worcester';
    42.1015, -72.5898, 'Springfield';
    42.3736, -71.1097, 'Cambridge';
    42.6334, -71.3162, 'Lowell';
    42.0834, -71.0184, 'Brockton';
    41.6362, -70.9342, 'New Bedford';
    42.2529, -70.9971, 'Quincy';
    42.4668, -70.9495, 'Lynn';
    41.7015, -71.1551, 'Fall River';
    42.4251, -71.0743, 'Malden';
    42.4184, -71.1062, 'Medford';
    41.9001, -71.0892, 'Taunton';
    41.9584, -70.6673, 'Plymouth';
    42.4084, -70.9942, 'Revere';
    42.3765, -71.2357, 'Waltham';
    42.3370, -71.2092, 'Newton';
    42.3876, -71.0995, 'Somerville';
    42.5048, -71.1955, 'Burlington';
    42.2793, -71.4162, 'Framingham';
    42.1251, -72.7499, 'Westfield';
    42.1487, -72.5898, 'Chicopee';
    42.4084, -71.0537, 'Everett';
    42.3151, -72.6369, 'Northampton';
    42.5834, -71.8023, 'Fitchburg';
    42.6150, -70.6613, 'Gloucester';
    42.5584, -70.8830, 'Beverly';
    42.5760, -70.9545, 'Danvers';
    42.5195, -70.8967, 'Salem';
    42.7762, -71.0773, 'Haverhill';
    42.5250, -71.7590, 'Leominster';
    42.3450, -71.6130, 'Westborough';
    42.3611, -71.5169, 'Milford';
    42.2835, -71.3585, 'Natick';
    42.2965, -71.7151, 'Shrewsbury';
    42.4668, -71.0121, 'Saugus';
    42.3625, -71.1820, 'Watertown';
    42.8403, -70.9345, 'Amesbury';
    42.2390, -71.4660, 'Ashland';
    42.0590, -71.4870, 'Bellingham';
    41.9830, -70.0200, 'Bridgewater';
    42.5260, -71.3080, 'Carlisle';
    41.6340, -70.9750, 'Dartmouth';
    42.0590, -71.0860, 'Easton';
    42.0960, -71.4330, 'Franklin';
    42.2020, -70.8850, 'Hingham';
    42.5000, -70.8330, 'Marblehead';
    42.1840, -71.1990, 'Norwood';
    42.1160, -70.8890, 'Rockland';
    42.0870, -72.0360, 'Southbridge';
    42.6080, -71.2000, 'Tewksbury';
    42.5580, -71.1400, 'Wilmington';
    42.3730, -70.9880, 'Winthrop';
    41.6650, -70.2230, 'Yarmouth';
};

    if nargin < 3
        numStations = size(allStations,1);
        stations = allStations;
    else
        numStations = floor(numStations);
        if numStations < 0
            error("numStations must be positive")
        end
        if numStations > size(allStations,1)
            error(sprintf("numStations is too big. It must be no more than %0d", ...
                size(allStations,1)));
        end
        stationsUsed = randperm(size(allStations,1), numStations);
        stations = allStations(stationsUsed,:);
    end
    stationList = unique(categorical(stations(:,3)));

    % Number of hours in the specified number of days

    numHours = numDays * 24; 
    numReadings= numHours * numStations;
    initDateTime = NaT(numReadings,1);
    stationArray(numStations) = struct('Latitude', 0, 'Longitude',0,'MUNI','');
    for ii = 1:numStations
        stationArray(ii).Latitude = stations{ii,1};
        stationArray(ii).Longitude = stations{ii,2};
        stationArray(ii).MUNI = stations{ii,3};
    end
    % Preallocate the weather data array
    stationVar(numReadings,1) = struct('Latitude', 0, 'Longitude',0,'MUNI','');
    weatherData = table(initDateTime, ...
        stationVar, ...
        zeros(numReadings,1), ...
        zeros(numReadings,1), ...
        zeros(numReadings,1), ...
        'VariableNames', ...
        {'DateTime','Station','Temp','Humidity','Wind'});
        % Create a sin wave to make reasonable temperatures
    t = linspace(0, 2*pi, 24); % Time vector from 0 to 24 hours
    amplitude = -1;              % Amplitude of the sine wave
    offset = 1;                 % Offset to shift the sine wave

    % Create the sine wave
    sineWave = amplitude * sin(t) + offset;
    hSine = amplitude * sin(t+pi/4) + offset ;
    minTemp = floor(sineWave * 10 + 40);
    maxHumid = floor(hSine * 40 + 20);
    % Simulate weather data
    rowNum = 1;
    randwind = [-1 2];
    for hour = 1:numHours
        hr24 = mod(hour,23)+1;
        for station = 1:numStations
            weatherData.DateTime(rowNum) = startDatetime + hours(hour);
            weatherData.Station(rowNum).Latitude = stationArray(station).Latitude;
            weatherData.Station(rowNum).Longitude = stationArray(station).Longitude;
            weatherData.Station(rowNum).MUNI = stationArray(station).MUNI;
            geoMinTemp = minTemp - floor(weatherData.Station(rowNum).Latitude-42.25);
            weatherData.Temp(rowNum) = randi([geoMinTemp(hr24),geoMinTemp(hr24)+10]);
            weatherData.Humidity(rowNum) = randi([maxHumid(hr24)-20,maxHumid(hr24)])./100;
            if rowNum == 1
                weatherData.Wind(1) = randi([5 10]);
            else
                if weatherData.Wind(rowNum-1) < floor(hour/numHours * 2)
                    randwind = [0 2];
                end
                if weatherData.Wind(rowNum-1) > floor(hour/numHours * 10)
                    randwind = [-2 1];
                end
                weatherData.Wind(rowNum) = weatherData.Wind(rowNum-1) ...
                    + randi(randwind);
            end
            rowNum = rowNum + 1;
        end
    end
end
