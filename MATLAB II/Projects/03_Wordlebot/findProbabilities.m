function probs = findProbabilities(matchCodes)
%FINPROBABILITIES_FAST Calculates column-wise probabilities in a matrix efficiently.
%   This function uses a vectorized approach with `accumarray` for maximum
%   performance, avoiding slow loops.
    
    % Get the dimensions of the input matrix.
    [numRows, numCols] = size(matchCodes);
    
    % Create a matrix where each element's value is its own column index.
    % This is needed for accumarray to group the counts by column.
    colIndices = repmat(1:numCols, numRows, 1);

    % Use accumarray to perform the counting for all columns in a single operation.
    % We create subscript pairs [row, column] for the output matrix.
    % The 'row' is the value from matchCodes + 1 (for 1-based indexing).
    % The 'column' is the original column index of that value.
    % We accumulate a '1' for each occurrence. The output 'counts' will be a
    % 243-by-numCols matrix of raw counts.
    counts = accumarray([matchCodes(:) + 1, colIndices(:)], 1, [243, numCols]);
    
    % Convert the raw counts into probabilities by dividing by the number of
    % samples in each column (which is the number of rows).
    probs = counts / numRows;
end
% Written with the help of Gemini Pro