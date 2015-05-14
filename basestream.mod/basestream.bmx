superstrict

module mach.basestream
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.exception

' Various exceptions
type StreamException extends Exception
end type
type ReadStreamException extends Exception
end type
type WriteStreamException extends Exception
end type
type SeekStreamException extends Exception
end type
type FlushStreamException extends Exception
end type
type CloseStreamException extends Exception
end type
type OpenStreamException extends Exception
end type

' base class contains basic operations for reading to/writing from a stream
' to add reading/writing for another type of stream, extend this class
type BaseStream abstract
    ' move to position in stream
    method seek%(value%)
        return false
    end method
    method seekable%()
        return false
    end method
    ' flush stream output
    method flush%()
        return false
    end method
    ' close the stream
    method close%()
        return false
    end method
    ' true if the stream is active (not closed), false otherwise
    method active%()
        return false
    end method
    ' returns the current position in the stream
    method pos%()
        return 0
    end method
    ' returns the current size of the stream
    method size%()
        return 0
    end method
    
    ' returns true if no more bytes in stream
    method eof%()
        return pos() = size()
    end method
    
    ' read some number of bytes to a buffer
    method readbuffer%(buffer:byte ptr, count%)
        return false
    end method
    ' write some number of bytes from a buffer
    method writebuffer%(buffer:byte ptr, count%)
        return false
    end method
    ' skip some number of bytes in the stream
    method skip%(count%)
        return false
    end method
    
    ' close the stream upon this object being deleted
    method delete()
        close()
    end method
end type


