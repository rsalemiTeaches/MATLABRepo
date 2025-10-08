% =========================================================================
% Project 1: Adventurer's Treasure Log (Solution)
%
% Your Mission: Fill in the missing code, indicated by '...'.
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
partyFunds = [ 250   50   10;  % Fighter's funds
               100   80   25;  % Wizard's funds
               150   30   15]; % Rogue's funds

disp('Initial Party Funds (CP, SP, GP):');
disp(partyFunds);


% TODO: Define the contents of the newly discovered treasure chest.
% This should also be a 3x3 matrix with the same structure.
% Fighter finds: 95 CP, 15 SP, 5 GP
% Wizard finds:  120 CP, 10 SP, 8 GP
% Rogue finds:   105 CP, 25 SP, 6 GP
chestLoot = [ 95   15    5;   % Loot for Fighter
             120   10    8;   % Loot for Wizard
             105   25    6];  % Loot for Rogue

disp('Treasure Found in Chest (CP, SP, GP):');
disp(chestLoot);


% --- PART 2: Perform Core Calculations ---
fprintf('\n--- Performing core calculations ---\n\n');

% TODO: Calculate the new total funds for each party member.
% Perform element-wise addition on partyFunds and chestLoot.
newTotals = partyFunds + chestLoot;

disp('New Total Funds for Each Party Member (CP, SP, GP):');
disp(newTotals);


% --- PART 3: Answering Specific Questions ---
fprintf('\n--- Answering specific questions for the party ---\n\n');

% Question 1: How many Silver Pieces (SP) did the Fighter start with?
% TODO: Access the element in the first row, second column of the partyFunds matrix.
FighterStartSilver = partyFunds(1, 2);
fprintf('Answer 1: The Fighter started with %d Silver Pieces.\n\n', FighterStartSilver);


% Question 2: What is the total number of physical coins each member has?
% We use matrix multiplication with a 3x1 vector of ones.
coinCounter = [1; 1; 1];
% TODO: Multiply the newTotals matrix by the coinCounter vector.
totalCoinsPerMember = newTotals * coinCounter;

fprintf('Answer 2: Total number of coins per member:\n');
for i = 1:length(partyMembers)
    fprintf('  - %s: %d total coins\n', partyMembers(i), totalCoinsPerMember(i));
end
fprintf('\n');


% Question 3: What is the total value of each member's wealth in Gold Pieces?
% Conversion rates: 1 CP = 0.01 GP, 1 SP = 0.1 GP, 1 GP = 1 GP
gpConversionVector = [0.01; 0.1; 1];
% TODO: Multiply the newTotals matrix by the gpConversionVector.
totalWealthInGold = newTotals * gpConversionVector;

fprintf('Answer 3: Total wealth converted to Gold Pieces (GP):\n');
for i = 1:length(partyMembers)
    fprintf('  - %s: %.2f GP\n', partyMembers(i), totalWealthInGold(i));
end
fprintf('\n');


% Question 4: Display a complete list of the Rogue's final coin counts.
% TODO: Access all columns (:) of the third row of the newTotals matrix.
rogueFinalFunds = newTotals(3, :);
fprintf('Answer 4: The Rogue''s final funds are: %d CP, %d SP, and %d GP.\n\n', ...
        rogueFinalFunds(1), rogueFinalFunds(2), rogueFinalFunds(3));


% Question 5: Which party member is the wealthiest?
% First, calculate total wealth in a standard currency (Copper Pieces).
% Conversion rates: 1 CP = 1 CP, 1 SP = 10 CP, 1 GP = 100 CP
copperValue = [1; 10; 100];
% TODO: Multiply the newTotals matrix by the copperValue vector.
totalWealthInCopper = newTotals * copperValue;

% Now, find the maximum value and its index in the resulting vector.
% TODO: Use the max() function to find the largest value in totalWealthInCopper
% and the index of that value. The function should return two outputs.
[maxWealth, richestIndex] = max(totalWealthInCopper);
richestMember = partyMembers(richestIndex);

% Convert the final copper value to gold for a more complete answer.
maxWealthInGold = maxWealth / 100;

fprintf('Answer 5: The wealthiest party member is the %s, with a total net worth of %d Copper Pieces (%.2f GP).\n', ...
        richestMember, maxWealth, maxWealthInGold);
