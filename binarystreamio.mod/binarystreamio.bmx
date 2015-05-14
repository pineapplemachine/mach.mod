superstrict

module mach.binarystreamio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"
moduleinfo "14 May 2015: Moved BinaryStreamIO implementation into various smaller classes"

import mach.primitivestreamio
import mach.linestreamio
import mach.arraystreamio

''' Catch-all class for writing binary data to a stream.
''' It's a little less flexible and a little less speedy, but it should greatly contribute to ease-of-use of StreamIO classes.
type BinaryStreamIO extends PrimitiveStreamIO
    field lineio:LineStreamIO
    field arrayio:ArrayStreamIO

    method init:BinaryStreamIO(stream:BaseStream)
        target(stream)
        lineio = new LineStreamIO
        arrayio = new ArrayStreamIO
        return self
    end method
    method target(stream:BaseStream)
        targetstream = stream
        lineio.target(stream)
        arrayio.target(stream)
    end method
    
    ' ArrayStreamIO methods
        method readbytearray:byte[](count%)
            return arrayio.readbytearray(count)
        end method
        method readintobytearray(value:byte[], count%=-1)
            arrayio.readintobytearray(value, count)
        end method
        method writebytearray(value:byte[], count%=-1)
            arrayio.writebytearray(value, count)
        end method
        method readshortarray:short[](count%)
            return arrayio.readshortarray(count)
        end method
        method readintoshortarray(value:short[], count%=-1)
            arrayio.readintoshortarray(value, count)
        end method
        method writeshortarray(value:short[], count%=-1)
            arrayio.writeshortarray(value, count)
        end method
        method readintarray:int[](count%)
            return arrayio.readintarray(count)
        end method
        method readintointarray(value:int[], count%=-1)
            arrayio.readintointarray(value, count)
        end method
        method writeintarray(value:int[], count%=-1)
            arrayio.writeintarray(value, count)
        end method
        method readfloatarray:float[](count%)
            return arrayio.readfloatarray(count)
        end method
        method readintofloatarray(value:float[], count%=-1)
            arrayio.readintofloatarray(value, count)
        end method
        method writefloatarray(value:float[], count%=-1)
            arrayio.writefloatarray(value, count)
        end method
        method readlongarray:long[](count%)
            return arrayio.readlongarray(count)
        end method
        method readintolongarray(value:long[], count%=-1)
            arrayio.readintolongarray(value, count)
        end method
        method writelongarray(value:long[], count%=-1)
            arrayio.writelongarray(value, count)
        end method
        method readdoublearray:double[](count%)
            return arrayio.readdoublearray(count)
        end method
        method readintodoublearray(value:double[], count%=-1)
            arrayio.readintodoublearray(value, count)
        end method
        method writedoublearray(value:double[], count%=-1)
            arrayio.writedoublearray(value, count)
        end method
    
    ' LineStreamIO methods
        method readline:string()
            return lineio.readline()
        end method
        method writeline(value:string)
            lineio.writeline(value)
        end method
        method writenewline()
            lineio.writenewline()
        end method
        method getlinelength%()
            return lineio.getlinelength()
        end method
        
    ' StringStreamIO methods
        method readbytestring:string(count%)
            return lineio.readbytestring(count)
        end method
        method readshortstring:string(count%)
            return lineio.readshortstring(count)
        end method
        method writebytestring(value:string, nullterminate%=false)
            lineio.writebytestring(value, nullterminate)
        end method
        method writeshortstring(value:string, nullterminate%=false)
            lineio.writeshortstring(value, nullterminate)
        end method
        method writebytestringpart(value:string, start%, count%, nullterminate%=false) ' if nullterminate is true, also write the trailing null byte
            lineio.writebytestringpart(value, start, count, nullterminate)
        end method
        method writeshortstringpart(value:string, start%, count%, nullterminate%=false) ' if nullterminate is true, also write the trailing null short
            lineio.writeshortstringpart(value, start, count, nullterminate)
        end method
        method readcstring:string() 
            return lineio.readcstring()
        end method
        method writecstring(value:string)
            lineio.writecstring(value)
        end method
        method readwstring:string() 
            return lineio.readwstring()
        end method
        method writewstring(value:string)
            lineio.writewstring(value)
        end method
        method readpstring:string()
            return lineio.readpstring()
        end method
        method writepstring(value:string)
            lineio.writepstring(value)
        end method
        method readbbstring:string()
            return lineio.readbbstring()
        end method
        method writebbstring(value:string)
            lineio.writebbstring(value)
        end method
        method readutf8string:string()
            return lineio.readutf8string()
        end method
        method writeutf8string(value:string)
            lineio.writeutf8string(value)
        end method
        method getcstringlength%()
            return lineio.getcstringlength()
        end method
        method getwstringlength%()
            return lineio.getwstringlength()
        end method
    
end type
