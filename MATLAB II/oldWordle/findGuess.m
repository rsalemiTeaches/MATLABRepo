function guess = findGuess(probMat, words)
    % probMat is a matrix of the probability of 
    % the next guess matches for all words
    
    % word is a matrix of all words
    
    xx = probMat .* log(1 ./ probMat); % find the bits all word for all guesses
    bits = sum(xx); % sum the bits for all guesses
    [~, imax] = max(bits); % find the index (imax) of the word with the max bits
    guess = words(imax); % Use the index to return the guess word
end