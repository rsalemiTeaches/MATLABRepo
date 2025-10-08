% The MakeMoney() function
% MakeMoney() takes the structural array returned by hist_stock_data()
% and creates a table of transactions that are supposed implement a
% profitable technical stock investment strategy.
%
% MakeMoney() returns the table of transactions and an array of graphs for
% each stock if the second argument is set to true.  If you call
% MakeMoney() with one argument, you get an empty matrix for the graphs.

function [transTable, graphs] = MakeMoney(priceHistory, makeGraph) 

    [tickers, dates, stockCloses] = extractData(priceHistory);
    [buyDates, sellDates, graphs] = findTransactionDates(tickers, stockCloses, makeGraph);
    transTable = createTransactionTable(dates, tickers, buyDates, sellDates);

end