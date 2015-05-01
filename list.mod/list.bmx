superstrict
import "../collection.mod/collection.bmx"

type List extends Collection abstract
    method copy:List()
        throw new CollectionNotImplementedException
    end method
    
    method union:List(other:List)
        local l:List = copy()
        l.addall(other)
        return l
    end method
    method intersection:List(other:List)
        local l:List = copy()
        l.retainall(other)
        return l
    end method
    method difference:List(other:List)
        local a:List = copy()
        local b:List = other.copy()
        a.removevaluesall(b)
        b.removevaluesall(a)
        a.addall(b)
        return a
    end method

    method get:object(index%)
        throw new CollectionNotImplementedException
    end method
    method set(index%, value:object)
        throw new CollectionNotImplementedException
    end method
    method indexof%(value:object, start%=0)
        for local i%=start until size()
            if get(i) = value return i
        next
        return -1
    end method
    
    method first:object()
        return get(0)
    end method
    method last:object()
        return get(size() - 1)
    end method
    
    method add(value:object)
        addlast(value)
    end method
    method addall(values:object)
        addalllast(values)
    end method
    
    method addfirst(value:object)
        insert(0, value)
    end method
    method addlast(value:object)
        insert(size(), value)
    end method
    
    method insert(index%, value:object)
        throw new CollectionNotImplementedException
    end method
    method remove:object(index%, count%=1)
        throw new CollectionNotImplementedException
    end method
    
    method removefirst:object()
        return remove(0)
    end method
    method removelast:object()
        return remove(size() - 1)
    end method
    
    method addallfirst(values:object)
        insertall(0, values)
    end method
    method addalllast(values:object)
        insertall(size(), values)
    end method
    
    method insertall(index%, values:object)
        for local value:object = eachin Enumerator.get(values)
            insert(index, value)
            index :+ 1
        next
    end method
    
    method retainall%(values:object)
        local removevalues:object[] = new object[size()]
        local index% = 0
        local removed% = 0
        local valuesenum:Enumerator = Enumerator.get(values)
        for local value:object = eachin enum()
            local retain% = false
            for local retainvalue:object = eachin valuesenum
                if value = retainvalue
                    retain = true
                    valuesenum.reset()
                    exit
                endif
            next
            if not retain
                removevalues[index] = value
                index :+ 1
            endif
        next
        return removevaluesall( removevalues )
    end method
    
    method reverse()
        for local i%=0 until size()/2
            local value:object = get(i)
            set(i, get(size() - i - 1))
            set(size() - i - 1, value)
        next
    end method
    method shuffle( randomfloat!() )
        local index% = size() - 1
        while index > 0
            local randindex% = randomfloat() * index
            index :- 1
            local t:object = get(index)
            set(index, get(randindex))
            set(randindex, t)
        wend
    end method
    
    method toarray:object[]()
        local array:object[] = new object[size()]
        local index% = 0
        for local value:object = eachin enum()
            array[index] = value
            index :+ 1
        next
        return array
    end method
end type

