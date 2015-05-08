superstrict

module mach.stdstreamio
moduleinfo "License: Apache 2.0"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.stdstream
import mach.binarystreamio

type StdStreamIO extends StreamIO
    field instream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.in )
    field outstream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.out )
    field errstream:BinaryStreamIO = new BinaryStreamIO.init( StdStream.err )
    
    field newline$ = "~r~n"
    field nullstr$ = "null"
    
    method in$(prompt:object)
        if prompt
            if not string(prompt) prompt = prompt.tostring()
            outstream.writebytestring(string(prompt))
            outstream.flush()
        endif
        return instream.readline()
    end method
    method out(value:object="")
        writeline(value, outstream)
    end method
    method err(value:object="")
        writeline(value, errstream)
    end method
    
    method writeline(value:object="", target:BinaryStreamIO)
        if value=null
            target.writeline(nullstr)
        elseif string(value)
            target.writeline(string(value))
        else
            target.writeline(value.tostring())
        endif
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
