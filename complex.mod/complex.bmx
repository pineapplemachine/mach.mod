superstrict

module mach.complex
moduleinfo "License: zlib/libpng"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "30 Apr 2015: Added to mach.mod"

import "complex.c"
extern "c"
    ' standard (ish)
    function creal!(a@ ptr) = "bcreal"
    function cimag!(a@ ptr) = "bcimag"
    function ccabs!(a@ ptr) = "bcabs"
    function carg!(a@ ptr) = "bcarg"
    function cconj!(a@ ptr) = "bconj"
    function cproj!(a@ ptr) = "bcproj"
    function cexp!(a@ ptr) = "bcexp"
    function clog!(a@ ptr) = "bclog"
    function cpow!(a@ ptr, b@ ptr) = "bcpow"
    function csqrt!(a@ ptr) = "bcsqrt"
    function csin!(a@ ptr) = "bcsin"
    function ccos!(a@ ptr) = "bccos"
    function ctan!(a@ ptr) = "bctan"
    function casin!(a@ ptr) = "bcasin"
    function cacos!(a@ ptr) = "bcacos"
    function catan!(a@ ptr) = "bcatan"
    function csinh!(a@ ptr) = "bcsinh"
    function ccosh!(a@ ptr) = "bccosh"
    function ctanh!(a@ ptr) = "bctanh"
    function casinh!(a@ ptr) = "bcasinh"
    function cacosh!(a@ ptr) = "bcacosh"
    function catanh!(a@ ptr) = "bcatanh"
    function cadd@ ptr(a@ ptr, b@ ptr) = "bcadd"
    function csub@ ptr(a@ ptr, b@ ptr) = "bcsub"
    function cmul@ ptr(a@ ptr, b@ ptr) = "bcmul"
    function cdiv@ ptr(a@ ptr, b@ ptr) = "bcdiv"
    ' other
    function cmakecomplex@ ptr(a!,b!) = "makecomplex"
    function cfreecomplex(a@ ptr) = "freecomplex"
endextern

rem
    bbdoc: Complex number object.
endrem
type complex
    ' Points to the corresponding double _Complex
    field p@ ptr = null
    
    rem
        bbdoc: Initializes a new complex number object given a C pointer to some
        double _Complex
        returns: The complex number object itself.
        about: Setting multiple complex objects to refer to the same double _Complex
        will result in memory management fuckups, so don't do that.
    endrem
    method init:complex(p@ ptr)
        if self.p cfreecomplex(self.p)
        self.p = p
        return self
    end method
    
    rem
        bbdoc: Sets the real and imaginary components of this complex number object.
        returns: The complex number object itself.
        about: Use it like a constructor! e.g. complex mycomplex = new complex.set(i, j)
        where i is the real component and j is the imaginary component.
    endrem
    method set:complex(i!, j!)
        if p cfreecomplex(p)
        p = cmakecomplex(i, j)
        return self
    end method
    
    rem
        bbdoc: Creates a new complex number object with the same values as this one.
        returns: The created copy.
    endrem
    method copy:complex()
        local c:complex = new complex
        c.p = cmakecomplex(real(), imag())
        return c
    end method
    
    rem
        bbdoc: Deconstructor frees the associated double _Complex
    endrem
    method delete()
        if p cfreecomplex(p)
    end method
    
    rem
        returns: The real component of this complex number object.
    endrem
    method real!()
        return creal(p)
    end method
    
    rem
        returns: The imaginary component of this complex number object.
    endrem
    method imag!()
        return cimag(p)
    end method
    
    rem
        returns: The magnitude of this complex number object.
    endrem
    method cabs!()
        return ccabs(p)
    end method
    
    rem
        returns: The phase angle of this complex number object.
    endrem
    method arg!()
        return carg(p)
    end method
    
    rem
        returns: The complex conjugate of this complex number object.
    endrem
    method conj!()
        return cconj(p)
    end method
    
    rem
        returns: The Riemann sphere projection of this complex number object.
    endrem
    method proj!()
        return cproj(p)
    end method
    
    rem
        returns: The base e exponential of this complex number object.
    endrem
    method exp!()
        return cexp(p)
    end method
    
    rem
        returns: The natural logarithm of this complex number object.
    endrem
    method log!()
        return clog(p)
    end method
    
    rem
        returns: The complex power of this complex number object.
    endrem
    method pow!(b:complex)
        return cpow(p, b.p)
    end method
    
    rem
        returns: The complex square root of this complex number object.
    endrem
    method sqrt!()
        return csqrt(p)
    end method
    
    rem
        returns: The complex sine of this complex number object.
    endrem
    method sin!()
        return csin(p)
    end method
    
    rem
        returns: The complex cosine of this complex number object.
    endrem
    method cos!()
        return ccos(p)
    end method
    
    rem
        returns: The complex tangent of this complex number object.
    endrem
    method tan!()
        return ctan(p)
    end method
    
    rem
        returns: The complex arcsine of this complex number object.
    endrem
    method asin!()
        return casin(p)
    end method
    
    rem
        returns: The complex arccosine of this complex number object.
    endrem
    method acos!()
        return cacos(p)
    end method
    
    rem
        returns: The complex arctangent of this complex number object.
    endrem
    method atan!()
        return catan(p)
    end method
    
    rem
        returns: The complex hyperbolic sine of this complex number object.
    endrem
    method sinh!()
        return csinh(p)
    end method
    
    rem
        returns: The complex hyperbolic cosine of this complex number object.
    endrem
    method cosh!()
        return ccosh(p)
    end method
    
    rem
        returns: The complex hyperbolic tangent of this complex number object.
    endrem
    method tanh!()
        return ctanh(p)
    end method
    
    rem
        returns: The complex hyperbolic arcsine of this complex number object.
    endrem
    method asinh!()
        return casinh(p)
    end method
    
    rem
        returns: The complex hyperbolic arccosine of this complex number object.
    endrem
    method acosh!()
        return cacosh(p)
    end method
    
    rem
        returns: The complex hyperbolic arctangent of this complex number object.
    endrem
    method atanh!()
        return catanh(p)
    end method
    
    rem
        returns: The addition of two complex number objects.
    endrem
    method add:complex(b:complex)
        return new complex.init(cadd(p, b.p))
    end method
    
    rem
        returns: The subtraction of two complex number objects.
    endrem
    method sub:complex(b:complex)
        return new complex.init(csub(p, b.p))
    end method
    
    rem
        returns: The multiplication of two complex number objects.
    endrem
    method mul:complex(b:complex)
        return new complex.init(cmul(p, b.p))
    end method
    
    rem
        returns: The division of two complex number objects.
    endrem
    method div:complex(b:complex)
        return new complex.init(cdiv(p, b.p))
    end method
    
    rem
        returns: A string representation of this complex number object e.g. 6+2i.
    endrem
    method toString$()
        return real() + "+" + imag() + "i"
    end method
end type
