function ema = calculateEMA(prices, N)
    % calculateEMA calculates the Exponential Moving Average for a given set of prices
    % and a specified number of days (N).
    %
    % Arguments:
    % prices - A vector of prices (data points).
    % N - The number of days for the EMA calculation.
    %
    % Returns:
    % ema - A vector containing the EMA of the given prices.

    % Check if input prices is a vector
    if ~isvector(prices)
        error('Prices must be a vector');
    end

    % Ensure N is a positive integer
    if ~isscalar(N) || N < 1 || N ~= round(N)
        error('N must be a positive integer');
    end

    % Initialize the EMA vector
    ema = zeros(size(prices));

    % Smoothing factor k
    k = 2 / (N + 1);

    % Start the EMA with the first price point
    ema(1) = prices(1);

    % Calculate the EMA for each price point
    for i = 2:length(prices)
        ema(i) = (prices(i) * k) + (ema(i-1) * (1 - k));
    end
end