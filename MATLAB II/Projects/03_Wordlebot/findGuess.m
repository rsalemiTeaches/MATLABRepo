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

% Written with the help of Gemini Pro
