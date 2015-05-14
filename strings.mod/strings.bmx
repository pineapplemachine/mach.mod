superstrict

module mach.strings
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "11 May 2015: Added to mach.mod"
moduleinfo "14 May 2015: Added functions concat, interleave, and format"

import mach.enumeration

import "strings.c"
private
extern "c"
    function machStringFormat$(str$, bits$[], tokenchar@@)
    function machStringJoinSub$(delim$, bits$[], low%, up%)
    function machStringConcat$(bits$[], low%, up%)
    function machStringInterleave$(bits$[][], start%, inc%)
end extern
public

type strings
    function objtostring$(bit:object)
        if not bit
            return ""
        elseif string(bit)
            return string(bit)
        else
            return bit.tostring()
        endif
    end function
    function objtostringarray$[](bits:object)
        local strarray$[]
        if not bits
            return new string[0]
        elseif string(bits)
            strarray = [string(bits)]
        elseif string[](bits)
            strarray = string[](bits)
        elseif object[](bits)
            local obits:object[] = object[](bits)
            strarray = new string[obits.length]
            for local i%=0 until obits.length
                strarray[i] = objtostring(obits[i])
            next
        else
            local enum:Enumerator = Enumerator.get(bits)
            if enum
                strarray = new string[enum.count()]
                local i%=0
                for local value:object = eachin enum
                    strarray[i] = objtostring(value)
                    i :+ 1
                next
            else
                strarray = [objtostring(bits)]
            endif
        endif
        return strarray
    end function
    function objtostringarrayarray$[][](bits:object)
        local strarrayarray$[][]
        if not bits
            return new string[][0]
        elseif string[][](bits)
            strarrayarray = string[][](bits)
        elseif object[][](bits)
            local obits:object[][] = object[][](bits)
            strarrayarray = new string[][obits.length]
            for local i%=0 until obits.length
                strarrayarray[i] = objtostringarray(obits[i])
            next
        else
            local enum:Enumerator = Enumerator.get(bits)
            strarrayarray = new string[][enum.count()]
            local i%=0
            for local value:object = eachin enum
                strarrayarray[i] = objtostringarray(value)
                i :+ 1
            next
        endif
        return strarrayarray
    end function
    
    function join$(delim:object, bits:object)
        local strbits$[] = objtostringarray(bits)
        return machStringJoinSub(objtostring(delim), strbits, 0, strbits.length)
    end function
    function joinsub$(delim:object, bits:object, low%, up%)
        return machStringJoinSub(objtostring(delim), objtostringarray(bits), low, up)
    end function
    
    function concat$(bits:object)
        local strbits$[] = objtostringarray(bits)
        return machStringConcat(strbits, 0, strbits.length)
    end function
    function concatsub$(bits:object, low%, up%)
        return machStringConcat(objtostringarray(bits), low, up)
    end function
    
    function interleave$(bits:object, start%=0, inc%=1)
        local strbits$[][] = objtostringarrayarray(bits)
        return machStringInterleave(strbits, start, inc)
    end function
    
    ''' Formats a string using a funny syntax because blitz is weird.
    ''' When the format string contains %s it's replaced with the corresponsing member of subs.
    ''' The first %s is replaced with the first sub, the second %s with the second, and on.
    ''' When the format string contains %X where X is some digit it's replaced with the sub at
    ''' index X. When the format string contains %[X] where X is some decimal number of any
    ''' length it's replaced with the sub at index X. %% becomes %.
    ''' Note that %d, %f, and other tokens that would normally have meaning someplace like this
    ''' are not recognized.
    ''' When a string would be formatted using a sub at an index that's out-of-bounds, the
    ''' function will silently fail and the token will not be replaced.
    const FORMAT_TOKEN% = asc("%")
    function format$(str:object, sub:object, formattoken%=FORMAT_TOKEN)
        return machStringFormat(objtostring(str), objtostringarray(sub), formattoken)
    end function
end type
