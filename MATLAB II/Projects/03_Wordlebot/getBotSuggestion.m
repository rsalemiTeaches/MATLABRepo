% This function was created with assistance from Gemini.
function newSuggestion = getBotSuggestion(GuessHistory, ResultHistory, wordstr, matchCodes)
% GETBOTSUGGESTION calculates the next best Wordle guess.
%   It takes the history of guesses and results, filters the list of
%   possible words, and calculates the optimal next guess.

    % --- Initialize with all possible words ---
    remainingWordIndices = 1:numel(wordstr);
    
    % --- Process the entire game history ---
    % Loop through each guess the user has already made.
    for i = 1:numel(GuessHistory)
        guess = GuessHistory{i};
        resultStr = ResultHistory{i};
        
        % If a row in the history is empty, stop processing.
        if isempty(guess) || isempty(resultStr)
            break;
        end
        
        % Convert the result string (e.g., "01210") into the base-10 integer
        % that the matchCodes matrix uses. The '3' indicates base-3.
        resultb10 = base2dec(resultStr, 3);
        
        % Find the row in matchCodes corresponding to the current guess.
        guessIndex = find(strcmp(wordstr, guess));
        if isempty(guessIndex)
            % This happens if the guess is not in the word list.
            % For simplicity, we'll suggest the same word again.
            newSuggestion = guess;
            return;
        end
        
        % Find all columns (words) that would have produced that result.
        stillPossible = find(matchCodes(guessIndex, :) == resultb10);
        
        % Filter the list of remaining words. The intersect function keeps
        % only the words that are in BOTH lists.
        remainingWordIndices = intersect(remainingWordIndices, stillPossible);
    end
    
    % --- Determine the next best guess based on the remaining words ---
    if isscalar(remainingWordIndices)
        % If only one word is left, that's our answer!
        newSuggestion = wordstr(remainingWordIndices);
    elseif isempty(remainingWordIndices)
        % If there are no words left, something went wrong.
        newSuggestion = "NO WORDS LEFT";
    else
        % If multiple words remain, we need to calculate the best one
        % to narrow down the list further.
        
        % **FIXED LINE**: Filter out empty cells before converting to a string array.
        % This prevents an error when the history is not yet full.
        guessList = string(GuessHistory(~cellfun('isempty', GuessHistory)));
        
        % For early guesses, we check against all words for max info.
        % For later guesses, we check only against remaining possible words.
        currentGuessNum = find(cellfun(@isempty, GuessHistory), 1);
        if isempty(currentGuessNum) || currentGuessNum <= 3
             probs = findprobabilities_fast(matchCodes(remainingWordIndices,:));
             % The findguess function now calculates entropy internally.
             newSuggestion = findguess(probs, wordstr, guessList);       
        else
             probs = findprobabilities_fast(matchCodes(remainingWordIndices,remainingWordIndices));
             % The findguess function now calculates entropy internally.
             newSuggestion = findguess(probs, wordstr(remainingWordIndices), guessList);
        end
    end
end

% --- Helper Functions ---
% NOTE: You will need to provide students with these two helper functions
% from your original testbench, as they are not standard MATLAB functions.

function probs = findprobabilities_fast(matchCodes)
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

function guess = findguess(probMat, words, guessList)
%FINDGUESS Finds the word with the highest information entropy.
    
    % Replace zero probabilities with a small number to avoid log(0) issues.
    probMat(probMat == 0) = eps; 
    
    % Calculate the information bits for each outcome.
    allBits = probMat .* log2(1 ./ probMat);
    
    % Sum the bits for each potential guess to get the total entropy.
    totalBits = sum(allBits);
    
    % Find the index of the word with the maximum entropy.
    [~, imax] = max(totalBits);
    guess = words(imax);
    
    % If the top guess has already been used, find the next best one.
    while ismember(guess, guessList)
        totalBits(imax) = 0; % Set current max to 0 to ignore it
        [~, imax] = max(totalBits); % Find the new max
        guess = words(imax);
    end
end

