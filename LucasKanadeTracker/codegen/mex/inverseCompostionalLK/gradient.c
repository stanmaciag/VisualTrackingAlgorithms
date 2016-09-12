/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * gradient.c
 *
 * Code generation for function 'gradient'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "gradient.h"
#include "inverseCompostionalLK_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "inverseCompostionalLK_data.h"

/* Variable Definitions */
static emlrtRSInfo m_emlrtRSI = { 24, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRSInfo n_emlrtRSI = { 48, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRSInfo o_emlrtRSI = { 70, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRSInfo p_emlrtRSI = { 81, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRSInfo r_emlrtRSI = { 73, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRTEInfo f_emlrtRTEI = { 1, 22, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

static emlrtRTEInfo g_emlrtRTEI = { 54, 14, "gradient",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/datafun/gradient.m" };

/* Function Declarations */
static void gradf(const emlrtStack *sp, const emxArray_real_T *f,
                  emxArray_real_T *y);

/* Function Definitions */
static void gradf(const emlrtStack *sp, const emxArray_real_T *f,
                  emxArray_real_T *y)
{
  int32_T vlen;
  int32_T i;
  int32_T i2;
  boolean_T overflow;
  int32_T i1;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  vlen = f->size[0];
  for (i = 0; i < 2; i++) {
    i2 = y->size[0] * y->size[1];
    y->size[i] = f->size[i];
    emxEnsureCapacity(sp, (emxArray__common *)y, i2, (int32_T)sizeof(real_T),
                      &g_emlrtRTEI);
  }

  if (f->size[0] < 2) {
    i = y->size[0] * y->size[1];
    y->size[0] = f->size[0];
    y->size[1] = f->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)y, i, (int32_T)sizeof(real_T),
                      &g_emlrtRTEI);
    i2 = f->size[0] * f->size[1];
    for (i = 0; i < i2; i++) {
      y->data[i] = 0.0;
    }
  } else {
    i2 = -1;
    st.site = &o_emlrtRSI;
    overflow = ((!(1 > f->size[1])) && (f->size[1] > 2147483646));
    if (overflow) {
      b_st.site = &q_emlrtRSI;
      check_forloop_overflow_error(&b_st);
    }

    for (i = 1; i <= f->size[1]; i++) {
      i1 = i2 + 1;
      i2 += vlen;
      y->data[i1] = f->data[i1 + 1] - f->data[i1];
      st.site = &p_emlrtRSI;
      for (k = 1; k <= vlen - 2; k++) {
        y->data[i1 + k] = (f->data[(i1 + k) + 1] - f->data[(i1 + k) - 1]) / 2.0;
      }

      y->data[i2] = f->data[i2] - f->data[i2 - 1];
    }
  }
}

void gradient(const emlrtStack *sp, const emxArray_real_T *f, emxArray_real_T
              *varargout_1, emxArray_real_T *varargout_2)
{
  boolean_T overflow;
  int32_T vlen;
  int32_T i1;
  int32_T vstride;
  int32_T i2;
  int32_T j;
  int32_T k;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  overflow = (f->size[1] == 1);
  if (overflow) {
    st.site = &m_emlrtRSI;
    gradf(&st, f, varargout_1);
    i1 = varargout_2->size[0] * varargout_2->size[1];
    varargout_2->size[0] = f->size[0];
    varargout_2->size[1] = f->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)varargout_2, i1, (int32_T)sizeof
                      (real_T), &f_emlrtRTEI);
    vstride = f->size[0] * f->size[1];
    for (i1 = 0; i1 < vstride; i1++) {
      varargout_2->data[i1] = 0.0;
    }
  } else {
    st.site = &n_emlrtRSI;
    vlen = f->size[1];
    for (i1 = 0; i1 < 2; i1++) {
      vstride = varargout_1->size[0] * varargout_1->size[1];
      varargout_1->size[i1] = f->size[i1];
      emxEnsureCapacity(&st, (emxArray__common *)varargout_1, vstride, (int32_T)
                        sizeof(real_T), &f_emlrtRTEI);
    }

    if (f->size[1] < 2) {
      i1 = varargout_1->size[0] * varargout_1->size[1];
      varargout_1->size[0] = f->size[0];
      varargout_1->size[1] = f->size[1];
      emxEnsureCapacity(&st, (emxArray__common *)varargout_1, i1, (int32_T)
                        sizeof(real_T), &f_emlrtRTEI);
      vstride = f->size[0] * f->size[1];
      for (i1 = 0; i1 < vstride; i1++) {
        varargout_1->data[i1] = 0.0;
      }
    } else {
      vstride = f->size[0];
      i1 = -1;
      i2 = (f->size[1] - 1) * f->size[0] - 1;
      b_st.site = &r_emlrtRSI;
      overflow = ((!(1 > f->size[0])) && (f->size[0] > 2147483646));
      if (overflow) {
        c_st.site = &q_emlrtRSI;
        check_forloop_overflow_error(&c_st);
      }

      for (j = 1; j <= vstride; j++) {
        i1++;
        i2++;
        varargout_1->data[i1] = f->data[i1 + vstride] - f->data[i1];
        b_st.site = &p_emlrtRSI;
        for (k = 1; k <= vlen - 2; k++) {
          varargout_1->data[i1 + k * vstride] = (f->data[i1 + (k + 1) * vstride]
            - f->data[i1 + (k - 1) * vstride]) / 2.0;
        }

        varargout_1->data[i2] = f->data[i2] - f->data[i2 - vstride];
      }
    }

    st.site = &n_emlrtRSI;
    gradf(&st, f, varargout_2);
  }
}

/* End of code generation (gradient.c) */
