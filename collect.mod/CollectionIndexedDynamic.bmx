superstrict
import "CollectionIndexed.bmx"

' base class for collections which are both indexed and dynamically sized
' inheriting classes must store items continuously in the array (code is not equipped to cope with gaps)
type CollectionIndexedDynamic extends CollectionIndexed

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
    ' current number of items in the collection
    field length%
    
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
    method initbuffer( size% )
        if size <= 0 size = buffersizemin
        length = 0
        rebuffer( size )
    end method
    
    method enum:Enumerator()
        assert buffer
        return new EnumeratorIndexed.init( self, length )
    end method
    method clear:Collection()
        length = 0
        autobufferdec()
    end method
    method size%()
        return length
    end method
    method empty%()
        return length > 0
    end method
    
    ' override superclass's methods, do things with less overhead
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
        while buffersizeallowdec and length <= buffersizesparsetarget and buffersize > buffersizemin
            local newsize% = buffersize * buffersizedec
            rebuffer( newsize )
        wend
    end method
    method autobufferinc()
        while buffersizeallowinc and length >= buffersize and buffersize < buffersizemax
            local newsize% = buffersize * buffersizeinc
            rebuffer( newsize )
        wend
    end method
    
end type
