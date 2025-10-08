function guess = findGuess(probMat, words)
    probMat(probMat == 0) = eps;
    xx = probMat .* log(1 ./ probMat); % find the bits all word for all guesses
    bits = sum(xx); % sum the bits for all guesses
    [~, imax] = max(bits); % find the index (imax) of the word with the max bits
    guess = words(imax); % Use the index to return the guess word
end