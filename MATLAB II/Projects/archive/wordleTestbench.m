%% WORDLEBOT ALGORITHM TESTBENCH (v3.1 - High Performance)
% This script tests a student's Wordle solver function by running it against
% every possible solution word. It calculates performance statistics and
% displays a histogram of the results.
%
% To Use:
% 1. Make sure 'WordleData.mat' is in the same folder or on the MATLAB path.
% 2. Make sure your solver function, named 'findNextGuess.m', is also
%    in the same folder or on the MATLAB path.
% 3. Run this script from the MATLAB Command Window by typing: runMySolver

% --- Created with assistance from Gemini. ---

%% ========================================================================
%  0. CONFIGURATION
%  ========================================================================
% Set this flag to 'true' to run a quick test on a subset of words.
isTestMode = true;

% Set this flag to 'false' to hide the word-by-word results for a cleaner
% and slightly faster run.
showWordByWordResults = false;

%% ========================================================================
%  1. SETUP & VALIDATION
%  ========================================================================
clc;
fprintf('Starting Wordlebot Testbench...\n');

% --- Load Data ---
if ~exist('wordstr', 'var') || ~exist('matchCodes', 'var')
    fprintf('Data not in workspace. Loading from WordleData.mat...\n');
    if ~exist('WordleData.mat', 'file')
        error('FATAL: WordleData.mat not found. Please place it in the same folder.');
    end
    load('WordleData.mat', 'wordstr', 'matchCodes');
    fprintf('Data loaded successfully.\n');
else
    fprintf('Using existing data from workspace.\n');
end

% --- Validate Student's File ---
if ~exist('findNextGuess.m', 'file')
    error('FATAL: findNextGuess.m not found. Please ensure it is in the same folder and named correctly.');
end
fprintf('Student solver function found.\n\n');

% --- Initialize Results ---
if isTestMode
    numSolutions = 10; % Test mode now runs on only 10 words.
    fprintf('>>> RUNNING IN QUICK TEST MODE (%d words) <<<\n', numSolutions);
else
    numSolutions = numel(wordstr);
    fprintf('>>> RUNNING IN FULL SIMULATION MODE (%d words) <<<\n', numSolutions);
end
guessDistribution = zeros(numSolutions, 1);
practicalTurnLimit = 20;

%% ========================================================================
%  2. MAIN SIMULATION LOOP
%  ========================================================================
fprintf('Running simulations...\n\n');
startTime = tic;

for i = 1:numSolutions
    solution = wordstr(i);
    
    % --- Initialize Game State ---
    remainingIndices = 1:numel(wordstr);
    guessList = strings(1, practicalTurnLimit);
    isWin = false;
    
    % --- Inner Game Loop ---
    for turn = 1:practicalTurnLimit
        % The TESTBENCH does the heavy lifting: calculating probabilities.
        possibleWords = wordstr(remainingIndices);
        
        % The strategy for finding the best guess from all words vs. only
        % remaining words is a key part of the algorithm's intelligence.
        if turn <= 2
            probs = findprobabilities_fast(matchCodes(remainingIndices,:));
            % We pass the full word list for early guesses to find high-entropy words.
            nextGuess = findNextGuess(probs, wordstr, guessList);
        else
            probs = findprobabilities_fast(matchCodes(remainingIndices, remainingIndices));
            % We pass the filtered word list for later guesses.
            nextGuess = findNextGuess(probs, possibleWords, guessList);
        end
        
        guessList(turn) = nextGuess;
        
        if strcmp(nextGuess, solution)
            guessDistribution(i) = turn;
            isWin = true;
            break;
        end
        
        % --- Update State for Next Turn ---
        guessIndex = find(strcmp(wordstr, nextGuess));
        resultCode = matchCodes(guessIndex, i);
        solutionCols = find(matchCodes(guessIndex, :) == resultCode);
        remainingIndices = intersect(remainingIndices, solutionCols);
        
        if isempty(remainingIndices)
            break;
        end
    end
    
    % --- Display Word-by-Word Results (if enabled) ---
    if showWordByWordResults
        if ~isWin
            guessDistribution(i) = practicalTurnLimit + 1;
            fprintf('Word #%d (%s): Failed to solve\n', i, solution);
        else
            fprintf('Word #%d (%s): Solved in %d guesses\n', i, solution, guessDistribution(i));
        end
    end
end

totalTime = toc(startTime);
fprintf('\nAll simulations completed in %.2f seconds.\n\n', totalTime);

%% ========================================================================
%  3. ANALYSIS & REPORTING
%  ========================================================================
fprintf('--- Algorithm Performance Analysis ---\n');
wordleGuessLimit = 6;
winsInSix = guessDistribution(guessDistribution <= wordleGuessLimit);
averageGuesses = mean(guessDistribution(guessDistribution <= practicalTurnLimit));
winPercentage = 100 * numel(winsInSix) / numSolutions;

fprintf('Average number of guesses: %.3f\n', averageGuesses);
fprintf('Win percentage (solved in %d guesses or less): %.2f%%\n', wordleGuessLimit, winPercentage);

% --- Display Histogram ---
figure;
h = histogram(guessDistribution, 'BinMethod', 'integers');
grid on;
title('Wordlebot Solver Performance');
xlabel('Number of Guesses to Solve');
ylabel('Number of Words Solved');
maxTick = max(guessDistribution);
ticks = 1:maxTick;
labels = string(ticks);
if any(guessDistribution > practicalTurnLimit)
    labels(end) = "Fail";
end
xticks(ticks);
xticklabels(labels);

