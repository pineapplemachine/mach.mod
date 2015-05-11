import mach.enumeration
import brl.linkedlist

module mach.tlistenumerator
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "11 May 2015: Added to mach.mod"

' An enumerator for BRL linked lists which implements the various useful methods of the Enumerator class.
' Also makes it possible to enumerate a TList using the Enumerator.get() function.
' If you know something is a TList and you want to enumerate over it using this enumerator rather than
' BRL's, you can do this: For item:Object = EachIn new TListEnumerator.init(mylist)
type TListEnumerator extends AddValueEnumerator
    global registration% = Enumerator.register(TListEnumerator.getenumerator)
    function getenumerator:Enumerator(target:object)
        if TList(target) return new TListEnumerator.init(TList(target))
    end function
    
    field target:TList
    field link:TLink
    field firstlink:TLink
    field lastlink:TLink
    method init:TListEnumerator(targlist:TList)
        target = targlist
        link = target._head
        firstlink = target._head._succ
        lastlink = target._head._pred
        return self
    end method
    
    method hasnext%()
        return link <> lastlink
    end method
    method hasprev%()
        return link <> firstlink
    end method
    method nextobject:object()
        link = link._succ
        return link._value
    end method
    method prevobject:object()
        link = link._pred
        return link._value
    end method
    method reset(tail% = false)
        link = target._head
    end method
    
    method remove:object()
        link.remove()
    end method
    method add(value:object)
        addlast(value)
    end method
    method addfirst(value:object)
        target.addfirst(value)
    end method
    method addlast(value:object)
        target.addlast(value)
    end method
end type
