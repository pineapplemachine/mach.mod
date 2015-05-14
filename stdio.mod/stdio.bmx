superstrict

module mach.stdio
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.stdstreamio

global std:StdStreamIO = new StdStreamIO

' These functions are here for convenience, but I recommend you stick to using std.in, std.out, and std.err directly.
function input$(prompt$ = "> ")
    return std.in(prompt)
end function
function print(value$)
    std.out(value)
end function
function write(value$)
    std.out(value, false)
end function
function error(value$)
    std.err(value)
end function
