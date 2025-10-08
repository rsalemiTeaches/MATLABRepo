function sortedArray = BubbleSort(ia)
    needSorting = ia(1:end-1) > ia(2:end)
    while nnz(needSorting) > 0
        low = logical([needSorting 0])
        high = logical([0 needSorting])
        temp = ia(low)
        ia(low)= ia(high)
        ia(high) = temp
        needSorting = ia(1:end-1) > ia(2:end)
    end
    sortedArray = ia;


    
end
