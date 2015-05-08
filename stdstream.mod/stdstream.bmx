superstrict

module mach.stdstream
moduleinfo "License: Apache 2.0"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "8 May 2015: Added to mach.mod"

import mach.basestream
import "std.c"

private
extern "c"
    function cgetstdin%() = "getstdin"
    function cgetstdout%() = "getstdout"
    function cgetstderr%() = "getstderr"
    function cfread%( buf:byte ptr, size%, count%, cfilestream% ) = "fread"
    function cfwrite%( buf:byte ptr, size%, count%, cfilestream% ) = "fwrite"
    function cfflush( cfilestream% ) = "fflush"
    function cfseek( cfilestream%, offset%, origin% ) = "fseek"
    function cftell%( cfilestream% ) = "ftell"
    function cfeof%( cfilestream% ) = "feof"
endextern
public

type StdStream extends BaseStream
    global STDIN% = cgetstdin()
    global STDOUT% = cgetstdout()
    global STDERR% = cgetstderr()
    
    global in:StdStream = new StdStream.init(STDIN, 0)
    global out:StdStream = new StdStream.init(0, STDOUT)
    global err:StdStream = new StdStream.init(0, STDERR)
    global io:StdStream = new StdStream.init(STDIN, STDOUT)
    
    field instream%
    field outstream%
    
    method init:StdStream(i%, o%)
        instream = i
        outstream = o
        return self
    end method
    
    method flush%()
        assert outstream
        cfflush(outstream)
    end method
    method active%()
        return instream<>0 or outstream<>0
    end method
    method eof%()
        assert instream
        return cfeof(instream)
    end method
    
    method readbuffer%(buffer:byte ptr, count%)
        assert instream
        return cfread(buffer, 1, count, instream)
    end method
    method writebuffer%(buffer:byte ptr, count%)
        assert outstream
        return cfwrite(buffer, 1, count, outstream)
    end method
end type
