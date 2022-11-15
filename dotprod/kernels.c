//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 dotprod_base(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i] * b[i];

  return d;
}
//Unrollx8
f64 dotprod_unrollx8(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d1 = 0.0;
  double d2 = 0.0;
  double d3 = 0.0;
  double d4 = 0.0;
  double d5 = 0.0;
  double d6 = 0.0;
  double d7 = 0.0;
  double d8 = 0.0;
  
  for (u64 i = 0; i < n; i+=8) {
    d1 += a[i] * b[i];
    d2 += a[i+1] * b[i+1];
    d3 += a[i+2] * b[i+2];
    d4 += a[i+3] * b[i+3];
    d5 += a[i+4] * b[i+4];
    d6 += a[i+5] * b[i+5];
    d7 += a[i+6] * b[i+6];
    d8 += a[i+7] * b[i+7];
  }
  return d1+d2+d3+d4+d5+d6+d7+d8;
}
