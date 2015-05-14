superstrict

module mach.arraystreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "14 May 2015: Added to mach.mod"

import mach.bytestreamio

type ArrayStreamIO extends ByteStreamIO
    method readbytearray:byte[](count%)
        local value:byte[] = new byte[count]
        readintobytearray(value)
        return value
    end method
    method readintobytearray(value:byte[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count)
    end method
    method writebytearray(value:byte[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count)
    end method
    
    method readshortarray:short[](count%)
        local value:short[] = new short[count]
        readintoshortarray(value)
        return value
    end method
    method readintoshortarray(value:short[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count shl 1)
    end method
    method writeshortarray(value:short[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count shl 1)
    end method
    
    method readintarray:int[](count%)
        local value:int[] = new int[count]
        readintointarray(value)
        return value
    end method
    method readintointarray(value:int[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count shl 2)
    end method
    method writeintarray(value:int[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count shl 2)
    end method
    
    method readfloatarray:float[](count%)
        local value:float[] = new float[count]
        readintofloatarray(value)
        return value
    end method
    method readintofloatarray(value:float[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count shl 2)
    end method
    method writefloatarray(value:float[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count shl 2)
    end method
    
    method readlongarray:long[](count%)
        local value:long[] = new long[count]
        readintolongarray(value)
        return value
    end method
    method readintolongarray(value:long[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count shl 3)
    end method
    method writelongarray(value:long[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count shl 3)
    end method
    
    method readdoublearray:double[](count%)
        local value:double[] = new double[count]
        readintodoublearray(value)
        return value
    end method
    method readintodoublearray(value:double[], count%=-1)
        if count = -1 count = value.length
        readbytes(byte ptr value, count shl 3)
    end method
    method writedoublearray(value:double[], count%=-1)
        if count = -1 count = value.length
        writebytes(byte ptr value, count shl 3)
    end method
end type
