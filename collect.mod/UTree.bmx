superstrict
import "CollectionIndexed.bmx"
import "CollectionSorter.bmx"
import "AList.bmx"

rem
    Unstructured tree
    Each leaf has a value and any number of subtrees. Each subtree is also a UTree object. Subtrees are enumerated using an AList.
    Computational complexity for operations are identical to those of the list implementation used.
endrem
type UTree extends CollectionIndexed
    field value:object
    field subtrees:AList
    method init:UTree( val:object=null, listlength%=0 )
        value = val
        subtrees = new AList.init( listlength )
        return self
    end method
    
    method set:Collection( index%, value:object )
        return setsub( index, new UTree.init( value ) )
    end method
    method setsub:UTree( index%, tree:UTree )
        subtrees.set( index, tree )
        return self
    end method
    method get:object( index% )
        return getsub( index ).value
    end method
    method getsub:UTree( index% )
        return UTree( subtrees.get( index ) )
    end method
    
    method enum:Enumerator()
        return subtrees.enum()
    end method
    method clear:Collection()
        value = null
        for local sub:UTree = eachin subtrees
            sub.clear()
        next
        subtrees.clear()
        return self
    end method
    method clearfast:Collection()
        value = null
        subtrees.clearfast()
        return self
    end method
    
    method push:Collection( value:object )
        return pushsub( new UTree.init( value ) )
    end method
    method pushsub:UTree( tree:UTree )
        subtrees.push( tree )
        return self
    end method
    method pop:object()
        return popsub().value
    end method
    method popsub:UTree()
        return UTree( subtrees.pop() )
    end method
    
    method insert:Collection( index%, value:object )
        return insertsub( index, new UTree.init( value ) )
    end method
    method insertsub:UTree( index%, tree:UTree )
        subtrees.insert( index, tree )
        return self
    end method
    method remove:object( index% )
        return removesub( index ).value
    end method
    method removesub:UTree( index% )
        return UTree( subtrees.remove( index ) )
    end method
    
    method copy:Collection()
        local other:UTree = new UTree
        other.value = value
        other.subtrees = AList( subtrees.copy() )
        return other
    end method
 
    method reverse:Collection()
        subtrees.reverse()
        return self
    end method
    
    method shuffle:Collection( randomfloat!() )
        subtrees.shuffle( randomfloat )
        return self
    end method
    
    method sort:Collection( sorter:CollectionSorter )
        subtrees.sort( sorter )
        return self
    end method
end type
