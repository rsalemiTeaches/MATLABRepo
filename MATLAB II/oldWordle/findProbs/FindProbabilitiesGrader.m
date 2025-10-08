testData = randi(3, 5,5);


probs = findprobabilities(testData);
probs2 = findprobabilities(testData);

answer = probs;
reference = probs2;

if ~isequal(answer, reference)
    CorrectString = sprintf("Probabilities are Incorrect:\nCorrect: [%s]",join(string(reference)));
    YourString = sprintf("Your Probabilities: [%s]",join(string(answer)));
    error("Probs are incorrect:\n%s\n%s",CorrectString, YourString)
end



