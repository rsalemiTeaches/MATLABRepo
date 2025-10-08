function probs = findprobabilities(matchCodes)
    probs = zeros(243, width(matchCodes));
    for col = 1:width(matchCodes)
        [~, grpVals, grpProbs] = groupcounts(matchCodes(:,col));
        probs(grpVals + 1,col) = grpProbs./100.0;
    end
end
