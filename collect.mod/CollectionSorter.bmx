superstrict

rem
    
    Sorting algorithms:
        IMPLEMENTED
            
        PARTIAL
            Merge sort
        TODO
            Quicksort
            Shell sort
            Bubble sort
    
endrem

' base sorter class
type CollectionSorter abstract

    ' ordering constants
    const ORDER_DESCENDING% = -1
    const ORDER_ASCENDING% = 1
    
    ' specify sorter behavior
    field ordering%
    field comparefunc%( obj0:object, obj1:object )
    
    ' initialize
    method init:CollectionSorter( order%=CollectionSorter.ORDER_DESCENDING, compare%(o0:object,o1:object)=null )
        if compare = null compare = CollectionSorter.defaultcomparefunc
        ordering = order
        comparefunc = compare
        return self
    end method
    
    ' inheriting classes must implement this method
    method sortarray:CollectionSorter( array:object[], length% ) abstract
    
    ' default comparison function for sorting collections
    ' a comparison function should return:
    '   +1 when object 0 is greater than object 1
    '    0 when object 0 is equal to object 1
    '   -1 when object 0 is lesser than object 1
    function defaultcomparefunc%( obj0:object, obj1:object )
        return obj0.compare( obj1 )
    end function

end type