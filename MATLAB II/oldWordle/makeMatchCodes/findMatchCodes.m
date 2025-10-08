function matchCodes = findMatchCodes(wordFile)
    tmptable = readtable(wordFile,'ReadVariableNames',false);
    guesses = char(tmptable.Var1);
    matchCodes = zeros(height(guesses), height(guesses));
    
    % Give match points for exact matches
    
    for ii = 1:size(guesses,1)
        answer = guesses(ii,:);  % Choose a word as the answer
        for jj = 1:5
            % tally exact matches per character
            matchCodes(:,ii) = matchCodes(:,ii) + (answer(jj) == guesses(:,jj)) .* 3^(5-jj); 
        end
    end
    
    for ii = 1:size(guesses,1)
        answer = guesses(ii, :);
        letters = unique(answer);
        for jj = 1:numel(letters)
            letterMatches = guesses == letters(jj);
            letterScore = sum(letterMatches .* [3^4 3^3 3^2 3 1],2);
            matchCodes(:,ii) = matchCodes(:,ii) + letterScore;
        end
    end
end
