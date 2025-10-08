function matchCodes = FindExactAndInexact(wordFile)
    tmptable = readtable(wordFile,'ReadVariableNames',false);
    words = char(tmptable.Var1);
    matchCodes = zeros(height(words), height(words));
    
    % Give match points for exact matches
    
    for guessRow = 1:size(words,1)
        guess = words(guessRow,:);  % Choose a word as the answer
        for letterCol = 1:5
            % tally exact matches per character
            matchCodes(:,guessRow) = matchCodes(:,guessRow) + (guess(letterCol) == words(:,letterCol)) .* 3^(5-letterCol); 
        end
    end
    
    for guessRow = 1:size(words,1)
        guess = words(guessRow, :);
        GuessLetters = unique(guess);
        for letterCol = 1:numel(GuessLetters)
            GuessLetter = GuessLetters(letterCol);
            % we have to handle the case where the guess
            % has more instances of a letter than the 
            % answer.  You cannot get credit for the extra
            % copies of the same letter.
            % answer = 'forte' and guess = 'greed' gives
            % you  'greed' => 00100 => 36 not 00110
            % answer = 'forte' and guess == 'zooms'
            % gives 'zooms' => 02000' not '02100'
            % First: How many times does the letter appear in the answer?
            answerLetterCount = count(guess, GuessLetter);
            % Now match the letter to all letters in all guesses
            letterMatches = words == GuessLetter;
            % Now sum the matchs per word
            guessLetterCounts = sum(letterMatches, 2);
            extraLetters = max(guessLetterCounts - answerLetterCount,0);
            guessRowWithExtra = find(extraLetters > 0);
            for extraRow = 1:length(guessRowWithExtra)
                row = guessRowWithExtra(extraRow);
                guessMatch = matchCodes(row, guessRow);
                base3 = pad(dec2base(guessMatch, 3), 5, 'left', '0');
                lm = letterMatches(row,:);
                for cn = 5:-1:1
                    if lm(cn) && ~(base3(cn) == '1')
                        letterMatches(row,cn) = 0;
                        extraLetters(row) = extraLetters(row) -1;
                    end
                    if extraLetters(row) == 0
                        break;
                    end
                end   
            end
            letterScore = sum(letterMatches .* [3^4 3^3 3^2 3 1],2);
            matchCodes(:,guessRow) = matchCodes(:,guessRow) + letterScore;
        end
    end
end
