superstrict

module mach.fenv
moduleinfo "License: Apache 2.0"
moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
moduleinfo "30 Apr 2015: Added to mach.mod"

import "fenv.c"
private
extern "c"
    ' faux constants
    function cfedflenv@ ptr() = "fedflenv"
    function cfedivbyzero%() = "fedivbyzero"
    function cfeinexact%() = "feinexact"
    function cfeinvalid%() = "feinvalid"
    function cfeoverflow%() = "feoverflow"
    function cfeunderflow%() = "feunderflow"
    function cfeallexcept%() = "feallexcept"
    function cfedownward%() = "fedownward"
    function cfetonearest%() = "fetonearest"
    function cfetowardzero%() = "fetowardzero"
    function cfeupward%() = "feupward"
    function cfenvsize%() = "fenvsize"
    ' standard functions
    function cfegetenv%(a@ ptr) = "fegetenv"
    function cfesetenv%(a@ ptr) = "fesetenv"
    function cfeupdateenv%(a@ ptr) = "feupdateenv"
    function cfegetround%() = "fegetround"
    function cfesetround%(a%) = "fesetround"
    function cfeholdexcept%(a@ ptr) = "feholdexcept"
    function cferaiseexcept%(a%) = "feraiseexcept"
    function cfetestexcept%(a%) = "fetestexcept"
    function cfeclearexcept%(a%) = "feclearexcept"
    function cfegetexceptflag%(a@@ ptr,b%) = "fegetexceptflag"
    function cfesetexceptflag%(a@@ ptr,b%) = "fesetexceptflag"
endextern
public

' Container for fenv functions
type fenv
    ' faux constants
    global FE_DFL_ENV:fenv_t = fenv.fedflenv()
    global FE_DIVBYZERO% = cfedivbyzero()
    global FE_INEXACT% = cfeinexact()
    global FE_INVALID% = cfeinvalid()
    global FE_OVERFLOW% = cfeoverflow()
    global FE_UNDERFLOW% = cfeunderflow()
    global FE_ALL_EXCEPT% = cfeallexcept()
    global FE_DOWNWARD% = cfedownward()
    global FE_TONEAREST% = cfetonearest()
    global FE_TOWARDZERO% = cfetowardzero()
    global FE_UPWARD% = cfeupward()
    ' standard
    global fegetround%() = cfegetround
    global fesetround%(a%) = cfesetround
    global feraiseexcept%(a%) = cferaiseexcept
    global fetestexcept%(a%) = cfetestexcept
    global feclearexcept%(a%) = cfeclearexcept
    global fegetexceptflag%(a@@ ptr,b%) = cfegetexceptflag
    global fesetexceptflag%(a@@ ptr,b%) = cfesetexceptflag
    
    function fedflenv:fenv_t()
        local e:fenv_t = new fenv_t
        e.p = cfedflenv()
        return e
    end function
    function fegetenv:fenv_t()
        local e:fenv_t = new fenv_t
        if not cfegetenv(e.p)
            return null
        else
            return e
        endif
    end function
    function fesetenv%(e:fenv_t)
        return cfesetenv(e.p)
    end function
    function feupdateenv%(e:fenv_t)
        return cfeupdateenv(e.p)
    end function
    function feholdexcept%(e:fenv_t)
        return cfeholdexcept(e.p)
    end function    
end type

' The methods for fenv_t SHOULD work on your architecture (x86) but I really can't guarantee anything
type fenv_t
    field p@ ptr
    ' sizeof(fenv_t) == 16 bytes
    ' 01 23 4567 89abcdef
    ' 01:   x87 control word
    ' 23:   x87 status word
    ' 4567: SSE status/control register
    ' 8..f: Reserved for future expansion
    method getcontrol@@()
        return (short ptr p)[0]
    end method
    method getstatus@@()
        return (short ptr p)[1]
    end method
    method getregister%()
        return (int ptr p)[1]
    end method
    method setcontrol(a@@)
        (short ptr p)[0] = a
    end method
    method setstatus(a@@)
        (short ptr p)[1] = a
    end method
    method setregister(a%)
        (int ptr p)[1] = a
    end method
end type




