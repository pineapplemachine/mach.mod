superstrict

module mach.exception
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import "exception.c"
private
extern "c"
    Function bbGetObjectClass%( obj:Object )
endextern
public

type Exception
    field name$
    method toString$()
        if not name name = getname()
        return name
    end method
    
    method getname$()
        ' via reflection, get the name of the instantiated class
        ' details nicked from the brl.reflection module packaged with 1.50
        ' I imagine this sort of thing might be liable to change depending on the version, so be careful
        local class% = bbGetObjectClass(self)
        local a% = (int ptr class)[2]
        local b% = (int ptr a)[1]
        local c@ ptr = byte ptr(b)
        return string.FromCString(c)
    end method
end type
