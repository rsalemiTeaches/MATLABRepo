xx = readtable('words5.txt',"ReadVariableNames",false);
wordstr = string(xx.Var1);
mc = findMatchCodes('words5.txt');
prob = findprobabilities(mc);
guess = findGuess(prob,wordstr)


