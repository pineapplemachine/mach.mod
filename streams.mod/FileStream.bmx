superstrict
import brl.blitz
import "BaseStream.bmx"

private
extern "c"
const SEEK_SET% = 0
const SEEK_CUR% = 1
const SEEK_END% = 2
function cfileclose( cfilestream% ) = "fclose"
function cfileread%( buf:byte ptr, size%, count%, cfilestream% ) = "fread"
function cfilewrite%( buf:byte ptr, size%, count%, cfilestream% ) = "fwrite"
function cfileflush( cfilestream% ) = "fflush"
function cfileseek( cfilestream%, offset%, origin% ) = "fseek"
function cfiletell%( cfilestream% ) = "ftell"
function cfileeof%( cfilestream% ) = "feof"
endextern
public

type FileStream extends BaseStream
    
    ' faux constants
    const MODE_READ$ = "rb"
    const MODE_WRITE$ = "wb"
    const MODE_APPEND$ = "ab"
    const MODE_READWRITE$ = "r+b"
    const MODE_CREATE$ = "w+b"
    const MODE_READAPPEND$ = "a+b"
    
    field allowread%
    field allowwrite%
    field cfilestream%
    
    method fileseek%(value%)
        assert cfilestream
        cfileseek(cfilestream, value, SEEK_SET)
        return true
    end method
    method flush%()
        assert cfilestream
        cfileflush(cfilestream)
        return true
    end method
    method close%()
        assert cfilestream
        cfileclose(cfilestream)
        cfilestream = 0
        return true
    end method
    method active%()
        return cfilestream <> 0
    end method
    method pos%()
        assert cfilestream
        return cfiletell(cfilestream)
    end method
    method size%()
        cfileseek(cfilestream, 0, SEEK_END)
        local value% = cfiletell(cfilestream)
        cfileseek(cfilestream, 0, SEEK_SET)
        return value
    end method
    method eof%()
        return cfileeof(cfilestream)
    end method
    method readbuffer%(buffer:byte ptr, count%)
        assert cfilestream
        if not allowread throw new ReadStreamException
        cfileread(buffer, 1, count, cfilestream)
        return true
    end method
    method writebuffer%(buffer:byte ptr, count%)
        assert cfilestream
        if not allowwrite throw new WriteStreamException
        cfilewrite(buffer, 1, count, cfilestream)
        return true
    end method
    method skip%(count%)
        ' TODO
        return true
    end method
    
    method read:FileStream(path$)
        allowread = true
        allowwrite = false
        openfile(path, MODE_READ)
        return self
    end method
    method write:FileStream(path$)
        allowread = false
        allowwrite = true
        openfile(path, MODE_WRITE)
        return self
    end method
    method open:FileStream(path$)
        allowread = true
        allowwrite = true
        openfile(path, MODE_READWRITE)
        return self
    end method
    method create:FileStream(path$)
        allowread = true
        allowwrite = true
        openfile(path, MODE_CREATE)
        return self
    end method
    method openfile:FileStream(path$, mode$)
        path=path.Replace( "\","/" )
        cfilestream = fopen_(path, mode)
        if not cfilestream throw new OpenStreamException
        return self
    end method
    
end type


