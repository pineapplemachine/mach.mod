#include <fenv.h>

const fenv_t* fedflenv(){ return FE_DFL_ENV; }
int fedivbyzero(){ return FE_DIVBYZERO; }
int feinexact(){ return FE_INEXACT; }
int feinvalid(){ return FE_INVALID; }
int feoverflow(){ return FE_OVERFLOW; }
int feunderflow(){ return FE_UNDERFLOW; }
int feallexcept(){ return FE_ALL_EXCEPT; }
int fedownward(){ return FE_DOWNWARD; }
int fetonearest(){ return FE_TONEAREST; }
int fetowardzero(){ return FE_TOWARDZERO; }
int feupward(){ return FE_UPWARD; }
int fenvsize(){ return (int) sizeof(fenv_t); }
