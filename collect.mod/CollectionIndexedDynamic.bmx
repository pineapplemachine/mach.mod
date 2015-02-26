superstrict
import "CollectionIndexed.bmx"

' base class for collections which are both indexed and dynamically sized
' inheriting classes must store items continuously in the array (code is not equipped to cope with gaps)
type CollectionIndexedDynamic extends CollectionIndexed abstract 

    ' number of bytes comprising an object pointer
    const OBJECT_POINTER_SIZE% = 4

    ' default buffer growth/shrink settings
    const BUFFER_SIZE_MIN% = 16
    const BUFFER_SIZE_MAX% = 2147483647
    const BUFFER_ALLOW_INCREASE% = true
    const BUFFER_ALLOW_DECREASE% = true
    const BUFFER_SIZE_INCREASE# = 1.5
    const BUFFER_SIZE_DECREASE# = 0.5
    const BUFFER_SIZE_SPARSENESS# = 0.25
 
    ' contains pointers to collected items
    field buffer:object[]
    ' current size of the buffer
    field buffersize%=0
    
    ' keep buffer size within these bounds
    field buffersizemin% = BUFFER_SIZE_MIN
    field buffersizemax% = BUFFER_SIZE_MAX
    ' factor by which to increase/decrease buffer size
    field buffersizeinc# = BUFFER_SIZE_INCREASE
    field buffersizedec# = BUFFER_SIZE_DECREASE
    ' booleans determine whether the collection is allowed to grow/shrink
    field buffersizeallowinc% = BUFFER_ALLOW_INCREASE
    field buffersizeallowdec% = BUFFER_ALLOW_DECREASE
    ' decrease buffer size when length / buffersize is less than or equal to this
    field buffersizesparse# = BUFFER_SIZE_SPARSENESS
    ' tracks specific length at which the collection is considered sparse enough to shrink
    field buffersizesparsetarget%
    
    ' generalized init method
    method initbuffer( size%=0 )
        if size <= 0 size = buffersizemin
        length = 0
        rebuffer( size )
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
    
    method enum:Enumerator()
        assert buffer
        return new EnumeratorIndexedDynamic.init( self, length )
    end method
    method clear:Collection()
        length = 0
        autobufferdec()
        for local i% = 0 until buffer.length
            buffer[i] = null
        next
        return self
    end method
    method clearfast:Collection()
        length = 0
        return self
    end method
    method array:Collection( values:object[] )
        assert values
        rebuffer( values.length )
        for local value:object = eachin values
            push( value )
        next
        return self
    end method
    
    ' override superclass's methods, do things with less overhead
    method contains%( value:object )
        for local i% = 0 until length
            if buffer[i] = value return true
        next
        return false
    end method
    method count%( value:object )
        local sum% = 0
        for local i% = 0 until length
            sum :+ buffer[i] = value
        next
        return sum
    end method

    ' copy buffer from one collection to another
    method copybuffer( target:Collection )
        local targ:CollectionIndexedDynamic = CollectionIndexedDynamic( target )
        targ.buffersizemin = buffersizemin
        targ.buffersizemax = buffersizemax
        targ.buffersizedec = buffersizedec
        targ.buffersizeinc = buffersizeinc
        targ.buffersizeallowinc = buffersizeallowinc
        targ.buffersizeallowdec = buffersizeallowdec
        targ.buffersizesparse = buffersizesparse
        targ.buffersizesparsetarget = buffersizesparsetarget
        targ.buffersize = buffersize
        targ.length = length
        targ.buffer = buffer[..]
    end method
    
    ' set parameters for buffer resizing
    method setbuffer:CollectionIndexedDynamic( minsize%, maxsize%, decsize#, incsize#, decallow%, incallow%, sparse# )
        buffersizemin = minsize
        buffersizemax = maxsize
        buffersizedec = decsize
        buffersizeinc = incsize
        buffersizeallowinc = incallow
        buffersizeallowdec = decallow
        buffersizesparse = sparse
        buffersizesparsetarget = buffersize * buffersizesparse
    end method
    
    ' enable/disable dynamic resizing
    method dynamicresize:CollectionIndexedDynamic( setting% )
        buffersizeallowinc = setting
        buffersizeallowdec = setting
        return self
    end method
    
    ' resize buffer and retain previous data
    method rebuffer( size% )
        if size < buffersizemin
            size = buffersizemin
        elseif size > buffersizemax
            size = buffersizemax
        endif
        assert size >= length
        if size <> buffersize
            buffersize = size
            if buffer
                buffer = buffer[..size]
            else
                buffer = new object[size]
            endif
            buffersizesparsetarget = buffersize * buffersizesparse
        endif
    end method
    
    ' methods to resize buffer as necessary
    method autobuffer()
        autobufferdec()
        autobufferinc()
    end method
    method autobufferdec()
        local newsize% = buffersize
        local newsparsetarget% = buffersizesparsetarget
        while buffersizeallowdec and length <= newsparsetarget and newsize > buffersizemin
            newsize :* buffersizedec
            newsparsetarget = newsize * buffersizesparse
        wend
        if newsize < buffersize rebuffer( newsize )
    end method
    method autobufferinc()
        local newsize% = buffersize
        while buffersizeallowinc and length >= newsize and newsize < buffersizemax
            newsize :* buffersizeinc
        wend
        if newsize > buffersize rebuffer( newsize )
    end method
    
    ' utility method for moving around groups of elements
    method movebuffer( src%, dst%, count% )
        if src > dst
            for local i% = 0 until count
                buffer[dst] = buffer[src]
                src :+ 1
                dst :+ 1
            next
        else
            src :+ count
            dst :+ count
            for local i% = 0 until count
                src :- 1
                dst :- 1
                buffer[dst] = buffer[src]
            next
        endif
    end method
    
end type



' enumerate over the items contained within CollectionIndexedDynamic object
type EnumeratorIndexedDynamic extends Enumerator
    field target:CollectionIndexedDynamic
    field index%
    field bound%
    method init:EnumeratorIndexedDynamic( t:CollectionIndexedDynamic, b% )
        target = t
        bound = b
        return self
    end method
    method hasnext%()
        return index < bound
    end method
    method nextobject:object()
        local value:object = target.buffer[ index ]
        index :+ 1
        return value
    end method
end type
