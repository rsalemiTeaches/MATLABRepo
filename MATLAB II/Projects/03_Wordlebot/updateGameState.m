function [newWordCols, newSuggestion, newCount, isWinner, isGameOver] = updateGameState(latestGuess, resultb3, currentCount, wordCols, wordstr, matchCodes, initProb, words)
%UPDATEGAMESTATE Processes a guess and updates the game's state.
%   This function contains the core logic for the Wordle solver. It takes
%   the current state of the game and the latest guess/result, and returns
%   the new, updated state.

    % --- Default Outputs ---
    isWinner = false;
    isGameOver = false;
    newSuggestion = ''; % Initialize suggestion as empty

    % --- Check for a Win ---
    if resultb3 == "22222"
        isWinner = true;
        newWordCols = wordCols; % No change to word columns on a win
        newCount = currentCount; % No change to count on a win
        return; % Exit the function early
    end

    % --- Update Word List Based on Guess ---
    result = base2dec(resultb3, 3);
    guessRow = find(strcmp(wordstr, latestGuess));
    newWordIndices = find(matchCodes(guessRow, :) == result);

    if currentCount == 1
        newWordCols = newWordIndices;
    else
        newWordCols = intersect(wordCols, newWordIndices);
    end

    % --- Find the Next Best Guess ---
    % NOTE: This assumes you have a findGuess method or function.
    % We will call a helper function for this logic.
    newSuggestion = findGuess(initProb(:, newWordCols), words(newWordCols));

    % --- Update Game Counters and Status ---
    newCount = currentCount + 1;
    if newCount > 6
        isGameOver = true;
    end
end

