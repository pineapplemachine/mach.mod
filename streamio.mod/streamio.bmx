superstrict

module mach.streamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"
moduleinfo "14 May 2015: Added seekable method, moved BasicStreamIO class to separate module"

import mach.basestream

type StreamIO abstract
    method seek(value%)
        throw new SeekStreamException
    end method
    method seekable%()
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
