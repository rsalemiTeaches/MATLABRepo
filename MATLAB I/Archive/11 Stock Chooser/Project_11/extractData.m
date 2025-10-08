% Extracting data from the struct array
% The struct array contains daily price and volume information for all the stocks.  
% We need to extract that data and put it into arrays so we can do our stock analysis.
% 
% First, we create a table from the struct array. This makes it easier to extract 
% some information.

function [tickers, dates, stockCloses] = extractData(priceHistory)

    % Convert the struct arrray to a table
    stockTable = struct2table(priceHistory); 
%% 
% stockTable stores the ticker symbols in an array of cell arrays that contain 
% character arrays.  This is difficult to work with.  We get the |stockTable.Ticker| 
% array and covert it to strings and then a categorical array.  This makes our 
% program faster and it takes less memory.

    % The ticker symbols are categorical because we reuse them a lot.
    tickers = categorical(string(stockTable.Ticker));

%% 
% We make an array of all the stocks and all the dates of their transactions.  
% These dates are likely the same for all stocks, but capturing all the dates 
% ensures that we have the correct data for each stock.
% 
% The stockTable.Date variable contains an array of cell arrays.  We extract 
% all the arrays using the {} operator and concatenate them together to create 
% a large array of dates with the size |stocks x dates.| We store the stocks in 
% rows and the dates in columns.

    dates = [stockTable.Date{:,:}]';
    numStocks = numel(tickers);
    numDates = width(dates);
%% 
% Now it is time to make a large array that contains all the adjusted closing 
% prices for all the stocks on each day.  The array size is |numStocks| rows by 
% |numDates| columns.  Each cell in the AdjClose array contains a cell array of 
% stock prices.  We loop through all the stocks and then fill the |stockCloses| 
% row with the data in the |AdjClose| array.  We transpose the array to fit the 
% |stockCloses| row.

    stockCloses = zeros(numStocks,numDates);
    for ii = 1:numStocks
        stockCloses(ii,:) = stockTable{ii,"AdjClose"}{1,1}';
    end
end
