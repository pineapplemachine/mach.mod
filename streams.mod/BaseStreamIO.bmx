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
        if targetstream.seek(value) throw new SeekStreamException
    end method
    method flush()
        assert targetstream
        if targetstream.flush() throw new FlushStreamException
    end method
    method close(flushstream%=true)
        assert targetstream
        if targetstream.flush() throw new FlushStreamException
        if targetstream.close() throw new CloseStreamException
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
        targetstream.readbuffer(buffer, count)
    end method
    method writebuffer(buffer:byte ptr, count%)
        assert targetstream
        targetstream.writebuffer(buffer, count)
    end method
end type


