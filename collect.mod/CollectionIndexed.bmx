superstrict
import "Collection.bmx"

rem
    Base class for collections whose members are indexed
    Extend
        Always: O(n) for size of other collection
    Contains
        Average case: O(n/2)
        Worst case: O(n)
    Count
        Always: O(n)
endrem
type CollectionIndexed extends Collection abstract
    ' get first/last element
    method first:object()
        return get(0)
    end method
    method last:object()
        return get( size()-1 )
    end method
    
    ' get/set at index
    method set:Collection( loc%, value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method get:object( loc% )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' push/pop highest index
    method push:Collection( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method pop:object()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' insert/remove at arbitrary index
    method insert:Collection( loc%, value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method remove:object( loc% )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' insert/remove multiple at arbitrary index
    method insertgroup:CollectionIndexed( index%, value:object )
        if Collection( value ) return insertcollection( index, Collection( value ) )
        if object[]( value ) return insertarray( index, object[]( value ) )
        throw "Can't insert"
    end method
    method removegroup:CollectionIndexed( index%, count% )
        for local j% = 0 until count
            remove( index )
        next
        return self
    end method
    method insertarray:CollectionIndexed( index%, other:object[] )
        for local j% = 0 until other.length
            insert( index, other[j] )
            index :+ 1
        next
        return self
    end method
    method insertcollection:CollectionIndexed( index%, other:Collection )
        for local value:object = eachin other
            insert( index, value )
            index :+ 1
        next
        return self
    end method
    
    method extend:Collection( other:Collection )
        for local value:object = eachin other
            push( value )
        next
        return self
    end method
    method contains%( value:object )
        for local member:object = eachin self
            if member = value return true
        next
        return false
    end method
    method count%( value:object )
        local sum% = 0
        for local member:object = eachin self
            sum :+ member = value
        next
        return sum
    end method
end type

' enumerate over the items contained within CollectionIndexed object
type EnumeratorIndexed extends Enumerator
    field target:CollectionIndexed
    field index%
    field bound%
    method init:EnumeratorIndexed( t:CollectionIndexed, b% )
        target = t
        bound = b
        return self
    end method
    method hasnext%()
        return index < bound
    end method
    method nextobject:object()
        local value:object = target.get( index )
        index :+ 1
        return value
    end method
end type