function mergedVals = conditionalMerge(AA,BB, mergeBits)
    %CONDITIONALMERGE This function merges two matrices based on the
    % logical values in MergeBits. The three arrays must be the 
    % same length. We throw an error otherwise.
    if ~isequal(size(AA), size(BB), size(mergeBits))
         error('The three matrices must be the same size.');
    end
    if ~isa(mergeBits, 'logical')
         error('mergeBits matrix must be of class logical.');
    end

    mergedVals = BB;
    mergedVals(mergeBits) = AA(mergeBits);
end