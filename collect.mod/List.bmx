' credit to those beautiful souls who have posted and discussed the details of Python's native list implementation, especially Laurent Luce
' http://www.laurentluce.com/posts/python-list-implementation/

superstrict
import "CollectionIndexedDynamic.bmx"
import "CollectionSorter.bmx"

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
    Clear
        Best case: O(1)
        Worst case: O(1) + Memory reallocation
    Copy
        Always: O(n)
    Reverse
        Always: O(n/2)
    Shuffle
        Always: O(n)
endrem
type List extends CollectionIndexedDynamic

    ' initialize
    method init:List( size%=0 )
        initbuffer( size )
        return self
    end method
    
    method set:Collection( index%, value:object )
        assert buffer and index>=0 and index<length
        buffer[index] = value
        return self
    end method
    method get:object( index% )
        assert buffer and index>=0 and index<length
        return buffer[index]
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
        shiftright( index, length-1 )
        buffer[index] = value
        return self
    end method
    method remove:object( index% )
        assert buffer and index>=0 and index<length
        local value:object = buffer[index]
        shiftleft( index+1, length )
        length :- 1
        autobufferdec()
        return value
    end method
    
    method copy:Collection()
        local target:List = new List.init( buffersize )
        copybuffer( target )
        return target
    end method
    
    ' override extend method to do things with less overhead
    method extend:Collection( other:Collection )
        ' affect length and buffer size all at once
        assert buffer
        local index% = length
        length :+ other.size()
        autobufferinc()
        ' add the items
        local otherindexed:List = List( other )
        if otherindexed ' if the other object is also a list, do some quick copying without worrying about an enumerator
            const OBJECT_POINTER_SIZE% = 4 ' number of bytes comprising an object pointer
            memcopy( byte ptr(buffer) + index, byte ptr(otherindexed.buffer), otherindexed.length * OBJECT_POINTER_SIZE )
        else
            local itr:Enumerator = other.enum()
            while itr.hasnext()
                buffer[index] = itr.nextitem()
                index :+ 1
            wend
        endif
        return self
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
    
    ' internal utility methods
    method shiftleft( lowbound%, highbound%, distance%=1 )
        for local i% = lowbound until highbound
            buffer[i-distance] = buffer[i]
        next
    end method
    method shiftright( lowbound%, highbound%, distance%=1 )
        for local i% = highbound-1 to lowbound step -1
            buffer[i+distance] = buffer[i]
        next 
    end method
    
end type