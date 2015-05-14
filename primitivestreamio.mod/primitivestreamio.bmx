superstrict

module mach.primitivestreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "14 May 2015: Added to mach.mod"

import mach.bytestreamio

type PrimitiveStreamIO extends ByteStreamIO
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
        readbytes(byte ptr(varptr value), 8)
        return value
    end method
    method writelong(value:long)
        writebytes(byte ptr(varptr value), 8)
    end method
    
    method readdouble:double()
        local value:double
        readbytes(byte ptr(varptr value), 8)
        return value
    end method
    method writedouble(value:double)
        writebytes(byte ptr(varptr value), 8)
    end method
end type
