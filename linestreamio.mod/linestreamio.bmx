superstrict

module mach.linestreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "14 May 2015: Added to mach.mod"

import mach.stringstreamio
import mach.enumeration

type LineStreamIO extends StringStreamIO
    field DEFAULT_READLINE_BUFFER_SIZE% = 1024
    
    method init:LineStreamIO(stream:BaseStream)
        target(stream)
        return self
    end method
    
    method readlines:Enumerator()
        return new LineStreamIOEnumerator.init(self)
    end method
    
    ' read newline-terminated c string (stops at null or \n, whichever comes first. ignores \r.)
    method readline:string()
        if targetstream.seekable()
            return readlineunbuffered()
        else
            return readlinebuffered()
        endif
    end method
    
    method readlineunbuffered:string()
        local buffersize% = getlinelength()
        local buffer:byte[] = new byte[buffersize]
        local count% = 0
        local currentbyte:byte
        local currentbyteptr:byte ptr = varptr currentbyte
        repeat
            local reading% = targetstream.readbuffer(currentbyteptr, 1)
            if (not reading) or (currentbyte = 0) or (currentbyte = 10)
                exit
            elseif currentbyte <> 13
                buffer[count] = currentbyte
                count :+ 1
            endif
        forever
        return string.frombytes( buffer, count )
    end method
    method readlinebuffered:string(buffersize% = 0)
        if buffersize <= 0 buffersize = DEFAULT_READLINE_BUFFER_SIZE
        local buffer:byte[] = new byte[buffersize]
        local count% = 0
        local currentbyte:byte
        local currentbyteptr:byte ptr = varptr currentbyte
        repeat
            local reading% = targetstream.readbuffer(currentbyteptr, 1)
            if (not reading) or (currentbyte = 0) or (currentbyte = 10)
                exit
            elseif currentbyte <> 13
                if count >= buffer.length
                    buffer = buffer[..buffer.length shl 1]
                endif
                buffer[count] = currentbyte
                count :+ 1
            endif
        forever
        return string.frombytes( buffer, count )
    end method
    
    method writeline(value:string)
        writebytestring(value, false)
        writenewline()
    end method
    field newlineterminator:byte[] = [13:byte, 10:byte]
    method writenewline()
        targetstream.writebuffer(newlineterminator, newlineterminator.length)
    end method
        
    method getlinelength%()
        local count% = 0
        local start% = pos()
        local currentbyte:byte
        local currentbyteptr:byte ptr = varptr currentbyte
        repeat
            local reading% = targetstream.readbuffer(currentbyteptr, 1)
            if (not reading) or (currentbyte = 0) or (currentbyte = 10)
                exit
            elseif currentbyte <> 13
                count :+ 1
            endif
        forever
        targetstream.seek(start)
        return count
    end method
end type

type LineStreamIOEnumerator extends Enumerator
    global registration% = Enumerator.register(LineStreamIOEnumerator.getenumerator)
    function getenumerator:Enumerator(target:object)
        if LineStreamIO(target) return new LineStreamIOEnumerator.init(LineStreamIO(target))
    end function
    
    field target:LineStreamIO
    field startpos%
    
    method init:LineStreamIOEnumerator(stream:LineStreamIO)
        assert target
        target = stream
        startpos = stream.pos()
        return self
    end method
    method hasnext%()
        return target and (not target.eof())
    end method
    method nextobject:object()
        assert target
        return target.readline()
    end method
    method resethead()
        assert target
        target.seek(startpos)
    end method
end type
