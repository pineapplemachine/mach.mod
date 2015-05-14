superstrict

module mach.stdstreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.stdstream
import mach.binarystreamio

type StdStreamIO extends StreamIO
    field instream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.in )
    field outstream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.out )
    field errstream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.err )
    
    field newline$ = "~r~n"
    field nullstr$ = ""
    
    method in$(prompt:object)
        if prompt write(prompt, outstream, false)
        return instream.readline()
    end method
    method out(value:object="", newline%=true)
        write(value, outstream, newline)
    end method
    method err(value:object="", newline%=true)
        write(value, errstream, newline)
    end method
    
    method write(value:object="", target:BinaryStreamIO, newline%=true)
        if string(value)
            target.writebytestring(string(value))
        elseif value
            target.writebytestring(value.tostring())
        elseif nullstr
            target.writebytestring(nullstr)
        endif
        if newline target.writebytestring(newline)
        target.flush()
    end method
    
    method active%()
        return instream.active() or outstream.active() or errstream.active()
    end method
    method eof%()
        assert instream
        return instream.eof()
    end method
    method readbuffer(buffer:byte ptr, count%)
        assert instream
        instream.readbuffer(buffer, count)
    end method
    method writebuffer(buffer:byte ptr, count%)
        assert outstream
        outstream.writebuffer(buffer, count)
    end method
end type
