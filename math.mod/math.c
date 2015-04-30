#include <math.h>

#define RAD_TO_DEG 57.2957795130823208767981548141052
#define DEG_TO_RAD 0.0174532925199432957692369076848861

int fpinfinite(){ return FP_INFINITE; }
int fpnan(){ return FP_NAN; }
int fpnormal(){ return FP_NORMAL; }
int fpsubnormal(){ return FP_SUBNORMAL; }
int fpzero(){ return FP_ZERO; }

int signum(int x){ return (0<x)-(x<0); }
long lsignum(long x){ return (0<x)-(x<0); }
double fsignum(double x){ return (0<x)-(x<0); }

double radtodeg(double x){ return x * RAD_TO_DEG; }
double degtorad(double x){ return x * DEG_TO_RAD; }

double sindeg(double x){ return sin(x*RAD_TO_DEG); }
double cosdeg(double x){ return cos(x*RAD_TO_DEG); }
double tandeg(double x){ return tan(x*RAD_TO_DEG); }
double sinhdeg(double x){ return sinh(x*RAD_TO_DEG); }
double coshdeg(double x){ return cosh(x*RAD_TO_DEG); }
double tanhdeg(double x){ return tanh(x*RAD_TO_DEG); }
double asindeg(double x){ return asin(x)*RAD_TO_DEG; }
double acosdeg(double x){ return acos(x)*RAD_TO_DEG; }
double atandeg(double x){ return atan(x)*RAD_TO_DEG; }
double asinhdeg(double x){ return asinh(x)*RAD_TO_DEG; }
double acoshdeg(double x){ return acosh(x)*RAD_TO_DEG; }
double atanhdeg(double x){ return atanh(x)*RAD_TO_DEG; }
double atan2deg(double x,double y){ return atan2(x,y)*RAD_TO_DEG; }

int bbfpclassify(double x){ return fpclassify(x); }
int bbisfinite(double x){ return isfinite(x); }
int bbisnormal(double x){ return isnormal(x); }
int bbsignbit(double x){ return (int) signbit(x); }




