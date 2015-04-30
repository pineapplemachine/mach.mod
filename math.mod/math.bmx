superstrict

'module mach.math
'moduleinfo "License: Apache 2.0"
'moduleinfo "Author: Sophie Kirschner (sophiek@pineapplemachine.com)"
'moduleinfo "30 Apr 2015: Added to mach.mod"

import "math.c"
private
extern "c"
    ' faux constants
    function cfpinfinite%() = "fpinfinite"
    function cfpnan%() = "fpnan"
    function cfpnormal%() = "fpnormal"
    function cfpsubnormal%() = "fpsubnormal"
    function cfpzero%() = "fpzero"
    ' standard math functions
    function cabs%(x%) = "abs"
    function clabs%%(x%%) = "labs"
    function cfabs!(x!) = "fabs"
    function cdiv%(x%, y%) = "div"
    function cldiv%%(x%%, y%%) = "ldiv"
    function cfmod!(x!, y!) = "fmod"
    function cremainder!(x!, y!) = "remainder"
    function cfma!(a!,b!,c!) = "fma"
    function cfmax!(x!, y!) = "fmax"
    function cfmin!(x!, y!) = "fmin"
    function cfdim!(x!, y!) = "fdim"
    function cnan!(a$) = "nan"
    function cexp!(x!) = "exp"
    function cexp2!(x!) = "exp2"
    function cexpm1!(x!) = "expm1"
    function clog!(x!) = "log"
    function clog2!(x!) = "log2"
    function clog10!(x!) = "log10"
    function clog1p!(x!) = "log1p"
    function cilogb%(x!) = "ilogb"
    function clogb!(x!) = "logb"
    function csqrt!(x!) = "sqrt"
    function ccbrt!(x!) = "cbrt"
    function chypot!(x!) = "hypot"
    function cpow!(x!) = "pow"
    function csin!(x!) = "sin"
    function ccos!(x!) = "cos"
    function ctan!(x!) = "tan"
    function casin!(x!) = "asin"
    function cacos!(x!) = "acos"
    function catan!(x!) = "atan"
    function catan2!(x!, y!) = "atan2"
    function csinh!(x!) = "sinh"
    function ccosh!(x!) = "cosh"
    function ctanh!(x!) = "tanh"
    function casinh!(x!) = "asinh"
    function cacosh!(x!) = "acosh"
    function catanh!(x!) = "atanh"
    function cerf!(x!) = "erf"
    function cerfc!(x!) = "erfc"
    function clgamma!(x!) = "lgamma"
    function ctgamma!(x!) = "tgamma"
    function cceil!(x!) = "ceil"
    function cfloor!(x!) = "floor"
    function ctrunc!(x!) = "trunc"
    function cround!(x!) = "round"
    function clround%%(x!) = "lround"
    function cnearbyint!(x!) = "nearbyint"
    function crint!(x!) = "rint"
    function clrint%%(x!) = "lrint"
    function cfrexp!(x!, y% ptr) = "frexp"
    function cldexp!(x!, y%) = "ldexp"
    function cmodf!(x!, y! ptr) = "modf"
    function cscalbn!(x!, y%) = "scalbn"
    function cscalbln!(x!, y%%) = "scalbln"
    function cnextafter!(x!, y!) = "nextafter"
    function cnexttoward!(x!, y!) = "nexttoward"
    function ccopysign!(x!, y!) = "copysign"
    function cfpclassify%(x!) = "bbfpclassify"
    function cisfinite%(x!) = "bbisfinite"
    function cisinf%(x!) = "isinf"
    function cisnan%(x!) = "isnan"
    function cisnormal%(x!) = "bbisnormal"
    function csignbit%(x!) = "bbsignbit"
    ' other math functions
    function csignum%(x%) = "signum"
    function clsignum%%(x%%) = "lsignum"
    function cfsignum!(x!) = "fsignum"
    function cradtodeg!(x!) = "radtodeg"
    function cdegtorad!(x!) = "degtorad"
    function csindeg!(x!) = "sindeg"
    function ccosdeg!(x!) = "cosdeg"
    function ctandeg!(x!) = "tandeg"
    function casindeg!(x!) = "asindeg"
    function cacosdeg!(x!) = "acosdeg"
    function catandeg!(x!) = "atandeg"
    function catan2deg!(x!, y!) = "atan2deg"
    function csinhdeg!(x!) = "sinhdeg"
    function ccoshdeg!(x!) = "coshdeg"
    function ctanhdeg!(x!) = "tanhdeg"
    function casinhdeg!(x!) = "asinhdeg"
    function cacoshdeg!(x!) = "acoshdeg"
    function catanhdeg!(x!) = "atanhdeg"
