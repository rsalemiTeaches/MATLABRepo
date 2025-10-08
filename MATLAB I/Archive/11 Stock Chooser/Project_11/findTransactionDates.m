function [buyDates, sellDates, graphs] = findTransactionDates(tickers, stockCloses, makeGraphs)
    numStocks = numel(tickers);
    shortEMA = calcEMA(stockCloses,12);
    longEMA = calcEMA(stockCloses,26);
%% 
% |shortEMA| and |longEMA| arrays contain a row for every stock, and columns 
% for all the dates, but they contain moving averages instead of stock prices.
% 
% Now we calculate the Moving Average Convergence Divergence (MACD).  We subtract 
% the 26 day EMA from the 12 day EMA to get the MACD. This is our first stock 
% signal.

    MACD = shortEMA - longEMA;
%% 
% The MACD is too noisy to make stock decisions, so we're going to take the 
% 9 day Expontential Moving Average of the MACD to get a comparison signal that 
% we'll name |signal|.

    signal = calcEMA(MACD,9);
%% 
% Now that we have the MACD and the signal. we subtract them to get the histogram.

    MACDHistograms = MACD - signal;
% Buying signals and selling signals
% Now that we have the MACD histograms for all the stocks, we can choose our 
% buying signals and selling signals.  This is the most arbitrary part of the 
% process.  My algorithm is very simple, but that's probably why it doesn't make 
% a lot of money. 
% 
% More advanced algorithms take into account the volume of stocks sold on a 
% day, the long term trends of the histogram, and recent highs and lows.  My algorithm 
% simply buys a stock if its histogram goes up from negative to positive and sells 
% it if the histogram goes down from positive to negative. We find this information 
% across all histograms for all stocks.
% 
% First we create empty arrays of buy signals and sell signals. 

    buySignals = false(numStocks,width(MACDHistograms));
    sellSignals = false(numStocks,width(MACDHistograms));

%% 
% Now we create arrays for all negative histogram values and all positive histogram 
% values.

    MACDNeg = MACDHistograms < 0;
    MACDPos = MACDHistograms > 0;

%% 
% We line up one histogram with the other histogram offset buy a day.  We buy 
% when the early histogram is negative and the next day histogram is positive.  
% We sell when the early histogram is postive and the next day histogram is negative.

    buySignals(:,2:end) = MACDNeg(:,1:end-1) & MACDPos(:, 2:end);
    sellSignals(:,2:end) = MACDPos(:,1:end-1) & MACDNeg(:, 2:end);

%% 
% We now have two logical arrays, |buySignals| contains 1's corresponding to 
% the days to buy a stock and |sellSignals| contains  1's on the days to sell 
% a stock.   We use these with the f|ind()| function to get the indices of the 
% dates to buy and sell stocks.
% 
% |buys| contains the index of the days we buy each stock, and |sells| contains 
% the index of the days that we sell each stock.

    buyDates = cell(1,numStocks);
    sellDates = cell(1,numStocks);
    for ii = 1:numStocks
            buyDates{ii} = find(buySignals(ii,:));
            sellDates{ii} = find(sellSignals(ii,:));
    end
% Make the graphs
% If the user wants graphs of all the stocks, we create them here.  We return 
% an array of figure objects containing each graph.

    if makeGraphs==true
        graphs = zeros(1, numStocks);

%% 
% Loop through all the stocks and create a graph for each without displaying 
% it on the screen.
        for ss = 1:numStocks
            graphs(ss) = figure('Visible','off');
            plot(stockCloses(ss,:));
            title(tickers(ss));
            hold on;
            plot(shortEMA(ss,:));
            plot(longEMA(ss,:));

%% 
% The histogram has numbers centered around zero, so we use the right axis instead 
% of the left so that we can see the histogram on the same graph as the stock 
% prices.

            yyaxis right;
            bar(MACDHistograms(ss,:),'FaceAlpha', 0.0);

%% 
% Create vertical lines at each buy and sell. 

            for cc = 1:width(buySignals)
               if buySignals(ss,cc) == 1
                   xline(cc, '--g', 'LineWidth', 1);
               end
               if sellSignals(ss,cc) == 1
                   xline(cc, '--r', 'LineWidth', 1);
               end
    
            end
            legend('Close', 'EMA12','EMA26','Hist','Location','southwest');
            hold off
        end
    else
        graphs = [];
    end

end