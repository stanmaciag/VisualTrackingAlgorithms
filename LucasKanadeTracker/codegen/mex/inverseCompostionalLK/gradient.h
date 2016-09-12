/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * gradient.h
 *
 * Code generation for function 'gradient'
 *
 */

#ifndef GRADIENT_H
#define GRADIENT_H

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
extern void gradient(const emlrtStack *sp, const emxArray_real_T *f,
                     emxArray_real_T *varargout_1, emxArray_real_T *varargout_2);

#endif

/* End of code generation (gradient.h) */
