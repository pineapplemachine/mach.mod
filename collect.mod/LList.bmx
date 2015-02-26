superstrict
import "CollectionIndexedLinked.bmx"

' implements a simple cyclic doubly-linked list, like BlitzMax's native TList class
type LList extends CollectionIndexedLinked
    
    field head:LListNode
    
    ' initialize list
    method init:LList()
        head = new LListNode.init( null )
        return self
    end method
    
    method clear:Collection()
        assert head
        while head.succ <> head
            head.succ.remove()
        wend
        length = 0
        return self
    end method
    method clearfast:Collection()
        assert head
        head.succ = head
        head.pred = head
        length = 0
        return self
    end method
    method copy:Collection()
        assert head
        local newlist:LList = new LList.init()
        local node:LListNode = head.succ
        local copiednode:LListNode
        local lastcopiednode:LListNode = newlist.head
        while node <> head
            copiednode = new LListNode.init( node.value )
            lastcopiednode.succ = copiednode
            copiednode.pred = lastcopiednode
            lastcopiednode = copiednode
            node = node.succ
        wend
        lastcopiednode.succ = newlist.head
        return newlist
    end method
    method reverse:Collection()
        local node:LListNode = head
        repeat
            local temp:LListNode = node.succ
            node.succ = node.pred
            node.pred = temp
            node = temp
        until node = head
        return self
    end method

    method firstnode:CollectionIndexedLinkedNode()
        assert head and length
        return head.succ
    end method
    method lastnode:CollectionIndexedLinkedNode()
        assert head and length
        return head.pred
    end method

    method prevnode:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode )
        local Lnode:LListNode = LListNode( node )
        assert Lnode
        return Lnode.pred
    end method
    method nextnode:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode )
        local Lnode:LListNode = LListNode( node )
        assert Lnode
        return Lnode.succ
    end method
    
    method hasprevnode%( node:CollectionIndexedLinkedNode )
        local Lnode:LListNode = LListNode( node )
        assert head and Lnode
        return Lnode.pred <> head
    end method
    method hasnextnode%( node:CollectionIndexedLinkedNode )
        local Lnode:LListNode = LListNode( node )
        assert head and Lnode
        return Lnode.succ <> head
    end method

    method addfirst:CollectionIndexedLinkedNode( value:object )
        return insertafter( head, value )
    end method
    method addlast:CollectionIndexedLinkedNode( value:object )
        return insertbefore( head, value )
    end method

    method removefirst:object()
        assert head and length
        local value:object = head.succ.value
        head.succ.remove()
        length :- 1
        return value
    end method
    method removelast:object()
        assert head and length
        local value:object = head.pred.value
        head.pred.remove()
        length :- 1
        return value
    end method
    method removenode:object( node:CollectionIndexedLinkedNode )
        local Lnode:LListNode = LListNode( node )
        assert head and length and Lnode
        local value:object = Lnode.value
        Lnode.remove()
        length :- 1
        return value
    end method
    method removevalues:CollectionIndexedLinked( value:object )
        assert head
        local node:LListNode = head.succ
        local succ:LListNode
        while node <> head
            succ = node.succ
            if node.value = value
                node.remove()
                length :- 1
            endif
            node = succ
        wend
        return self
    end method
    
    method insertbefore:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode, value:object )
        local Lnode:LListNode = LListNode( node )
        assert Lnode
        local newnode:LListNode = new LListNode.init( value )
        Lnode.insertbefore( newnode )
        length :+ 1
        return newnode
    end method
    method insertafter:CollectionIndexedLinkedNode( node:CollectionIndexedLinkedNode, value:object )
        local Lnode:LListNode = LListNode( node )
        assert Lnode
        local newnode:LListNode = new LListNode.init( value )
        Lnode.insertafter( newnode )
        length :+ 1
        return newnode
    end method
    
    ' more specialized enumerators
    method enum:Enumerator()
        return new EnumeratorLListValues.init( self )
    end method
    method enumnodes:Enumerator()
        return new EnumeratorLListNodes.init( self )
    end method
    
    ' override superclass methods with more efficient functionality
    method nodeatindex:CollectionIndexedLinkedNode( index% )
        assert head and length and index >= 0 and index < length
        local node:LListNode = head
        if index <= (length shr 1)
            ' if the index is in the lower half of the list, start from the beginning and work forward n increments
            while index >= 0
                node = node.succ
                index :- 1
            wend
        else
            ' if the index is in the higher half of the list, start from the end and work backward length-n increments
            while index < length
                node = node.pred
                index :+ 1
            wend
        endif
        return node
    end method
    
    ' verify whether some node belongs to this collection
    method hasnode%( node:LListNode )
        assert node
        local itrnode:LListNode = head.succ
        while itrnode <> head
            if itrnode = node return true
            itrnode = itrnode.succ
        wend
        return false
    end method
    
end type



type LListNode extends CollectionIndexedLinkedNode

    field pred:LListNode = self
    field succ:LListNode = self

    method init:LListNode( val:object )
        value = val
        return self
    end method
    
    ' insert another node before/after this one
    method insertbefore( node:LListNode )
        node.pred = pred
        node.succ = self
        pred.succ = node
        pred = node
    end method
    method insertafter( node:LListNode )
        node.succ = succ
        node.pred = self
        succ.pred = node
        succ = node
    end method
    
    ' utility method for tying the references of surrounding nodes to each other and setting this one's references to null to satisfy the GC
    method remove()
        succ.pred = pred
        pred.succ = succ
        pred = null
        succ = null
        value = null
    end method

end type



' More efficient enumeration classes
type EnumeratorLListNodes extends Enumerator
    
    field target:LList
    field node:LListNode
    field enumtype%
    
    method init:EnumeratorLListNodes( targ:LList )
        target = targ
        node = targ.head.succ
        return self
    end method
    
    method hasnext%()
        return node <> target.head
    end method
    method nextobject:object()
        local currentnode:LListNode = node
        node = node.succ
        return currentnode
    end method
    
end type
type EnumeratorLListValues extends EnumeratorLListNodes
    
    method nextobject:object()
        return LListNode( super.nextobject() ).value
    end method
    
end type


