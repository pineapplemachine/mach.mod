superstrict
import "BaseStream.bmx"

Type RamStream extends BaseStream
    
    field allowread%
    field allowwrite%
    field pointer:byte ptr
    field position%
    field length%
    
    method seek%(value%)
        position = value
        assert position  >=  0 and (length = -1 or position < length)
    end method
    method close%()
        pointer = null
    end method
    method active%()
        return pointer <> null
    end method
    method pos%()
        return position
    end method
    method size%()
        return length
    end method
    method eof%()
        return length >= 0 and position >= length
    end method
    
    ' read some number of bytes to a buffer
    method readbuffer%(buffer:byte ptr, count%)
        if not allowread return false
        if length >= 0 and count + position > length count = length - position
        memcopy(buffer, pointer + position, count)
        position :+ count
        return true
    end method
    ' write some number of bytes from a buffer
    method writebuffer%(buffer:byte ptr, count%)
        if not allowwrite return false
        if length >= 0 and count + position > length count = length - position
        memcopy(pointer + position, buffer, count)
        position :+ count
        return true
    end method
    ' skip some number of bytes in the stream
    method skip%(count%)
        position :+ count
        if length >= 0 and position > length position = length
    end method
    
    method read:RamStream(target:byte ptr, length%=-1)
        self.pointer = target
        self.length = length
        self.allowread = true
        self.allowwrite = false
        return self
    end method
    method write:RamStream(target:byte ptr, length%=-1)
        self.pointer = target
        self.length = length
        self.allowread = false
        self.allowwrite = true
        return self
    end method
    method open:RamStream(target:byte ptr, length%=-1)
        self.pointer = target
        self.length = length
        self.allowread = true
        self.allowwrite = true
        return self
    end method
    method readincbin:RamStream(path$)
        pointer = incbinptr(path)
        if not pointer return null
        length = incbinlen(path)
        allowread = true
        allowwrite = false
    end method
    
end type