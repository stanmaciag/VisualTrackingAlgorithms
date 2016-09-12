/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * floor.c
 *
 * Code generation for function 'floor'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "floor.h"
#include "eml_int_forloop_overflow_check.h"
#include "inverseCompostionalLK_data.h"

/* Variable Definitions */
static emlrtRSInfo gb_emlrtRSI = { 10, "floor",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elfun/floor.m" };

static emlrtRSInfo hb_emlrtRSI = { 24, "applyScalarFunctionInPlace",
  "/opt/MATLAB/R2016a/toolbox/eml/eml/+coder/+internal/applyScalarFunctionInPlace.m"
};

/* Function Definitions */
void b_floor(const emlrtStack *sp, emxArray_real_T *x)
{
  int32_T nx;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  st.site = &gb_emlrtRSI;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  nx = x->size[0] * x->size[1];
  b_st.site = &hb_emlrtRSI;
  if ((!(1 > nx)) && (nx > 2147483646)) {
    c_st.site = &q_emlrtRSI;
    check_forloop_overflow_error(&c_st);
  }

  for (k = 0; k + 1 <= nx; k++) {
    x->data[k] = muDoubleScalarFloor(x->data[k]);
  }
}

/* End of code generation (floor.c) */
