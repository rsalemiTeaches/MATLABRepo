% This function was created with assistance from Gemini.
function nextGuess = findNextGuess(probs, possibleWords, guessList)
%FINDNEXTGUESS Analyzes pre-calculated probabilities to find the best guess.
%
% Inputs:
%   probs: A pre-calculated matrix of probabilities. Each column corresponds
%          to a word in 'possibleWords', and each row corresponds to a
%          possible result code.
%   possibleWords: A string array of words to choose a guess from.
%   guessList: A string array of words that have already been guessed.
%
% Output:
%   nextGuess: The single best 5-letter string to guess next.

    % This baseline strategy simply calls a helper function to find the word
    % that provides the most information (highest entropy). Students can
    % modify or replace this logic with their own improved strategy.
    nextGuess = findguess(probs, possibleWords, guessList);

end

% --- Helper Function ---

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
    
    % If the top guess has already been used, find the next best one. This
    % prevents the algorithm from getting stuck in a loop.
    while ismember(guess, guessList)
        totalBits(imax) = 0; % Set current max to 0 to ignore it
        [~, imax] = max(totalBits); % Find the new max
        if isempty(imax) % Failsafe for the rare case all options are exhausted
            guess = words(1); 
            break;
        end
        guess = words(imax);
    end
end

