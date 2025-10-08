if ~exist("priceHistory", 'var')
    priceHistory = hist_stock_data('01012024','24052024','NASDAQ100.txt');
    tickers = categorical(string({priceHistory.Ticker}));
end
winnerTable = processTransactions("MATLABPlayers.csv",priceHistory,"finalTransactions.csv")
