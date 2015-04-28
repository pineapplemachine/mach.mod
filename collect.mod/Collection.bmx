superstrict
import "CollectionSorter.bmx"

rem
    
    Data structures:
        IMPLEMENTED
            AList   Arraylist
            LList   Cyclic doubly-linked list
            Heap    Binary heap
            UTree   Unstructured tree
        PARTIAL
            Hash    Hash table
            DMap    novel?
        TODO
            BTree   Binary search tree
            Trie    Trie
            Graph   Graph with edges and nodes
            Cache   Cache
            MMap    Multimap
            ThList  Thread-safe list
            ThHash  Thread-safe hash
            Vector  N-dimensional vector
            Matrix  N-dimensional matrix
            Bits    Bit array
            Bignum  Arbitrary-precision number
            SHash   Spatial hash
            OList   Ordered list
            Rope    Rope
            SList   Skip list
            UList   Unrolled linked list
            ITree   Interval tree
            STree   Segment tree
            QTree   Quadtree
            OTree   Octtree
    
endrem

' base collection class
type Collection abstract

    ' string to throw when attempting to call a method that isn't implemented for some collection
    const EXCEPTION_UNIMPLEMENTED$ = "Operation is not applicable to this class"
    ' string to throw when a weird out-of-bounds access happens
    const EXCEPTION_WEIRD_OOB$ = "Unanticipated index out of bounds"

    ' current number of items in the collection
    field length%
    
    ' return the total number of items in the collection
    method size%()
        return length
    end method
    ' returns true if the collection is empty, false otherwise
    method empty%()
        return length = 0
    end method

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
    ' clear all items from the collection without regard for how cozy it might rest with the GC
    method clearfast:Collection()
        return clear()
    end method
    ' insert all items from another similar collection into this one
    method extend:Collection( other:Collection )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' reverse the order of elements in the collection
    method reverse:Collection()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' randomize the order of elements in the collection
    method shuffle:Collection( randomfloat!() )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' sort the elements in a collection
    method sort:Collection( sorter:CollectionSorter )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' create a shallow copy of a Collection
    method copy:Collection()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' create a collection using the values in an array
    method array:Collection( values:object[] )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    ' verify whether a value appears in the collection
    method contains%( value:object )
        for local member:object = eachin self
            if member = value return true
        next
        return false
    end method
    ' count the number of times a specified value appears in the collection
    method count%( value:object )
        local sum% = 0
        for local member:object = eachin self
            sum :+ member = value
        next
        return sum
    end method
    
    ' get string representation
    method tostring$()
        return csv()
    end method
    method csv$( delimiter$=",", nullstring$="" )
        local firstitr% = true
        local str$ = ""
        for local value:object = eachin self
            if not firstitr str :+ delimiter
            firstitr = false
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

    ' inheriting classes must implement these methods
    method hasnext%() abstract
    method nextobject:object() abstract
    
    ' allows for smoother eachin support
    method ObjectEnumerator:Enumerator()
        return self
    end method
    
end type

' base node class (any collection using nodes should have those nodes inherit from this base class)
type CollectionNode abstract

    field value:object
    
end type