function fullMatches = getFullMatch(wordFile)
    tmptable = readtable(wordFile,'ReadVariableNames',false);
    guesses = char(tmptable.Var1);
    fullMatches = zeros(height(guesses), height(guesses));
    for row = 1:size(guesses,1)
        answer = guesses(row,:);  % Choose a word as the answer
        for col = 1:5
            % tally exact matches per character
            fullMatches(:,row) = fullMatches(:,row) + (answer(col) == guesses(:,col)) .* 3^(5-col); 
        end
    end
end
