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
    
    ' convert collection to/from array
    method toarray:object[]()
        local length% = size()
        local index% = 0
        local array:object[] = new object[ length ]
        local itr:Enumerator = enum()
        while itr.hasnext()
            array[index] = itr.nextitem()
            index :+ 1
        wend
        return array
    end method
    method fromarray:CollectionIndexed( array:object[] )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    method extend:Collection( other:Collection )
        ' compiler doesn't like using eachin here for some reason
        local itr:Enumerator = other.enum()
        while itr.hasnext()
            push( itr.nextitem() )
        wend
        return self
    end method
    method contains%( value:object )
        local itr:Enumerator = enum()
        while itr.hasnext()
            if itr.nextitem() = value return true
        wend
        return false
    end method
    method count%( value:object )
        local sum% = 0
        local itr:Enumerator = enum()
        while itr.hasnext()
            sum :+ itr.nextitem() = value
        wend
        return sum
    end method
    
    ' get string representation
    method tostring$()
        return csv()
    end method
    method csv$( delimiter$=",", nullstring$="" )
        local first% = true
        local str$ = ""
        local itr:Enumerator = enum()
        while itr.hasnext()
            if not first str :+ delimiter
            first = false
            local value:object = itr.nextitem()
            if value
                str :+ value.tostring()
            else
                str :+ nullstring
            endif
        wend
        return str
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
    method nextitem:object()
        local value:object = target.get( index )
        index :+ 1
        return value
    end method
end type