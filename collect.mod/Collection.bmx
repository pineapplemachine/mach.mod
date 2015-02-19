superstrict

rem
    
    Data structures:
        IMPLEMENTED
            Random access list (List)
        PARTIAL
            Binary heap (Heap)
        TODO
            Splayed and red-black binary search trees (Tree)
            Trie (Trie)
            Hash table (Hash)
            Multimap: a Hash containing Lists (MMap)
            Linked list (LList)
            Thread-safe list (ThreadedList)
            Thread-safe hash (ThreadedHash)
            N-dimensional vectors (Vector)
            N-dimensional matricies (Matrix)
            Graph (Graph)
            Bit array (Bits)
            Bignum (Bignum)
            N-dimensional spatial hash (SHash)
            Cache (Cache)
            Ordered list (OList)
    
endrem

' base collection class
type Collection abstract

    ' object to throw when attempting to call a method that isn't implemented for some collection
    const EXCEPTION_UNIMPLEMENTED$ = "operation is not applicable to this class"

    ' return an enumerator for the items in the collection
    method enum:Enumerator()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' clear all items from the collection
    method clear:Collection()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' return the total number of items in the collection
    method size%()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' returns true if the collection is empty, false otherwise
    method empty%()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' insert all items from another similar collection into this one
    method extend:Collection( other:Collection )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' verify whether a value appears in the collection
    method contains%( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' count the number of times a specified value appears in the collection
    method count%( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' create a shallow copy of a Collection
    method copy:Collection()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
end type

' base enumerator class (every collection class should have at least one accompanying enumerator)
type Enumerator abstract
    method hasnext%() abstract
    method nextitem:object() abstract
end type