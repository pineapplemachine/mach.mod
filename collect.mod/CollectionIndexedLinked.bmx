superstrict
import "CollectionIndexed.bmx"



type CollectionIndexedLinked extends CollectionIndexed

    ' get the first/last node in the collection (distinct from getting the first/last value)
    method firstnode:CollectionIndexedLinkedNode()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method lastnode:CollectionIndexedLinkedNode()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' get the previous or next node given a node belonging to the collection
    method prevnode:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method nextnode:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' check whether the collection has another node following/preceding this one
    method hasprevnode%( node:CollectionIndexedLinkedNode )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method hasnextnode%( node:CollectionIndexedLinkedNode )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' append node to beginning/end (and return the inserted node)
    method addfirst:CollectionIndexedLinkedNode( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method addlast:CollectionIndexedLinkedNode( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' remove first/last node (and return the value associated with it)
    method removefirst:object()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method removelast:object()
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' remove a particular node belonging to the collection (and return its value)
    method removenode:object( node:CollectionIndexedLinkedNode )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' remove all instances of some value from the list
    method removevalues:CollectionIndexedLinked( value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' insert a value before/after a node belonging to the collection (and return the created node)
    method insertbefore:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode, value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    method insertafter:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode, value:object )
        throw EXCEPTION_UNIMPLEMENTED; return null
    end method
    
    ' append node to beginning/end (and return the collection object itself)
    method append:CollectionIndexedLinked( value:object )
        addlast( value )
        return self
    end method
    method prepend:CollectionIndexedLinked( value:object )
        addfirst( value )
        return self
    end method
    
    ' get node/value at index
    method nodeatindex:CollectionIndexedLinkedNode( index% )
        assert index >= 0 and index < length
        for local node:CollectionIndexedLinkedNode = eachin enumnodes()
            if index = 0 return node
            index :- 1
        next
        throw EXCEPTION_WEIRD_OOB
    end method
    method valueatindex:object( index% )
        assert index >= 0 and index < length
        return nodeatindex( index ).value
    end method
    
    ' enumerate nodes (as opposed to values)
    method enumnodes:Enumerator()
        return new EnumeratorIndexedLinkedNodes.init( self )
    end method
    
    ' overrides for superclasses
    method enum:Enumerator()
        return new EnumeratorIndexedLinkedValues.init( self )
    end method
    method first:object()
        return firstnode().value
    end method
    method last:object()
        return lastnode().value
    end method
    method push:Collection( value:object )
        addlast( value )
        return self
    end method
    method pop:object()
        return removelast()
    end method
    method set:Collection( index%, value:object )
        nodeatindex( index ).value = value
        return self
    end method
    method get:object( index% )
        return valueatindex( index )
    end method
    
end type



' Base type for linked list nodes
type CollectionIndexedLinkedNode abstract
    
    field value:object
    
end type



' Enumeration class for nodes
type EnumeratorIndexedLinkedNodes extends Enumerator

    field target:CollectionIndexedLinked
    field node:CollectionIndexedLinkedNode
    field morenodes%
    
    method init:EnumeratorIndexedLinkedNodes( targ:CollectionIndexedLinked )
        target = targ
        if target.length
            node = target.firstnode()
            morenodes = true
        endif
        return self
    end method
    
    method hasnext%()
        ' not as simple as calling hasnextnode because the enumerator expects one more go-around after that
        local has% = morenodes
        morenodes = node and target.hasnextnode( node )
        return has
    end method
    method nextobject:object()
        local currentnode:CollectionIndexedLinkedNode = node
        node = target.nextnode( node )
        return currentnode
    end method
    
end type
' Enumeration class for values
type EnumeratorIndexedLinkedValues extends EnumeratorIndexedLinkedNodes
    
    method nextobject:object()
        return CollectionIndexedLinkedNode( super.nextobject() ).value
    end method
    
end type

