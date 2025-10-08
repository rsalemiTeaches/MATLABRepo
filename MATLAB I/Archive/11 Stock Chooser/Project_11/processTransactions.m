function finalTable = processTransactions(playerFile, priceHistory, transactionFile)

% Read in the data
% We store data that remains the same across many transactions as catagorical.  
% This includes player names and stock ticker symbols.

    % Read the list of player emails
    data = readtable(playerFile,"TextType","string");
    players = categorical(data.email);
    
    % Read the list of stocks
    stocks = categorical(string({priceHistory.Ticker})');
    

% Set up player data
% As players buy shares of stock, we store their stock totals in a matrix.  
% One row per player and one column per stock.


    % Zero out all player holdings of all stocks.
    holdings = zeros(numel(players), numel(stocks));
    
    
%% 
% Everyone gets $10,000 to start.

    % Give each player 10,000 to start.
    cash = ones(numel(players),1) * 10000;
    

% Read the transactions
% We used the import tool to create code that sets up the transaction table. 
% The |opts| variable holds all the import options.

    opts = delimitedTextImportOptions("NumVariables", 5);
    
    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["Timestamp", "EmailAddress", "Ticker", "Type", "Shares"];
    opts.VariableTypes = ["datetime", "categorical", "categorical", "categorical", "double"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, ["EmailAddress", "Ticker", "Type"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "Timestamp", "InputFormat", "MM/dd/yyyy HH:mm:ss", "DatetimeFormat", "preserveinput");
    
%% 
% The readtimetable() function reads transactions.  The function assumes that 
% we have date/time data in the first column, which we do.

    % Import the data
    transactions = readtimetable(transactionFile, opts, "RowTimes", "Timestamp");
    
    % Clear temporary variables
    clear opts


% Clear the time of day data. 
% We don't care what time of day the transctions happen as we only look at stock 
% prices at the end of day.  The dateshift() function moves all the datetimes 
% to the start of the day (00:00:00)

    
    transactions.Timestamp = dateshift(transactions.Timestamp,"start","day");
%% Processing Transactions
% Now we'll loop through the transactions in the table row-by-row and read their 
% data.

% Create transaction file
    xfileID = fopen('transactions.log','w');
    for tn = 1:numel(transactions.Timestamp)
        tran = transactions(tn,:);         % get a table row.
        % Extract the transaction information
        % The x<variables> are the data for this xaction.
        xtype = tran.Type;
        xdate = tran.Timestamp;
        xplayer= tran.EmailAddress;
        xstock = tran.Ticker;
        xshares = tran.Shares;
        % find the cash associated with this transaction
        % The try/catch system tries to do an operation and then executes
        % the `catch` statements if the operation fails.  In this case, we
        % catch the case where there was no ticker that matched xstock.

        try
            stockStruct = priceHistory({priceHistory.Ticker} == xstock); % Get the table row for the stock
        catch
            disp(sprintf(xfileID, "%s is not in the price list\n", xstock ));
            continue
        end
        datetest = stockStruct.Date == xdate;  % Read the vector of stock dates from the table.
        % If the transaction date does not match any date in the stock
        % dates then it happened on a weekend or holiday.  Roll the date
        % back until you find data.
        while ~datetest
            xdate = xdate - days(1);
            datetest = stockStruct.Date == xdate;  % we will use datetest to index prices
        end
        
        xprice = stockStruct.AdjClose(datetest); % Get the stock price for the date using datetest
        xcash = xprice * xshares; % Get the cash for the transaction. # of shares * price for the day.
        % Tell the user what the transaction says.
        disp(sprintf("TRAN:%s: %s wants to %s %.3f shares of %s for $%.2f total\n", xdate, xplayer, xtype, xshares, string(xstock), xcash));

% Execute the transaction
% Now we have all the transaction data.  We change the stock holdings and cash 
% to match the transaction instructions.
% 
% First find the player's row in the cash and holdings matrices.

        playerRow = xplayer == players; % Find the index for the player in the holdings and cash matrices

        if ~playerRow % catch a missing-player error
            fprintf (xfileID, "ERROR: %s is not in the player list\n", xplayer);
            continue
        end

        playercash = cash(playerRow);
    
%% 
% Now find the column for the stock in the stocks array.

        stockCol = xstock == categorical(stocks);
        % Catch the missing stock error.
        if ~stockCol
            disp(sprintf("ERROR: %s does not exist in stock list\n", xstock));
            continue
        end
% Are we buying or selling
% If we are buying, check that we have enough cash to make the purchase.  Then 
% subtract the cash from the |cash| vector and add the stock holdings to the |holdings| 
% array.

        if xtype == "Buy"
            if playercash < xcash
                fprintf(xfileID, "ERROR: %s has %.2f dollars and needs %.2f to buy %.2f shares of %s\n", string(xplayer), playercash, xcash, xshares, xstock);
                continue;
            end
    
            cash(playerRow) =cash(playerRow) - xcash;
            holdings(playerRow,stockCol) = holdings(playerRow,stockCol) + xshares;
        else

%% 
% If we are selling, check that the player has enough shares in the holdings 
% array to make the sale.  Then subtract the sale from  |holdings| and add the 
% player's cash to |cash|.

            if xshares > holdings(playerRow, stockCol)
                disp(sprintf("ERROR: %s has %.2f shares of %s and wants to sell %.2f\n", ...
                    string(xplayer), holdings(playerRow, stockCol), xstock, xshares));
                continue;
            end
            holdings(playerRow, stockCol) = holdings(playerRow, stockCol) - xshares;
            cash(playerRow) = cash(playerRow) + xcash;
        end
    end
fclose(xfileID);
%% 
% 
%% Output each player's final value
% We have processed all the transactions.  It is time to find the cash value 
% of the holdings using the most recent |adjClose| prices. 

    stockVal = zeros(1, numel(stocks));
    % Loop through the AdjClose array and put the most recent price 
    % into stockVal.
    for ii = 1:numel(stocks)
        stockVal(1,ii) = priceHistory(ii).AdjClose(end);
    end
    finalTable = array2table(players);
    % Add a CashValue variable to finalTable
    finalTable.CashValue = zeros(numel(players),1);
    % Loop through the players.  Multiply the stock holdings by the latest
    % stoc value and store the sum of the stock values plus cash in the 
    % CashValue variable for each player.
    for ii = 1:numel(players)
        playerStockVals = holdings(ii,:) .* stockVal;
        finalTable.CashValue(ii) = round(sum(playerStockVals)+cash(ii),2);
    end
    finalTable = sortrows(finalTable,"CashValue", "descend");  % Sort the table before returning it.
end
%% 
%