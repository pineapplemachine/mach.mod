superstrict

module mach.binarystreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.streamio

' read/write binary data
type BinaryStreamIO extends BasicStreamIO
    method init:BinaryStreamIO(stream:BaseStream)
        target(stream)
        return self
    end method

    ' read/write bytes
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
    
    ' read/write other numeric primitives
        method readshort:short()
            local value:short
            readbytes(byte ptr(varptr value), 2)
            return value
        end method
        method writeshort(value:short)
            writebytes(byte ptr(varptr value), 2)
        end method
        
        method readint:int()
            local value:int
            readbytes(byte ptr(varptr value), 4)
            return value
        end method
        method writeint(value:int)
            writebytes(byte ptr(varptr value), 4)
        end method
        
        method readfloat:float()
            local value:float
            readbytes(byte ptr(varptr value), 4)
            return value
        end method
        method writefloat(value:float)
            writebytes(byte ptr(varptr value), 4)
        end method
        
        method readlong:long()
            local value:long
            readbytes(byte ptr(varptr value), 4)
            return value
        end method
        method writelong(value:long)
            writebytes(byte ptr(varptr value), 4)
        end method
        
        method readdouble:double()
            local value:double
            readbytes(byte ptr(varptr value), 4)
            return value
        end method
        method writedouble(value:double)
            writebytes(byte ptr(varptr value), 4)
        end method
    
    ' read/write arrays of numeric primitives
        method readbytearray:byte[](count%)
            local value:byte[] = new byte[count]
            readintobytearray(value)
            return value
        end method
        method readintobytearray(value:byte[])
            readbytes(byte ptr value, value.length)
        end method
        method writebytearray(value:byte[])
            writebytes(byte ptr value, value.length)
        end method
        
        method readshortarray:short[](count%)
            local value:short[] = new short[count]
            readintoshortarray(value)
            return value
        end method
        method readintoshortarray(value:short[])
            readbytes(byte ptr value, value.length shl 1)
        end method
        method writeshortarray(value:short[])
            writebytes(byte ptr value, value.length shl 1)
        end method
        
        method readintarray:int[](count%)
            local value:int[] = new int[count]
            readintointarray(value)
            return value
        end method
        method readintointarray(value:int[])
            readbytes(byte ptr value, value.length shl 2)
        end method
        method writeintarray(value:int[])
            writebytes(byte ptr value, value.length shl 2)
        end method
        
        method readfloatarray:float[](count%)
            local value:float[] = new float[count]
            readintofloatarray(value)
            return value
        end method
        method readintofloatarray(value:float[])
            readbytes(byte ptr value, value.length shl 2)
        end method
        method writefloatarray(value:float[])
            writebytes(byte ptr value, value.length shl 2)
        end method
        
        method readlongarray:long[](count%)
            local value:long[] = new long[count]
            readintolongarray(value)
            return value
        end method
        method readintolongarray(value:long[])
            readbytes(byte ptr value, value.length shl 3)
        end method
        method writelongarray(value:long[])
            writebytes(byte ptr value, value.length shl 3)
        end method
        
        method readdoublearray:double[](count%)
            local value:double[] = new double[count]
            readintodoublearray(value)
            return value
        end method
        method readintodoublearray(value:double[])
            readbytes(byte ptr value, value.length shl 3)
        end method
        method writedoublearray(value:double[])
            writebytes(byte ptr value, value.length shl 3)
        end method
    
    ' read/write strings
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
        method getlinelength%()
            local count% = 0
            local registercount% = 0
            local start% = pos()
            local currentbyte:byte
            local currentbyteptr:byte ptr = varptr currentbyte
            repeat
                local reading% = targetstream.readbuffer(currentbyteptr, 1)
                if (not reading) or (currentbyte = 0) or (currentbyte = 10)
                    exit
                elseif currentbyte = 13
                    registercount :+ 1
                else
                    count :+ 1
                endif
            forever
            targetstream.seek(start)
            return count - registercount
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
        
        ' newline-terminated c string (stops at null or \n, whichever comes first. ignores \r.)
        field DEFAULT_READLINE_BUFFER_SIZE% = 1024
        method readline:string(buffersize% = 0)
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
end type
