function ema = calcEMA(prices, N)
    % calculateEMA calculates the Exponential Moving Average for 
    % multiple stocks over N days. 
    %
    % Arguments:
    % prices - An array of prices, one row per stock.
    % N - The number of days for the EMA calculation.
    %
    % Returns:
    % ema - A vector containing the EMA of the given prices.



    % Ensure N is a positive integer
    if ~isscalar(N) || N < 1 || N ~= round(N)
        error('N must be a positive integer scalar');
    end

    % Initialize the EMA vector
    ema = zeros(size(prices));

    % Smoothing factor k
    k = 2 / (N + 1);

    % Start the EMA with the first price point
    ema(:,1) = prices(:,1);

    % Calculate the EMA for each price point
    for ii = 2:width(prices)
        ema(:,ii) = (prices(:,ii) .* k) + (ema(:,ii-1) .* (1 - k));
    end
end