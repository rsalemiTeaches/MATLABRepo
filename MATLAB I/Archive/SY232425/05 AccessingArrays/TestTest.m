
load dowdata.mat
startdays = [1 5,10,14];
fridays = [4 9 13 18];
diffPers = (prices(:,fridays) - prices(:,startdays))./prices(:,startdays) .* 100;
[winners, widx] = max(diffPers);
[losers, lidx] = min(diffPers);

winning_tickers = tickers(widx)
my_winning_tickers = tickers(widx+1)
losing_tickers = tickers(widx)
my_losing_tickers = tickers(widx+1)
if ~isequal(my_losing_tickers, losing_tickers)
    CorrectString = sprintf("Losing tickers are incorrect:\nCorrect Tickers: [%s]",join(my_winning_tickers))
    YourString = sprintf("Correct Tickers: [%s]",join(winning_tickers))
    error("%s\n%s",CorrectString, YourString)
end