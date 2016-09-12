/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * inverseCompostionalLK.h
 *
 * Code generation for function 'inverseCompostionalLK'
 *
 */

#ifndef INVERSECOMPOSTIONALLK_H
#define INVERSECOMPOSTIONALLK_H

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
extern void inverseCompostionalLK(const emlrtStack *sp, const emxArray_real_T
  *previousFrame, const emxArray_real_T *currentFrame, const emxArray_real_T
  *pointsToTrack, real_T windowRadiousY, real_T windowRadiousX, real_T
  maxIterations, real_T stopThreshold, const emxArray_real_T *weightingKernel,
  const emxArray_real_T *initialOpticalFlow, emxArray_real_T *opticalFlow);

#endif

/* End of code generation (inverseCompostionalLK.h) */
