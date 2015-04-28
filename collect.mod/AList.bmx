' credit to those beautiful souls who have posted and discussed the details of Python's native list implementation, especially Laurent Luce
' http://www.laurentluce.com/posts/python-list-implementation/

superstrict
import "CollectionIndexedDynamic.bmx"

rem
    Random access list implemented using a dynamically sized array
    Memory reallocation can be disallowed by setting a known maximum size and calling list.dynamicresize(false)
    Get/Set (random access)
        Always: O(1)
    Push/Pop (access last element)
        Best case: O(1)
        Worst case: O(1) + Memory reallocation
    Insert/Remove (random insertion/removal)
        Average case: O(n/2)
        Worst case: O(n) + Memory reallocation
    Reverse
        Always: O(n/2)
    Shuffle
        Always: O(n)
endrem
type AList extends CollectionIndexedDynamic

    ' initialize
    method init:AList( size%=0 )
        initbuffer( size )
        return self
    end method
    
    method push:Collection( value:object )
        assert buffer
        length :+ 1
        autobufferinc()
        buffer[length-1] = value
        return self
    end method
    method pop:object()
        assert buffer and length
        local value:object = buffer[length-1]
        length :- 1
        autobufferdec()
        return value
    end method
    
    method insert:Collection( index%, value:object )
        assert buffer and index>=0 and index<length
        length :+ 1
        autobufferinc()
        movebuffer( index, index+1, length-index )
        buffer[index] = value
        return self
    end method
    method remove:object( index% )
        assert buffer and index>=0 and index<length
        local value:object = buffer[index]
        movebuffer( index+1, index, length-index-1 )
        length :- 1
        autobufferdec()
        return value
    end method
    
    method pusharray:CollectionIndexed( other:object[] )
        insarray( length, other )
        return self
    end method
    method pushcollection:CollectionIndexed( other:Collection )
        inscollection( length, other )
        return self
    end method
    method insertarray:CollectionIndexed( index%, other:object[] )
        insarray( index, other )
        return self
    end method
    method insertcollection:CollectionIndexed( index%, other:Collection )
        inscollection( index, other )
        return self
    end method
    
    method copy:Collection()
        local target:AList = new AList
        copybuffer( target )
        return target
    end method
    
    ' override extend method to do things with less overhead
    method extend:Collection( other:Collection )
        return insertcollection( length, other )
    end method
    
    ' reverse order of items in collection in-place
    method reverse:Collection()
        assert buffer and length
        for local i% = 0 until length shr 1
            local j% = length-i-1
            local t:object = buffer[i]
            buffer[i] = buffer[j]
            buffer[j] = t
        next
        return self
    end method
    
    ' randomize order of items in-place using knuth shuffle
    ' the randomfloat function should return a value in the range [0,1)
    method shuffle:Collection( randomfloat!() )
        local index% = length-1
        while index > 0
            local randindex% = randomfloat() * index
            index :- 1
            local t:object = buffer[index]
            buffer[index] = buffer[randindex]
            buffer[randindex] = t
        wend
        return self
    end method
    
    ' sort items in collection (merge sort recommended)
    method sort:Collection( sorter:CollectionSorter )
        sorter.sortarray( buffer, length )
        return self
    end method
    
    ' utility methods for group pushing/insertion
    method insarray( index%, other:object[] )
        assert other and buffer and index>=0 and index<=length
        if other.length
            ' allocate space for new elements
            local oldlength% = length
            length :+ other.length
            autobufferinc()
            ' shift existing elements to the right
            if index < oldlength movebuffer( index, index+other.length, oldlength-index )
            ' insert the elements
            for local j% = 0 until other.length
                buffer[index] = other[j]
                index :+ 1
            next
        endif
    end method
    method inscollection( index%, other:Collection )
        assert other and buffer and index>=0 and index<=length
        local otherlength% = other.size()
        if otherlength
            ' allocate space for new elements
            local oldlength% = length
            length :+ otherlength
            autobufferinc()
            ' shift existing elements to the right
            if index < oldlength movebuffer( index, index+otherlength, oldlength-index )
            ' insert the elements
            local otherindexed:CollectionIndexedDynamic = CollectionIndexedDynamic( other )
            if otherindexed
                ' do it a bit more efficiently if the other is also CollectionIndexedDynamic
                for local j% = 0 until otherlength
                    buffer[index] = otherindexed.buffer[j]
                    index :+ 1
                next
            else
                ' otherwise, use an enumerator
                for local value:object = eachin other
                    buffer[index] = value
                    index :+ 1
                next
            endif
        endif
    end method
    
end type