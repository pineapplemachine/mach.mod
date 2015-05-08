superstrict
import mach.exception
import "../enumeration.mod/enumeration.bmx"

type CollectionException extends Exception
end type
type CollectionNotImplementedException extends CollectionException
end type
type CollectionInvalidTypeException extends CollectionException
end type

type Collection abstract
    method size%()
        throw new CollectionNotImplementedException
    end method
    method empty%()
        return size() = 0
    end method
    
    method clear()
        throw new CollectionNotImplementedException
    end method
    method clearfast()
        clear()
    end method
    
    method count%(value:object)
        throw new CollectionNotImplementedException
    end method
    method contains%(value:object)
        return count(value) > 0
    end method
    method containsall%(values:object)
        for local value:object = eachin Enumerator.get(values)
            if not contains(value) return false
        next
        return true
    end method

    method removevalue(value:object)
        throw new CollectionNotImplementedException
    end method
    method removevalues%(value:object)
        local count% = 0
        while contains(value)
            removevalue(value)
            count :+ 1
        wend
        return count
    end method
    method removevalueall(values:object)
        for local value:object = eachin Enumerator.get(values)
            removevalue(value)
        next
    end method
    method removevaluesall%(values:object)
        local count% = 0
        for local value:object = eachin Enumerator.get(values)
            count :+ removevalues(value)
        next
        return count
    end method
    
    method enum:Enumerator()
        throw new EnumeratorException
    end method
    method ObjectEnumerator:Enumerator()
        return enum()
    end method
    global registration% = Enumerator.register(Collection.getenumerator)
    function getenumerator:Enumerator(target:object)
        if Collection(target) return Collection(target).enum()
    end function
end type
