superstrict

module mach.stringstreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "14 May 2015: Added to mach.mod"

import mach.primitivestreamio

type StringStreamIO extends PrimitiveStreamIO
    ' strings of known length
    method readbytestring:string(count%)
        local chars:byte[] = new byte[count]
        targetstream.readbuffer(byte ptr chars, count)
        return string.frombytes(chars, count)
    end method
    method readshortstring:string(count%)
        local chars:short[] = new short[count]
        targetstream.readbuffer(byte ptr chars, count)
        return string.fromshorts(chars, count)
    end method
    method writebytestring(value:string, nullterminate%=false)
        writebytestringpart(value, 0, value.length, nullterminate)
    end method
    method writeshortstring(value:string, nullterminate%=false)
        writeshortstringpart(value, 0, value.length, nullterminate)
    end method
    method writebytestringpart(value:string, start%, count%, nullterminate%=false) ' if nullterminate is true, also write the trailing null byte
        local bytes:byte ptr = value.tocstring() + start
        targetstream.writebuffer(bytes, count + nullterminate)
        memfree bytes
    end method
    method writeshortstringpart(value:string, start%, count%, nullterminate%=false) ' if nullterminate is true, also write the trailing null short
        local shorts:short ptr = value.towstring() + start
        targetstream.writebuffer(byte ptr shorts, (count + nullterminate) shl 1)
        memfree shorts
    end method
    
    ' null-terminated cstring, one byte per character
    method readcstring:string() 
        local value:string = readbytestring(getcstringlength())
        targetstream.skip(1)
        return value
    end method
    method writecstring(value:string)
        writebytestring(value, true)
    end method
    
    ' null-terminated wstring, two bytes per character
    method readwstring:string() 
        local value:string = readshortstring(getwstringlength())
        targetstream.skip(2)
        return value
    end method
    method writewstring(value:string)
        writeshortstring(value, true)
    end method
    
    ' pascal string, one byte length prefix and one byte per character
    method readpstring:string()
        local length% = readbyte()
        readbytestring(length)
    end method
    method writepstring(value:string)
        local length% = value.length
        if length > 255 length = 255
        writebyte(length)
        writebytestringpart(value, 0, length, false)
    end method
    
    ' blitz basic string, four byte length prefix and one byte per character
    method readbbstring:string()
        local length% = readint()
        readbytestring(length)
    end method
    method writebbstring(value:string)
        local length% = value.length
        writeint(length)
        writebytestring(value, false)
    end method
    
    ' utf8 string, null-terminated and variable bytes per character
    method readutf8string:string()
        local bytes:byte[] = new byte[getcstringlength()]
        targetstream.readbuffer(bytes, bytes.length)
        return string.fromutf8string(bytes)
    end method
    method writeutf8string(value:string)
        local buffer:byte ptr=value.toutf8string()
        local success% = targetstream.writebuffer(buffer, value.length*3 + 1)
        memfree buffer
        if not success throw new WriteStreamException
    end method
    
    ' utility methods for finding the nearest null-termination character, return the number of bytes between the current position and the next null value
    method getcstringlength%()
        local count% = 0
        local start% = pos()
        local currentbyte:byte
        local currentbyteptr:byte ptr = varptr currentbyte
        repeat
            local reading% = targetstream.readbuffer(currentbyteptr, 1)
            if (not reading) or (not currentbyte) or targetstream.eof()
                exit
            else
                count :+ 1
            endif
        forever
        targetstream.seek(start)
        return count
    end method
    method getwstringlength%()
        local count% = 0
        local start% = pos()
        local currentshort:short
        local currentshortptr:byte ptr = byte ptr(varptr currentshort)
        repeat
            local reading% = targetstream.readbuffer(currentshortptr, 2)
            if (not reading) or (not currentshort) or targetstream.eof()
                exit
            else
                count :+ 1
            endif
        forever
        targetstream.seek(start)
        return count
    end method
end type
