if ~exist("matchCodes", 'var')
    load ../matchCodes.mat
end
xx = readtable("possible_words.txt","ReadVariableNames", false);
solutions = xx.Var1;
numberOfGuesses = zeros(numel(solutions),1);
losingPlays = zeros(numel(solutions),1);

for wn = 1:numel(solutions)
    numberOfGuesses(wn) = solveWordle(solutions(wn), wordstr, ...
        matchCodes,initProb);
end
histogram(numberOfGuesses)
xlabel("Number of Guesses")
ylabel("Words solved with this many guesses")
title("Distribution of guesses needed for all possible words")



function numGuesses = solveWordle(solution,wordstr, matchCodes,initProb)
    numGuesses = 1;
    remaining = 1:numel(wordstr);
    guessList = strings(1,20);
    guess = findguess(initProb, wordstr, guessList);
    while true
        guessList(1,numGuesses) = guess;
        resultb10 = matchCodes(guess == wordstr, solution == wordstr);
        if resultb10 == 242
            break
        end
        solutionCols = find(matchCodes(guess == wordstr,:) == resultb10);
        remaining = intersect(remaining, solutionCols);
        if isscalar(remaining)
            guess = wordstr(remaining);
        else
            probs = findprobabilities_fast(matchCodes(remaining,:));
            if numGuesses <= 2
                guess = findguess(probs, wordstr, guessList);       
            else
                guess = findguess(probs(:,remaining), wordstr(remaining), guessList);
            end
        end
        numGuesses = numGuesses + 1;
    end
end