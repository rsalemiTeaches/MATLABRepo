if ~exist("priceHistory", 'var')
    priceHistory = hist_stock_data('01012024','24052024','NASDAQ100.txt');
    tickers = categorical(string({priceHistory.Ticker}));
end

if ~exist('graphs','var')
    [tt, graphs] = MakeMoney(priceHistory,true);
else
    tt = MakeMoney(priceHistory,false);
end
writetable(tt,'finalTransactions.csv', "WriteVariableNames",false);
processTransactions("MATLABPlayers.csv",priceHistory,"finalTransactions.csv")
