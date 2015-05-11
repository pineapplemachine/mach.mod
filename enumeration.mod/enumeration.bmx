superstrict

module mach.enumeration
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "30 Apr 2015: Added to mach.mod"
moduleinfo "11 May 2015: Added resethead and resettail methods, AddValueEnumerator and AddKeyValueEnumerator classes."

import mach.exception

type EnumeratorException extends Exception
end type
type EnumeratorNotImplementedException extends EnumeratorException
end type

type Enumerator abstract
    global registeredcount% = 0
    global registered:Enumerator(target:object)[64]
    function get:Enumerator(target:object)
        for local i%=registeredcount-1 to 0 step -1
            local func:Enumerator(target:object) = registered[i]
            local enum:Enumerator = func(target)
            if enum return enum
        next
        return null
    end function
    function exists%(target:object)
        return Enumerator.get(target) <> null
    end function
    function register%(func:Enumerator(target:object))
        if registeredcount = registered.length
            registered = registered[..registered.length*2]
        endif
        registered[registeredcount] = func
        registeredcount :+ 1
        return registeredcount
    end function
    
    method hasnext%() abstract
    method nextobject:object() abstract
    method hasprev%()
        throw new EnumeratorNotImplementedException
    end method
    method prevobject:object()
        throw new EnumeratorNotImplementedException
    end method
    
    method onstep%()
        throw new EnumeratorNotImplementedException
    end method
    method count%()
        throw new EnumeratorNotImplementedException
    end method
    method reset(tail% = false)
        if tail
            resettail()
        else
            resethead()
        endif
    end method
    method resethead()
        throw new EnumeratorNotImplementedException
    end method
    method resettail()
        throw new EnumeratorNotImplementedException
    end method
    
    method remove:object()
        throw new EnumeratorNotImplementedException
    end method
    
    method ObjectEnumerator:Enumerator()
        return self
    end method
end type

type AddValueEnumerator extends Enumerator abstract
    method add(value:object)
        addlast(value)
    end method
    method addfirst(value:object)
        throw new EnumeratorNotImplementedException
    end method
    method addlast(value:object)
        throw new EnumeratorNotImplementedException
    end method
end type
type AddKeyValueEnumerator extends Enumerator abstract
    method add(key:object, value:object)
        throw new EnumeratorNotImplementedException
    end method
end type

type ArrayEnumerator extends Enumerator abstract
    field index% = -1
    field length%
    method hasnext%()
        return index < length-1
    end method
    method hasprev%()
        return index > 0
    end method
    method onstep%()
        return index
    end method
    method count%()
        return length
    end method
    method resethead()
        index = -1
    end method
    method resettail()
        index = length
    end method
end type

type ObjectArrayEnumerator extends ArrayEnumerator
    global registration% = Enumerator.register(ObjectArrayEnumerator.getenumerator)
    function getenumerator:Enumerator(target:object)
        if object[](target) return new ObjectArrayEnumerator.init(object[](target))
    end function
    
    field array:object[]
    method init:ObjectArrayEnumerator(target:object[])
        array = target
        length = array.length
        return self
    end method
    method nextobject:object()
        index :+ 1
        return array[index]
    end method
    method prevobject:object()
        index :- 1
        return array[index]
    end method
end type

type StringArrayEnumerator extends ArrayEnumerator
    global registration% = Enumerator.register(StringArrayEnumerator.getenumerator)
    function getenumerator:Enumerator(target:object)
        if string[](target) return new StringArrayEnumerator.init(string[](target))
    end function
    
    field array:string[]
    method init:StringArrayEnumerator(target:string[])
        array = target
        length = array.length
        return self
    end method
    method nextobject:object()
        index :+ 1
        return array[index]
    end method
    method prevobject:object()
        index :- 1
        return array[index]
    end method
end type

rem   Syntax for Enumerator of an object of unknown type

for local value:object = eachin Enumerator.get(something)
    dostuff()
next

endrem



