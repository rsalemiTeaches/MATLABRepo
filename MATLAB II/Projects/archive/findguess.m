
function guess = findguess(probMat, words, guessList)
    probMat(probMat == 0) = eps;
    allBits = probMat .* log(1 ./ probMat);
    totalBits = sum(allBits);
    [~, imax] = max(totalBits);
    guess = words(imax);
    while ismember(guess, guessList)
        totalBits(imax) = 0;
        [~, imax] = max(totalBits);
        guess = words(imax);
    end
end
