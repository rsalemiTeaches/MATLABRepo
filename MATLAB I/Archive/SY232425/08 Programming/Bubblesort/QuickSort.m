function sortedArray = QuickSort(ia)
    alen = length(ia);

    % handle degenerate case
    if alen <= 1
        sortedArray = ia
        return;
    end
    pivot = floor(alen / 2);
    


    lpart = ia(ia < ia(pivot))
    hpart = ia(ia > ia(pivot))
    ia(1:pivot-1) = lpart
    ia(pivot+1:end) = hpart
    ia(1:pivot-1) = QuickSort(ia(1:pivot-1))
    ia(pivot+1:end) = QuickSort(ia(pivot+1:end))
    
    sortedArray = ia;

end
