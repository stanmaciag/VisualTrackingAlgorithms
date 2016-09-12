/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * bilinearInterpolate.h
 *
 * Code generation for function 'bilinearInterpolate'
 *
 */

#ifndef BILINEARINTERPOLATE_H
#define BILINEARINTERPOLATE_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "inverseCompostionalLK_types.h"

/* Function Declarations */
extern void bilinearInterpolate(const emlrtStack *sp, const emxArray_real_T
  *image, const emxArray_real_T *subpixelsY, const emxArray_real_T *subpixelsX,
  emxArray_real_T *imageInterpolation);

#endif

/* End of code generation (bilinearInterpolate.h) */
