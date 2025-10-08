function numGuesses = myWordleSolver(solution,wordstr, matchCodes,initProb, solutions)
    numGuesses = 1;
    remaining = 1:numel(wordstr);
    guessList = strings(1,20);
    guess = findguess(initProb, wordstr, guessList);
    while true
        guessList(1,numGuesses) = guess;
        resultb10 = matchCodes(guess == wordstr, solution == wordstr);
        if resultb10 == 242
            break
        end
        solutionCols = find(matchCodes(guess == wordstr,:) == resultb10);
        remaining = intersect(remaining, solutionCols);
        if isscalar(remaining)
            guess = wordstr(remaining);
        else
            probs = findprobabilities_fast(matchCodes(remaining,:));
            if numGuesses <= 2
                guess = findguess(probs, wordstr, guessList);       
            else
                guess = findguess(probs(:,remaining), wordstr(remaining), guessList);
            end
        end
        numGuesses = numGuesses + 1;
    end
end


function guess = findguess(probMat, words, guessList)
    probMat(probMat == 0) = eps;
    allBits = probMat .* log(1 ./ probMat);
    totalBits = sum(allBits);
    [~, imax] = max(totalBits);
    guess = words(imax);
    while ismember(guess, guessList)
        totalBits(imax) = 0;
        [~, imax] = max(totalBits);
        guess = words(imax);
    end
end

function probs = findprobabilities_fast(matchCodes)
%FINPROBABILITIES_FAST Calculates column-wise probabilities in a matrix efficiently.
%   probs = FINPROBABILITIES_FAST(matchCodes) takes a matrix `matchCodes` where
%   each column represents a set of observations and values are integers
%   ranging from 0 to 242. It returns a 243-by-N matrix `probs`, where N is
%   the number of columns in `matchCodes`. `probs(i, j)` is the probability
%   of observing the value (i-1) in the j-th column.
%
%   This function uses a vectorized approach with `accumarray` for maximum
%   performance, avoiding slow loops.

    % Get the dimensions of the input matrix.
    [numRows, numCols] = size(matchCodes);

    % Create a matrix where each element's value is its own column index.
    % This is needed for accumarray to group the counts by column.
    % repmat creates a matrix like: [1 2 3; 1 2 3; 1 2 3] for a 3-col input.
    colIndices = repmat(1:numCols, numRows, 1);

    % Use accumarray to perform the counting for all columns in a single operation.
    % We create subscript pairs [row, column] for the output matrix.
    % 1. The 'row' for the output is the value from matchCodes + 1 (for 1-based indexing).
    % 2. The 'column' for the output is the original column index of that value.
    % We accumulate a '1' for each occurrence. The output 'counts' will be a
    % 243-by-numCols matrix of raw counts.
    counts = accumarray([matchCodes(:) + 1, colIndices(:)], 1, [243, numCols]);

    % Convert the raw counts into probabilities by dividing by the number of
    % samples in each column (which is the number of rows).
    probs = counts / numRows;
end
