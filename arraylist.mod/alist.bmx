superstrict
import "../list.mod/list.bmx"

type AListException extends CollectionException
end type
type AListBufferException extends AListException
end type

type AList extends List
    ' default buffer growth/shrink settings
    const BUFFER_SIZE_MIN% = 32
    const BUFFER_SIZE_MAX% = 2147483647
    const BUFFER_ALLOW_INCREASE% = true
    const BUFFER_ALLOW_DECREASE% = true
    const BUFFER_SIZE_INCREASE! = 1.5
    const BUFFER_SIZE_DECREASE! = 0.75
    const BUFFER_SIZE_SPARSENESS! = 0.25
    
    ' keep buffer size within these bounds
    field buffersizemin% = BUFFER_SIZE_MIN
    field buffersizemax% = BUFFER_SIZE_MAX
    ' factor by which to increase/decrease buffer size
    field buffersizeinc! = BUFFER_SIZE_INCREASE
    field buffersizedec! = BUFFER_SIZE_DECREASE
    ' booleans determine whether the collection is allowed to grow/shrink
    field buffersizeallowinc% = BUFFER_ALLOW_INCREASE
    field buffersizeallowdec% = BUFFER_ALLOW_DECREASE
    ' decrease buffer size when length / buffer.length is less than or equal to this
    field buffersizesparse! = BUFFER_SIZE_SPARSENESS
    ' tracks specific length at which the collection is considered sparse enough to shrink
    field buffersizesparsetarget%
    
    field length%
    field buffer:object[]
    
    method init:AList( size%=0 )
        initbuffer(size)
        return self
    end method
    method initbuffer( size%=0 )
        if size <= 0 size = buffersizemin
        length = 0
        rebuffer( size )
    end method
    
    method rebuffer( size% )
        if size < buffersizemin
            size = buffersizemin
        elseif size > buffersizemax
            size = buffersizemax
        endif
        if size < length throw new AListBufferException
        if size <> buffer.length
            if buffer
                buffer = buffer[..size]
            else
                buffer = new object[size]
            endif
            buffersizesparsetarget = buffer.length * buffersizesparse
        endif
    end method
    method autobuffershrink%()
        local newsize% = buffer.length
        local newsparsetarget% = buffersizesparsetarget
        while buffersizeallowdec and length <= newsparsetarget and newsize > buffersizemin
            newsize :* buffersizedec
            newsparsetarget = newsize * buffersizesparse
        wend
        if newsize < buffer.length
            rebuffer( newsize )
            return true
        else
            return false
        endif
    end method
    method autobuffergrow%()
        local newsize% = buffer.length
        while buffersizeallowinc and length >= newsize and newsize < buffersizemax
            newsize :* buffersizeinc
        wend
        if newsize > buffer.length
            rebuffer( newsize )
            return true
        else
            return false
        endif
    end method
    method autobuffer()
        if not autobuffershrink() autobuffergrow()
    end method
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
    method bufferalloc( index%, count% )
        movebuffer( index, index+count, length-index )
    end method
    method bufferdealloc( index%, count% )
        movebuffer( index+count, index, length-index-1 )
    end method
    method copybuffer( target:AList )
        assert target
        target.buffersizemin = buffersizemin
        target.buffersizemax = buffersizemax
        target.buffersizedec = buffersizedec
        target.buffersizeinc = buffersizeinc
        target.buffersizeallowinc = buffersizeallowinc
        target.buffersizeallowdec = buffersizeallowdec
        target.buffersizesparse = buffersizesparse
        target.buffersizesparsetarget = buffersizesparsetarget
        target.length = length
        target.buffer = buffer[..]
    end method
    method setbuffer( buf:object[], count%=0 )
        if count<=0 count = buf.length
        length = count
        buffer = buf
    end method
    method setbufferparams( minsize%, maxsize%, decsize!, incsize!, decallow%, incallow%, sparse! )
        if not (minsize > 0 and maxsize > minsize and decsize < 1 and incsize > 1 and sparse < 1) throw new AListBufferException
        buffersizemin = minsize
        buffersizemax = maxsize
        buffersizedec = decsize
        buffersizeinc = incsize
        buffersizeallowinc = incallow
        buffersizeallowdec = decallow
        buffersizesparse = sparse
        buffersizesparsetarget = buffer.length * buffersizesparse
    end method
    method dynamic( setting% )
        buffersizeallowinc = setting
        buffersizeallowdec = setting
    end method
    
    method enum:Enumerator()
        return new AListEnumerator.init(self)
    end method
    
    method copy:List()
        local target:AList = new AList
        copybuffer( target )
        return target
    end method
    
    method size%()
        return length
    end method
    method empty%()
        return length = 0
    end method
    
    method clear()
        length = 0
        autobuffershrink()
        for local i% = 0 until buffer.length
            buffer[i] = null
        next
    end method
    method clearfast()
        length = 0
    end method
    
    method count%(value:object)
        local sum% = 0
        for local i%=0 until length
            sum :+ buffer[i] = value
        next
        return sum
    end method
    method contains%(value:object)
        for local i%=0 until length
            if buffer[i] = value return true
        next
        return false
    end method
    
    method get:object(index%)
        assert buffer and index>=0 and index<length
        return buffer[index]
    end method
    method set(index%, value:object)
        assert buffer and index>=0 and index<length
        buffer[index] = value
    end method
    method indexof%(value:object, start%=0)
        for local i%=start until length
            if buffer[i] = value return i
        next
        return -1
    end method
    
    method first:object()
        assert buffer and length
        return buffer[0]
    end method
    method last:object()
        assert buffer and length
        return buffer[length-1]
    end method
    
    method addfirst(value:object)
        insert(0, value)
    end method
    method addlast(value:object)
        insert(length, value)
    end method
    
    method insert(index%, value:object)
        assert buffer and index>=0 and index<=length
        length :+ 1
        autobuffergrow()
        if index<length bufferalloc(index, 1)
        buffer[index] = value
    end method
    method remove:object(index%, count%=1)
        assert buffer and index>=0 and index<length
        local value:object = buffer[index]
        bufferdealloc(index, 1)
        length :- 1
        autobuffershrink()
        return value
    end method
    
    method removefirst:object()
        return remove(0)
    end method
    method removelast:object()
        return remove(length-1)
    end method
    
    method addallfirst(values:object)
        insertall(0, values)
    end method
    method addalllast(values:object)
        insertall(length, values)
    end method
    
    method insertall(index%, values:object)
        assert buffer and index>=0 and index<=length
        local valuesenum:Enumerator = Enumerator.get(values)
        local count% = valuesenum.count()
        length :+ count
        autobuffergrow()
        if index<length bufferalloc(index, count)
        for local value:object = eachin valuesenum
            buffer[index] = value
            index :+ 1
        next
    end method
    
    method retainall%(values:object)
        local removevalues:object[] = new object[size()]
        local index% = 0
        local removed% = 0
        local valuesenum:Enumerator = Enumerator.get(values)
        for local value:object = eachin enum()
            local retain% = false
            for local retainvalue:object = eachin valuesenum
                if value = retainvalue
                    retain = true
                    valuesenum.reset()
                    exit
                endif
            next
            if not retain
                removevalues[index] = value
                index :+ 1
            endif
        next
        for local i%=0 until index
            removed :+ removevaluesall( removevalues[i] )
        next
        return removed
    end method
    
    method reverse()
        for local i% = 0 until length/2
            local j% = length-i-1
            local t:object = buffer[i]
            buffer[i] = buffer[j]
            buffer[j] = t
        next
    end method
    method shuffle( randomfloat!() )
        ' knuth shuffle
        local index% = length-1
        while index > 0
            local randindex% = randomfloat() * index
            index :- 1
            local t:object = buffer[index]
            buffer[index] = buffer[randindex]
            buffer[randindex] = t
        wend
    end method
    
    method toarray:object[]()
        local array:object[] = new object[length]
        for local i%=0 until length
            array[i] = buffer[i]
        next
        return array
    end method
end type

type AListEnumerator extends Enumerator
    field target:AList
    field index% = -1
    field currentindex%
    field length%
    
    method init:AListEnumerator(target:AList)
        self.target = target
        self.length = target.length
        return self
    end method
    
    method hasnext%()
        return index < length-1
    end method
    method nextobject:object()
        index :+ 1
        return target.buffer[index]
    end method
    method hasprev%()
        return index > 0
    end method
    method prevobject:object()
        index :- 1
        return target.buffer[index]
    end method
    
    method onstep%()
        return index
    end method
    method count%()
        return length
    end method
    method reset()
        index = -1
        length = target.length
    end method
    
    method remove:object()
        return removeindex(index)
    end method
    method removeindex:object(removeindex%)
        local value:object = target.remove(removeindex)
        if removeindex<=index index :- 1
        length :- 1
        return value
    end method
    method add(value:object)
        target.addlast(value)
    end method
end type

