%% WORDLEBOT ALGORITHM TESTBENCH
% This script tests a student's complete Wordle solver function. It runs
% the student's function against every possible solution word, calculates
% performance statistics, and displays a histogram of the results.
%
% To Use:
% 1. Make sure 'WordleData.mat' is in the same folder.
% 2. Make sure your solver file, 'myWordleSolver.m', is in the same folder.
% 3. Run this script from the MATLAB Command Window by typing: runMySolver

% --- Created with assistance from Gemini. ---

%% 0. CONFIGURATION
% Set this flag to 'true' to run a quick test on a subset of words.
isTestMode = false;

% If isTestMode is true, this number determines how many words to test.
numTestWords = 100;

%% 1. SETUP
% clc;
fprintf('Starting Wordlebot Testbench...\n');

% Conditionally load data only if it's not already in the workspace.
if ~exist('wordstr', 'var') || ~exist('matchCodes', 'var') || ~exist('initProb', 'var') || ~exist('solutions', 'var')
    fprintf('Data not in workspace. Loading from WordleData.mat...\n');
    load('WordleData.mat', 'wordstr', 'matchCodes', 'initProb', 'solutions');
else
    fprintf('Using existing data from workspace.\n');
end

xx = readtable("possible_words.txt","ReadVariableNames", false);
solutions = xx.Var1;


% Validate that the student's solver file exists.
if ~exist('myWordleSolver.m', 'file')
    error('FATAL: myWordleSolver.m not found. Please ensure your file is in the same folder and named correctly.');
end
fprintf('Student solver function found.\n\n');

%% 2. SIMULATION
if isTestMode
    solutionsToTest = solutions(1:numTestWords);
    fprintf('>>> RUNNING IN QUICK TEST MODE (%d words) <<<\n', numTestWords);
else
    solutionsToTest = solutions;
    fprintf('>>> RUNNING IN FULL SIMULATION MODE (%d words) <<<\n', numel(solutions));
end

numSolutions = numel(solutionsToTest);
guessDistribution = zeros(numSolutions, 1);

fprintf('Running simulations for %d words. This may take a few minutes...\n', numSolutions);
startTime = tic; % Start a timer

% Loop through every possible solution word.
for i = 1:numSolutions
    % Call the student's self-contained solver function for each solution.
    guessDistribution(i) = myWordleSolver(solutionsToTest(i), wordstr, matchCodes, initProb);
end

totalTime = toc(startTime);
fprintf('\nAll simulations completed in %.2f seconds (%.1f words/sec).\n\n', totalTime, numSolutions/totalTime);

%% 3. ANALYSIS & REPORTING
fprintf('--- Algorithm Performance Analysis ---\n\n');

% --- Performance Statistics ---
averageGuesses = mean(guessDistribution);
winPercentage = 100 * sum(guessDistribution <= 6) / numSolutions;

fprintf('Average number of guesses: %.4f\n', averageGuesses);
fprintf('Win percentage (solved in 6 guesses or less): %.2f%%\n\n', winPercentage);

% --- Scoring based on Brian Falkner's benchmarks ---
fprintf('--- Performance Score ---\n');
if averageGuesses < 3.5
    score = "A+ (Oracle Tier)";
    explanation = "This is an exceptionally high-performance score, competitive with the best known algorithms.";
elseif averageGuesses < 3.7
    score = "A (Excellent)";
    explanation = "A very strong score, indicating a highly effective and intelligent guessing strategy.";
elseif averageGuesses < 4.0
    score = "B (Very Good)";
    explanation = "A solid score that shows a good understanding of the core concepts. A great result.";
elseif averageGuesses < 4.5
    score = "C (Good)";
    explanation = "This score indicates a functional algorithm that successfully solves most words.";
else
    score = "Needs Improvement";
    explanation = "The algorithm works, but there is significant room to improve its strategic guessing.";
end
fprintf('Score: %s\n', score);
fprintf('Analysis: %s\n\n', explanation);


% --- Display Histogram ---
figure;
histogram(guessDistribution, 'BinMethod', 'integers');
title('Wordlebot Solver Performance');
xlabel('Number of Guesses to Solve');
ylabel('Number of Words Solved');
grid on;

