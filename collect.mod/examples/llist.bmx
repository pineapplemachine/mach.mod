superstrict
framework brl.standardio
import brl.random
import "../LList.bmx"

local l:LList = new LList.init()

print "pushing to list the letters of the alphabet"
for local i% = 0 until 26
    l.push( chr(65+i) )
next
print "list: " + l.tostring()

print "printing items at odd indexes"
local odd$ = ""
for local j% = 0 until l.length
    if j mod 2 odd :+ string( l.get(j) )
next
print odd

print "popping last letter: " + string( l.pop() )
print "list: " + l.tostring()

