superstrict

module mach.streamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.basestream

type StreamIO abstract
    method seek(value%)
        throw new SeekStreamException
    end method
    method flush()
        throw new FlushStreamException
    end method
    method close(flushstream%=true)
        throw new CloseStreamException
    end method
    method active%()
        return false
    end method
    method pos%()
        throw new StreamException
    end method
    method size%()
        throw new StreamException
    end method
    method eof%()
        throw new StreamException
    end method
    method readbuffer(buffer:byte ptr, count%)
        throw new ReadStreamException
    end method
    method writebuffer(buffer:byte ptr, count%)
        throw new WriteStreamException
    end method
end type

' Includes default implementations for methods of a StreamIO that simply targets a single stream
type BasicStreamIO extends StreamIO abstract
    ' target stream object: read to/write from this stream
    field targetstream:BaseStream
    ' set target stream object
    method target(s:BaseStream)
        targetstream = s
    end method
    
    ' refer directly to target stream's methods
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