endextern
public

rem
    bbdoc: Container for math functions.
    about: Please refer to documentation of C's math.h where more detailed explanations of functionality are desired
endrem
type math
    ' faux constants
    global FP_INFINITE% = cfpinfinite()
    global FP_NAN% = cfpnan()
    global FP_NORMAL% = cfpnormal()
    global FP_SUBNORMAL% = cfpsubnormal()
    global FP_ZERO% = cfpzero()
    
    ' standard functions
    global iabs%(x%) = cabs
    global labs%%(x%%) = clabs
    global fabs!(x!) = cfabs
    global div%(x%, y%) = cdiv
    global ldiv%%(x%%, y%%) = cldiv
    global fmod!(x!, y!) = cfmod
    global remainder!(x!, y!) = cremainder
    global fma!(a!,b!,c!) = cfma
    global fmax!(x!, y!) = cfmax
    global fmin!(x!, y!) = cfmin
    global fdim!(x!, y!) = cfdim
    global nan!(a$) = cnan
    global exp!(x!) = cexp
    global exp2!(x!) = cexp2
    global expm1!(x!) = cexpm1
    global log!(x!) = clog
    global log2!(x!) = clog2
    global log10!(x!) = clog10
    global log1p!(x!) = clog1p
    global ilogb%(x!) = cilogb
    global logb!(x!) = clogb
    global sqrt!(x!) = csqrt
    global cbrt!(x!) = ccbrt
    global hypot!(x!) = chypot
    global pow!(x!) = cpow
    global sin!(x!) = csin
    global cos!(x!) = ccos
    global tan!(x!) = ctan
    global asin!(x!) = casin
    global acos!(x!) = cacos
    global atan!(x!) = catan
    global atan2!(x!, y!) = catan2
    global sinh!(x!) = csinh
    global cosh!(x!) = ccosh
    global tanh!(x!) = ctanh
    global asinh!(x!) = casinh
    global acosh!(x!) = cacosh
    global atanh!(x!) = catanh
    global erf!(x!) = cerf
    global erfc!(x!) = cerfc
    global lgamma!(x!) = clgamma
    global tgamma!(x!) = ctgamma
    global ceil!(x!) = cceil
    global floor!(x!) = cfloor
    global trunc!(x!) = ctrunc
    global round!(x!) = cround
    global lround%%(x!) = clround
    global nearbyint!(x!) = cnearbyint
    global rint!(x!) = crint
    global lrint%%(x!) = clrint
    global frexp!(x!, y% ptr) = cfrexp
    global ldexp!(x!, y%) = cldexp
    global modf!(x!, y! ptr) = cmodf
    global scalbn!(x!, y%) = cscalbn
    global scalbln!(x!, y%%) = cscalbln
    global nextafter!(x!, y!) = cnextafter
    global nexttoward!(x!, y!) = cnexttoward
    global copysign!(x!, y!) = ccopysign
    global fpclassify%(x!) = cfpclassify
    global isfinite%(x!) = cisfinite
    global isinf%(x!) = cisinf
    global isnan%(x!) = cisnan
    global isnormal%(x!) = cisnormal
    global signbit%(x!) = csignbit
    
    ' other functions
    ' returns: 1 if int x is positive, 0 if x is zero, -1 if x is negative.
    global signum%(x%) = csignum
    ' returns: 1 if long x is positive, 0 if x is zero, -1 if x is negative.
    global lsignum%%(x%%) = clsignum
    ' returns: 1 if double x is positive, 0 if x is zero, -1 if x is negative.
    global fsignum!(x!) = cfsignum
    ' returns: Radians x converted to degrees.
    global deg!(x!) = cradtodeg
    ' returns: Degrees x converted to radians.
    global rad!(x!) = cdegtorad
    ' trig functions using degrees instead of radians
    global sindeg!(x!) = csindeg
    global cosdeg!(x!) = ccosdeg
    global tandeg!(x!) = ctandeg
    global asindeg!(x!) = casindeg
    global acosdeg!(x!) = cacosdeg
    global atandeg!(x!) = catandeg
    global atan2deg!(x!, y!) = catan2deg
    global sinhdeg!(x!) = csinhdeg
    global coshdeg!(x!) = ccoshdeg
    global tanhdeg!(x!) = ctanhdeg
    global asinhdeg!(x!) = casinhdeg
    global acoshdeg!(x!) = cacoshdeg
    global atanhdeg!(x!) = catanhdeg
end type
