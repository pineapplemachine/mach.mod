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
            Rope
            Skip list
    
endrem

' base collection class
type Collection abstract

    ' object to throw when attempting to call a method that isn't implemented for some collection
    const EXCEPTION_UNIMPLEMENTED$ = "operation is not applicable to this class"

    ' return an enumerator for the items in the collection
    method enum:Enumerator()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method ObjectEnumerator:Enumerator() ' allows eachin support
        return enum()
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
    ' create a collection using the values in an array
    method array:Collection( array:object[] )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' get string representation
    method tostring$()
        return csv()
    end method
    method csv$( delimiter$=",", nullstring$="" )
        local first% = true
        local str$ = ""
        for local value:object = eachin self
            if not first str :+ delimiter
            first = false
            if value
                str :+ value.tostring()
            else
                str :+ nullstring
            endif
        next
        return str
    end method
    
end type

' base enumerator class (every collection class should have at least one accompanying enumerator)
type Enumerator abstract
    method hasnext%() abstract
    method nextobject:object() abstract
    method ObjectEnumerator:Enumerator()
        return self
    end method
end type