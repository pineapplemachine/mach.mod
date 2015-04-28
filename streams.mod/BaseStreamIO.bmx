superstrict
import "BaseStream.bmx"

type BaseStreamIO abstract
    ' target BaseStream object: read to/write from this stream
    field targetstream:BaseStream
    
    ' set target stream object
    method target(stream:BaseStream)
        targetstream = stream
    end method
    
    ' refer directly to target BaseStream methods
    method seek(value%)
        assert targetstream
        ?debug
            assert targetstream.seek(value) else new SeekStreamException
        ?not debug
            targetstream.seek(value)
        ?
    end method
    method flush()
        assert targetstream
        ?debug
            assert targetstream.flush() else new FlushStreamException
        ?not debug
            targetstream.flush()
        ?
    end method
    method close(flushstream%=true)
        assert targetstream
        ?debug
            if flushstream assert targetstream.flush() else new FlushStreamException
            assert targetstream.close() else new CloseStreamException
        ?not debug
            if flushstream targetstream.flush()
            targetstream.close()
        ?
    end method
    method active%()
        if targetstream
            return targetstream.active()
        else
            return false
        endif
    end method
    method pos%()
        assert targetstream
        return targetstream.pos()
    end method
    method size%()
        assert targetstream
        return targetstream.size()
    end method
    method eof%()
        assert targetstream
        return targetstream.eof()
    end method
    method readbuffer(buffer:byte ptr, count%)
        assert targetstream
        ?debug
            assert targetstream.readbuffer(buffer, count) else new ReadStreamException
        ?not debug
            targetstream.readbuffer(buffer, count)
        ?
    end method
    method writebuffer(buffer:byte ptr, count%)
        assert targetstream
        ?debug
            assert targetstream.writebuffer(buffer, count) else new WriteStreamException
        ?not debug
            targetstream.writebuffer(buffer, count)
        ?
    end method
end type


