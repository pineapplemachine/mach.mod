superstrict
framework brl.standardio
import brl.random
import "../AList.bmx"
import "../CollectionSorterMerge.bmx"

local l:AList = new AList.init()

print "pushing to list the letters of the alphabet"
for local i% = 0 until 26
    l.push( chr(65+i) )
next
print "list: " + l.tostring()

print "iterating through list and printing items at odd indexes"
local odd$ = ""
for local j% = 0 until l.length
    if j mod 2 odd :+ string( l.get(j) )
next
print odd

print "popping last letter: " + string( l.pop() )
print "list: " + l.tostring()

print "removing letter at index 3 (d): " + string( l.remove(3) )
print "list: " + l.tostring()

print "inserting numeral 1 at beginning of list"
l.insert( 0, "1" )
print "list: " + l.tostring()

print "item at index 6: " + string( l.get(6) )
print "setting item at index 6 to numeral 2"
l.set( 6, "2" )
print "list: " + l.tostring()

print "reversing list"
l.reverse()
print "list: " + l.tostring()

print "shuffling list"
seedrnd millisecs()
function randomfloat!()
    return rnd()
end function
l.shuffle( randomfloat )
print "list: " + l.tostring()

print "sorting list in ascending order"
function comparison%( obj0:object, obj1:object )
    return (string( obj0 ) > string( obj1 ))*2-1
end function
local sorter:CollectionSorter = new CollectionSorterMerge.init( CollectionSorter.ORDER_ASCENDING, comparison )
l.sort( sorter )
print "list: " + l.tostring()

print "extending list with the characters a,b,c,d"
local abcd:AList = AList( new AList.array(["a","b","c","d"]) )
l.extend( abcd )
print "list: " + l.tostring()

print "inserting a,b,c,d at index 2"
l.insertgroup( 2, abcd )
print "list: " + l.tostring()

print "copying list"
local l2:AList = AList( l.copy() )
print "original list: " + l.tostring()

print "clearing original list"
l.clear()
print "original list: " + l.tostring()
print "copied list: " +l2.tostring()

if l2.tostring() = "1,2,a,b,c,d,A,B,C,E,F,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,a,b,c,d"
    print "end result is as expected"
else
    print "something bugged out"
endif

