superstrict
import "CollectionIndexedDynamic.bmx"
import "CollectionSorter.bmx"

' Binary min/max heap implemented using a dynamically sized array
type Heap extends CollectionIndexedDynamic

    field buffersizeinc# = 2.0
    field buffersizedec# = 0.5

    field ordering%
    field comparefunc%( obj0:object, obj1:object )
    
    ' initialize heap
    method init:Heap( order%=CollectionSorter.ORDER_DESCENDING, compare%(o0:object,o1:object)=null, size%=0 )
        setorder( order, compare )
        initbuffer( size )
        return self
    end method
    
    method ObjectEnumerator:Enumerator() ' allows eachin support
        return enum()
    end method
    
    ' set ordering
    method setorder:Heap( order%, compare%(o0:object,o1:object)=null )
        assert length=0
        ordering = order
        if compare = null
            if not comparefunc comparefunc = CollectionSorter.defaultcomparefunc
        else
            comparefunc = compare
        endif
        return self
    end method
    
    method push:Collection( value:object )
        assert buffer and ordering and comparefunc
        local index% = length
        length :+ 1
        autobufferinc()
        buffer[index] = value
        bubbleup( index )
        return self
    end method
    method pop:object()
        assert buffer and length
        local value:object = buffer[0]
        length :- 1
        buffer[0] = buffer[length]
        bubbledown(0)
        autobufferdec()
        return value
    end method
    method array:Collection( array:object[] )
        assert ordering and comparefunc
        return super.array( array )
    end method
    method copy:Collection()
        local target:Heap = new Heap
        copybuffer( target )
        target.setorder( ordering, comparefunc )
        return target
    end method
    
    ' internal utility methods
    method bubbleup%( index% )
        local parent% = (index-1) shr 1
        while index > 0 and comparefunc( buffer[index], buffer[parent] ) = ordering
            local value:object = buffer[index]
            buffer[index] = buffer[parent]
            buffer[parent] = value
            index = parent
            parent = (parent-1) shr 1
        wend
        return index
    end method
    method bubbledown%( index% )
        local child% = (index shl 1) + 1
        while( child < length )
            if child+1 < length and comparefunc( buffer[child+1], buffer[child] ) = ordering child :+ 1
            if not( comparefunc( buffer[child], buffer[index] ) = ordering ) exit
            local value:object = buffer[index]
            buffer[index] = buffer[child]
            buffer[child] = value
            index = child
            child = (child shl 1) + 1
        wend
        return index
    end method
    
end type






