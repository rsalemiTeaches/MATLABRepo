function transTable = MakeMoney(priceHistory)
    stockTable = struct2table(priceHistory);
    tickers = string(stockTable.Ticker);
    dates = [stockTable.Date{:,:}]';
    numStocks = numel(tickers);
    numDates = width(dates);
    stockCloses = zeros(numStocks,numDates);
    for ii = 1:numStocks
        stockCloses(ii,:) = stockTable{ii,"AdjClose"}{1,1}';
    end
    shortEMA = calcEMA(stockCloses,12);
    longEMA = calcEMA(stockCloses,26);

    MCAD = shortEMA - longEMA;
    yyaxis right
    signalLines = calcEMA(MCAD,9);
    MCADHistograms = MCAD - signalLines;
    buySignals = false(numStocks,width(MCADHistograms));
    sellSignals = false(numStocks,width(MCADHistograms));
    MCADNeg = MCADHistograms < 0;
    MCADPos = MCADHistograms > 0;
    buySignals(:,2:end) = MCADNeg(:,1:end-1) & MCADPos(:, 2:end);
    sellSignals(:,2:end) = MCADPos(:,1:end-1) & MCADNeg(:, 2:end);

    for ss = 1:3
        subplot(3,1,ss);
        plot(stockCloses(ss,:))
        title(tickers(ss))
        hold on
        plot(shortEMA(ss,:))
        plot(longEMA(ss,:))
        yyaxis right
        bar(MCADHistograms(ss,:))
        for cc = 1:width(buySignals)
           if buySignals(ss,cc) == 1
               xline(cc, '--g', 'LineWidth', 1);
           end
           if sellSignals(ss,cc) == 1
               xline(cc, '--r', 'LineWidth', 1);
           end

        end
        hold off
     end
    

    for ii = 1:numStocks
            idxs = find(buySignals(ii,:));
            buys{ii} = idxs;
            idxs = find(sellSignals(ii,:));
            sells{ii} = idxs;
    end
    transTable = table('Size', [0 5], 'VariableTypes',{'datetime','categorical','categorical','categorical','double'},'VariableNames',{'Timestamp', 'EmailAddress', 'Ticker', 'Type', 'Shares'});
    for stockrow = 1:numStocks
        buyidxs = buys{stockrow};
        for date = 1:numel(buyidxs)
            transTable = [transTable; {dates(stockrow,date), 'rsalemi@natickps.org', tickers(stockrow),'Buy', 10}];
        end
        sellidxs = sells{stockrow};
        for date = 1:numel(sellidxs)
            transTable = [transTable; {dates(stockrow,date), 'rsalemi@natickps.org', tickers(stockrow),'Sell',10}];
        end
    end
    transTable.Timestamp = datestr(transTable.Timestamp,'mm/dd/yyyy hh:MM:ss');
    transTable = sortrows(transTable,"Timestamp");

end