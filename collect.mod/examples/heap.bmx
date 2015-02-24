superstrict
framework brl.standardio
import brl.random
import "../Heap.bmx"

function comparison%( obj0:object, obj1:object )
    local int0% = int(string( obj0 ))
    local int1% = int(string( obj1 ))
    return (int0 > int1)*2-1
end function
local h:heap = new heap.init( CollectionSorter.ORDER_DESCENDING, comparison )

print "pushing to heap a series of random numbers"
for local i% = 0 until 16
    local num% = rnd() * 256
    h.push( string(num) )
next
print "heap: " + h.tostring()

print "extending heap with numbers 1, 2, 4, 8, 16, 32, 512"
local arrayheap:Heap = Heap( new Heap.setorder( CollectionSorter.ORDER_DESCENDING, comparison ).array( ["1","2","4","8","16","32","512"] ) )
h.extend( arrayheap ) 
print "heap: " + h.tostring()

print "iterating over heap"
local str$ = ""
for local item$ = eachin h
    str :+ item + " "
next
print str

print "copying heap"
local h2:Heap = Heap( h.copy() )

print "popping each member of original heap"
str = ""
while h.length
    str :+ string( h.pop() ) + " "
wend
print str

print "heap: " + h.tostring()
print "copied heap: " + h2.tostring()