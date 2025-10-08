function matchCodes = findMatchCodes(wordFile)
    tmptable = readtable(wordFile,'ReadVariableNames',false);
    wordList = char(tmptable.Var1); % The list of legal wordle words
    numWords = size(wordList,1);
    for solNum = 1:numWords %loop through the words
        solution = wordList(solNum,:);  % Choose the next word word as the solution
        greenMatches = solution == wordList; % create a logical array of exact matches
        solutionLetters = unique(solution); % get the letters
        yellowMatches = false(size(wordList)); % initialize yellowMatches
        for letterNum = 1:numel(solutionLetters) % loop through each letter
            letter = solutionLetters(letterNum); % Get the next letter
            letterMatches = (wordList == letter); % Find all the letter matches
            guessLetterCounts = sum(letterMatches,2);
            solutionLetterCount = count(solution, letter);
            extraLetters = max(guessLetterCounts - solutionLetterCount,0);
            extraLetterRows = find(extraLetters > 0);
            letterMatchOnly = max(letterMatches - greenMatches,0); % remove the exact matches
            for elgRow = 1:numel(extraLetterRows)
                guessRow = extraLetterRows(elgRow);
                matchCols = find(letterMatchOnly(guessRow,:));
                matchCols = flip(matchCols);
                for mc = 1:numel(matchCols)
                    letterMatchOnly(guessRow,matchCols(mc)) = 0;
                    extraLetters(guessRow) = extraLetters(guessRow) - 1;
                    if extraLetters(guessRow) == 0
                        break
                    end
                end
            end
            yellowMatches = yellowMatches | letterMatchOnly;
        end
        totalPoints = greenMatches .* 2 + yellowMatches;
        scoreArray =  totalPoints .* [3^4 3^3 3^2 3^1 3^0]; % aka 3 .^(4:-1:0)
        matchCodes(:,solNum) = sum(scoreArray,2);
    end
end