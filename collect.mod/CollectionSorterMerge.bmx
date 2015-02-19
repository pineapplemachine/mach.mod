' Many thanks to the poster rcgldr whose code was used as a basis
' http://cboard.cprogramming.com/c-programming/158635-merge-sort-top-down-versus-bottom-up-5-print.html

superstrict
import "CollectionSorter.bmx"

rem
    Top-down merge sort
    Average and worst case: O(n log n)
endrem
type CollectionSorterMerge extends CollectionSorter
    
    method sortarray:CollectionSorter( array:object[], length% )
        MergeSort( array, 0, length, ordering, comparefunc )
        return self
    end method
    
    ' utility functions
    function MergeSort( array:object[], lowerbound%, upperbound%, ordering%, comparefunc(o0:object,o1:object) )
        local buffer:object[] = new object[upperbound]
        MergeSort_AtoA( array, buffer, lowerbound, upperbound, ordering, comparefunc )
    end function
    function MergeSort_AtoA( array:object[], buffer:object[], lowerbound%, upperbound%, ordering%, comparefunc(o0:object,o1:object) )
        if upperbound - lowerbound > 1
            local midpoint% = (upperbound + lowerbound) shr 1
            MergeSort_AtoB( array, buffer, lowerbound, midpoint, ordering, comparefunc )
            MergeSort_AtoB( array, buffer, midpoint, upperbound, ordering, comparefunc )
            MergeSort_Merge( buffer, array, lowerbound, midpoint, upperbound, ordering, comparefunc )
        endif
    end function
    function MergeSort_AtoB( array:object[], buffer:object[], lowerbound%, upperbound%, ordering%, comparefunc(o0:object,o1:object) )
        local length% = upperbound - lowerbound
        if length > 1
            local midpoint% = (upperbound + lowerbound) shr 1
            MergeSort_AtoA( array, buffer, lowerbound, midpoint, ordering, comparefunc )
            MergeSort_AtoA( array, buffer, midpoint, upperbound, ordering, comparefunc )
            MergeSort_Merge( array, buffer, lowerbound, midpoint, upperbound, ordering, comparefunc )
        elseif length = 1
            buffer[ lowerbound ] = array[ lowerbound ]
        endif
    end function
    function MergeSort_Merge( array:object[], buffer:object[], lowerbound%, midpoint%, upperbound%, ordering%, comparefunc(o0:object,o1:object) )
        local i% = lowerbound, j% = midpoint, k%
        for k = lowerbound until upperbound
            if j >= upperbound or ( (i < midpoint) and not (comparefunc( array[i], array[j] ) = ordering) )
                buffer[k] = array[i]
                i :+ 1
            else
                buffer[k] = array[j]
                j :+ 1
            endif
        next
    end function
    
end type

