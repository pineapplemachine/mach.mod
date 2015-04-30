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

type complex
    field p@ ptr = null
    method init:complex(p@ ptr)
        if self.p cfreecomplex(self.p)
        self.p = p
        return self
    end method
    method set:complex(i!, j!)
        if p cfreecomplex(p)
        p = cmakecomplex(i, j)
        return self
    end method
    method delete()
        if p cfreecomplex(p)
    end method
    method real!()
        return creal(p)
    end method
    method imag!()
        return cimag(p)
    end method
    method cabs!()
        return ccabs(p)
    end method
    method arg!()
        return carg(p)
    end method
    method conj!()
        return cconj(p)
    end method
    method proj!()
        return cproj(p)
    end method
    method exp!()
        return cexp(p)
    end method
    method log!()
        return clog(p)
    end method
    method pow!(b:complex)
        return cpow(p, b.p)
    end method
    method sqrt!()
        return csqrt(p)
    end method
    method sin!()
        return csin(p)
    end method
    method cos!()
        return ccos(p)
    end method
    method tan!()
        return ctan(p)
    end method
    method asin!()
        return casin(p)
    end method
    method acos!()
        return cacos(p)
    end method
    method atan!()
        return catan(p)
    end method
    method sinh!()
        return csinh(p)
    end method
    method cosh!()
        return ccosh(p)
    end method
    method tanh!()
        return ctanh(p)
    end method
    method asinh!()
        return casinh(p)
    end method
    method acosh!()
        return cacosh(p)
    end method
    method atanh!()
        return catanh(p)
    end method
    method add:complex(b:complex)
        return new complex.init(cadd(p, b.p))
    end method
    method sub:complex(b:complex)
        return new complex.init(csub(p, b.p))
    end method
    method mul:complex(b:complex)
        return new complex.init(cmul(p, b.p))
    end method
    method div:complex(b:complex)
        return new complex.init(cdiv(p, b.p))
    end method
    method toString$()
        return real() + "+" + imag() + "i"
    end method
end type
