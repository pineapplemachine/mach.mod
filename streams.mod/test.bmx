import "BinaryStreamIO.bmx"
import "RamStream.bmx"
import "FileStream.bmx"

local i% = 60
local io:BinaryStreamIO = new BinaryStreamIO.init( new FileStream.open( "test.txt" ) )

'io.writebytestring("hello, world!")
io.writebyte( asc("?") )

io.close()
