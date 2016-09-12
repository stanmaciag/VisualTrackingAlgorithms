/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * inverseCompostionalLK_initialize.c
 *
 * Code generation for function 'inverseCompostionalLK_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "inverseCompostionalLK_initialize.h"
#include "_coder_inverseCompostionalLK_mex.h"
#include "inverseCompostionalLK_data.h"

/* Function Definitions */
void inverseCompostionalLK_initialize(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (inverseCompostionalLK_initialize.c) */
