superstrict

module mach.stdstreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.stdstream
import mach.stringstreamio
import mach.linestreamio

type StdStreamIO extends StreamIO
    field instream:LineStreamIO
    field outstream:StringStreamIO
    field errstream:StringStreamIO
    
    field newline$ = "~r~n"
    field nullstr$ = ""
    
    method init:StdStreamIO(instream:LineStreamIO=null, outstream:StringStreamIO=null, errstream:StringStreamIO=null)
        self.instream = instream
        self.outstream = outstream
        self.errstream = errstream
        if not self.instream self.instream = new LineStreamIO; self.instream.target( StdStream.in )
        if not self.outstream self.outstream = new StringStreamIO; self.outstream.target( StdStream.out )
        if not self.errstream self.errstream = new StringStreamIO; self.errstream.target( StdStream.err )
        return self
    end method
    
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
    
    method write(value:object="", target:StringStreamIO, newline%=true)
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
