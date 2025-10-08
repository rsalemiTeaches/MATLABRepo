% =========================================================================
% Project 1: Adventurer's Treasure Log (Student Template)
%
% Your Mission: Fill in the missing code, indicated by 'NaN'.
% Use the comments above each section as your guide to complete the script.
% =========================================================================

% --- Script Setup ---
% Good practice: clear the command window, workspace variables, and close figures
clc;
clear;
close all;


% --- PART 1: Define Initial Data ---
fprintf('--- Setting up the initial party funds and loot ---\n\n');

% Define a 3x1 list of the adventurers for easy display later.
partyMembers = ["Fighter"; "Wizard"; "Rogue"];

% TODO: Define the party's current funds.
% This should be a 3x3 matrix.
% Rows: Fighter, Wizard, Rogue
% Columns: Copper Pieces (CP), Silver Pieces (SP), Gold Pieces (GP)
% Fighter: 250 CP, 50 SP, 10 GP
% Wizard:  100 CP, 80 SP, 25 GP
% Rogue:   150 CP, 30 SP, 15 GP
partyFunds = [ NaN   NaN   NaN;  % Fighter's funds
               NaN   NaN   NaN;  % Wizard's funds
               NaN   NaN   NaN]; % Rogue's funds

disp('Initial Party Funds (CP, SP, GP):');
disp(partyFunds);


% TODO: Define the contents of the newly discovered treasure chest.
% This should also be a 3x3 matrix with the same structure.
% Fighter finds: 95 CP, 15 SP, 5 GP
% Wizard finds:  120 CP, 10 SP, 8 GP
% Rogue finds:   105 CP, 25 SP, 6 GP
chestLoot = [ NaN   NaN   NaN;   % Loot for Fighter
             NaN   NaN   NaN;   % Loot for Wizard
             NaN   NaN   NaN];  % Loot for Rogue

disp('Treasure Found in Chest (CP, SP, GP):');
disp(chestLoot);


% --- PART 2: Perform Core Calculations ---
fprintf('\n--- Performing core calculations ---\n\n');

% TODO: Calculate the new total funds for each party member.
% Perform element-wise addition on partyFunds and chestLoot.
newTotals = NaN;

disp('New Total Funds for Each Party Member (CP, SP, GP):');
disp(newTotals);


% --- PART 3: Answering Specific Questions ---
fprintf('\n--- Answering specific questions for the party ---\n\n');

% Question 1: How many Silver Pieces (SP) did the Fighter start with?
% TODO: Access the element in the first row, second column of the partyFunds matrix.
FighterStartSilver = NaN;
fprintf('Answer 1: The Fighter started with %d Silver Pieces.\n\n', FighterStartSilver);


% Question 2: What is the total number of physical coins each member has?
% We use matrix multiplication with a 3x1 vector of ones.
coinCounter = [1; 1; 1];
% TODO: Multiply the newTotals matrix by the coinCounter vector.
totalCoinsPerMember = NaN;

fprintf('Answer 2: Total number of coins per member:\n');
for i = 1:length(partyMembers)
    fprintf('  - %s: %d total coins\n', partyMembers(i), totalCoinsPerMember(i));
end
fprintf('\n');


% Question 3: What is the total value of each member's wealth in Gold Pieces?
% Conversion rates: 1 CP = 0.01 GP, 1 SP = 0.1 GP, 1 GP = 1 GP
gpConversionVector = [0.01; 0.1; 1];
% TODO: Multiply the newTotals matrix by the gpConversionVector.
totalWealthInGold = NaN;

fprintf('Answer 3: Total wealth converted to Gold Pieces (GP):\n');
for i = 1:length(partyMembers)
   % TODO: Use fprintf to create three lines such as " - Fighter: 43.2 GP"
end
fprintf('\n');


% Question 4: Display a complete list of the Rogue's final coin counts.
% TODO: Access all columns (:) of the third row of the newTotals matrix.
rogueFinalFunds = NaN;
% TODO: Use fprintf to create a line 
% TODO: such as "The Rogue's final funds are: 23 CP, 22 SP, and 3 GP"


% Question 5: Which party member is the wealthiest?
% First, calculate total wealth in a standard currency (Copper Pieces).
% Conversion rates: 1 CP = 1 CP, 1 SP = 10 CP, 1 GP = 100 CP
copperValue = [1; 10; 100];
% TODO: Multiply the newTotals matrix by the copperValue vector.
totalWealthInCopper = NaN;

% Now, find the maximum value and its index in the resulting vector.
% TODO: Use the max() function to find the largest value in totalWealthInCopper
% and the index of that value. The function should return two outputs.
[maxWealth, richestIndex] = NaN;
richestMember = partyMembers(richestIndex);

% TODO: Convert the final copper value (maxWealth) to gold for a more complete answer.
% Remember, there are 100 copper pieces in a gold piece.
maxWealthInGold = NaN;

% TODO: Write the fprintf statement to display the final answer.
% It should print a sentence that includes the richest member's name (a string),
% their wealth in copper (an integer), and their wealth in gold (a float with 2 decimal places).
% Use the variables: richestMember, maxWealth, and maxWealthInGold.
NaN;

