superstrict

module mach.strings
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "11 May 2015: Added to mach.mod"

import mach.enumeration

import "strings.c"
private
extern "c"
    function bbStringJoinSub$(delim$, bits$[], low%, up%)
    function bbStringJoin$(delim$, bits$[]) ' from blitz_string.c
end extern
public

type strings
    function stringarray$[](bits:object)
        local strarray$[]
        if string[](bits)
            strarray = string[](bits)
        elseif object[](bits)
            local strbits$[] = object[](bits)
            strarray = new string[strbits.length]
            for local i%=0 until strbits.length
                strarray[i] = strbits[i].tostring()
            next
        else
            local enum:Enumerator = Enumerator.get(bits)
            strarray = new string[enum.count()]
            local i%=0
            for local value:object = eachin enum
                strarray[i] = value.tostring()
                i :+ 1
            next
        endif
        return strarray
    end function
    
    function join$(delim$, bits:object)
        return bbStringJoin(delim, stringarray(bits))
    end function
    function joinsub$(delim$, bits:object, low%, up%)
        return bbStringJoinSub(delim, stringarray(bits), low, up)
    end function
end type
