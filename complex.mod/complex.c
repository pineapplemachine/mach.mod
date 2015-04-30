#include <complex.h>
#include <stdlib.h>

#define cx double _Complex
#define newcx malloc(sizeof(cx))

cx* makecomplex(double real, double imaginary){
    cx* x = newcx;
    *x = real + imaginary*I;
    return x;
}
void freecomplex(cx* x){ free(x); }

#define cfunc1(name) double b##name(cx* x){ return name(*x); }
#define cfunc2(name) double b##name(cx* x, cx* y){ return name(*x, *y); }
cfunc1(creal)
cfunc1(cimag)
cfunc1(cabs)
cfunc1(carg)
cfunc1(conj)
cfunc1(cproj)
cfunc1(cexp)
cfunc1(clog)
cfunc2(cpow)
cfunc1(csqrt)
cfunc1(csin)
cfunc1(ccos)
cfunc1(ctan)
cfunc1(casin)
cfunc1(cacos)
cfunc1(catan)
cfunc1(csinh)
cfunc1(ccosh)
cfunc1(ctanh)
cfunc1(casinh)
cfunc1(cacosh)
cfunc1(catanh)

#define cop(name, op) \
cx* name(cx* x, cx* y){ \
    cx* z = newcx; \
    *z = *x op *y; \
    return z; \
}
cop(bcadd, +)
cop(bcsub, -)
cop(bcmul, *)
cop(bcdiv, /)

// int main(){
//     cx* x = makecomplex(1,1);
//     cx* y = bcadd(x,x);
//     printf("%f + %fi", bcreal(y), bcimag(y));
//     return 0;
// }


