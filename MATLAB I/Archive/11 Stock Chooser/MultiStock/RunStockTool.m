if ~exist("priceHistory", 'var')
    priceHistory = hist_stock_data('01012024',now,'NASDAQ100.txt');
end

tt = MakeMoney(priceHistory);
writetable(tt,'RSTransactions.csv');
processTransactions("TestPlayers.csv",priceHistory,"RSTransactions.csv")


