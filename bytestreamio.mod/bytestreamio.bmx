superstrict

module mach.bytestreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "14 May 2015: Added to mach.mod"

import mach.basicstreamio

type ByteStreamIO extends BasicStreamIO
    method readbyte:byte()
        assert targetstream
        local value:byte
        if targetstream.readbuffer(varptr value, 1)
            return value
        else
            throw new ReadStreamException
        endif
    end method
    method writebyte(value:byte)
        assert targetstream
        if not targetstream.writebuffer(varptr value, 1) throw new WriteStreamException
    end method
    method readbytes(bytes:byte ptr, count%)
        assert targetstream
        if not targetstream.readbuffer(bytes, count) throw new ReadStreamException
    end method
    method writebytes(bytes:byte ptr, count%)
        assert targetstream
        if not targetstream.writebuffer(bytes, count) throw new WriteStreamException
    end method
end type
