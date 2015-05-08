superstrict
import mach.exception

type EnumeratorException extends Exception
end type
type EnumeratorNotFoundException extends EnumeratorException
end type
type EnumeratorNotImplementedException extends EnumeratorException
end type

type Enumerator abstract
    global registeredcount% = 0
    global registered:Enumerator(target:object)[64]
    function get:Enumerator(target:object)
        for local i%=0 until registeredcount
            local func:Enumerator(target:object) = registered[i]
            local enum:Enumerator = func(target)
            if enum return enum
        next
        throw new EnumeratorNotFoundException
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
    method reset()
        throw new EnumeratorNotImplementedException
    end method
    
    method remove:object()
        throw new EnumeratorNotImplementedException
    end method
    
    method ObjectEnumerator:Enumerator()
        return self
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
    method reset()
        index = -1
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



