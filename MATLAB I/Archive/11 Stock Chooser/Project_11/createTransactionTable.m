%% Function: |createTransactionTable(buyDates, sellDates)|
% Now we're going to create our transaction table.  First we define an empty 
% table that contains the correct varibles. 

function transTable = createTransactionTable(dates, tickers, buyDates, sellDates)
    transTable = table('Size', [0 5], 'VariableTypes',{'datetime','categorical','categorical','categorical','double'},'VariableNames',{'Timestamp', 'EmailAddress', 'Ticker', 'Type', 'Shares'});
%% 
% Now we loop through all the stocks.  For each stock, we get an array of buy 
% indicess from buys, We loop through the dates use them to add transactions to 
% the transaction table. 

    for stockrow = 1:numel(buyDates)
        buyidxs = buyDates{stockrow};
        for ii = 1:numel(buyidxs)
            dateidx = buyidxs(ii);
            transTable = [transTable; {dates(stockrow,dateidx), 'rsalemi@natickps.org', tickers(stockrow),'Buy', 10}];
        end
        sellidxs = sellDates{stockrow};
        for ii = 1:numel(sellidxs)
            dateidx = sellidxs(ii);
            transTable = [transTable; {dates(stockrow,dateidx), 'rsalemi@natickps.org', tickers(stockrow),'Sell',10}];
        end
    end

%% 
% Now that we have the transaction table, we convert the datetimes to strings 
% and sorte the table by dates.  It is now ready to return.

    transTable.Timestamp = datestr(transTable.Timestamp,'mm/dd/yyyy hh:MM:ss');
    transTable = sortrows(transTable,"Timestamp");
end
%