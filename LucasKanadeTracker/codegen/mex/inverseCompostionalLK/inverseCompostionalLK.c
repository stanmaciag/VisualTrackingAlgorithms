/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * inverseCompostionalLK.c
 *
 * Code generation for function 'inverseCompostionalLK'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "inverseCompostionalLK_emxutil.h"
#include "eml_int_forloop_overflow_check.h"
#include "norm.h"
#include "warning.h"
#include "sum.h"
#include "bilinearInterpolate.h"
#include "assertValidSizeArg.h"
#include "gradient.h"
#include "inverseCompostionalLK_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 10, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo b_emlrtRSI = { 27, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo c_emlrtRSI = { 30, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo d_emlrtRSI = { 31, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo e_emlrtRSI = { 34, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo f_emlrtRSI = { 37, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo g_emlrtRSI = { 38, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo h_emlrtRSI = { 39, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo i_emlrtRSI = { 46, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo j_emlrtRSI = { 54, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo k_emlrtRSI = { 55, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo l_emlrtRSI = { 58, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRSInfo s_emlrtRSI = { 21, "colon",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/colon.m" };

static emlrtRSInfo t_emlrtRSI = { 79, "colon",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/colon.m" };

static emlrtRSInfo u_emlrtRSI = { 283, "colon",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/colon.m" };

static emlrtRSInfo v_emlrtRSI = { 291, "colon",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/colon.m" };

static emlrtRSInfo w_emlrtRSI = { 17, "meshgrid",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/meshgrid.m" };

static emlrtRSInfo x_emlrtRSI = { 18, "meshgrid",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/meshgrid.m" };

static emlrtRSInfo y_emlrtRSI = { 18, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRSInfo ab_emlrtRSI = { 112, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRSInfo bb_emlrtRSI = { 114, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRSInfo cb_emlrtRSI = { 117, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRSInfo db_emlrtRSI = { 119, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRSInfo nb_emlrtRSI = { 1, "mldivide",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/mldivide.p" };

static emlrtRSInfo ob_emlrtRSI = { 54, "lusolve",
  "/opt/MATLAB/R2016a/toolbox/eml/eml/+coder/+internal/lusolve.m" };

static emlrtRSInfo pb_emlrtRSI = { 169, "lusolve",
  "/opt/MATLAB/R2016a/toolbox/eml/eml/+coder/+internal/lusolve.m" };

static emlrtRSInfo qb_emlrtRSI = { 76, "lusolve",
  "/opt/MATLAB/R2016a/toolbox/eml/eml/+coder/+internal/lusolve.m" };

static emlrtMCInfo emlrtMCI = { 37, 5, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

static emlrtRTEInfo emlrtRTEI = { 1, 24, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo b_emlrtRTEI = { 30, 9, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo c_emlrtRTEI = { 31, 9, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo d_emlrtRTEI = { 34, 9, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo e_emlrtRTEI = { 46, 13, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo o_emlrtRTEI = { 404, 15, "colon",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/ops/colon.m" };

static emlrtBCInfo emlrtBCI = { -1, -1, 74, 21, "opticalFlow",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtECInfo emlrtECI = { 2, 55, 29, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtECInfo b_emlrtECI = { 2, 54, 46, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtECInfo c_emlrtECI = { 2, 51, 26, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtRTEInfo p_emlrtRTEI = { 43, 9, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtECInfo d_emlrtECI = { 2, 39, 36, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtECInfo e_emlrtECI = { 2, 38, 36, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtECInfo f_emlrtECI = { 2, 37, 36, "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m"
};

static emlrtBCInfo b_emlrtBCI = { -1, -1, 22, 41, "pointsToTrack",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtBCInfo c_emlrtBCI = { -1, -1, 23, 41, "pointsToTrack",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtBCInfo d_emlrtBCI = { -1, -1, 24, 41, "pointsToTrack",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtBCInfo e_emlrtBCI = { -1, -1, 25, 41, "pointsToTrack",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtBCInfo f_emlrtBCI = { -1, -1, 47, 72, "initialOpticalFlow",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtBCInfo g_emlrtBCI = { -1, -1, 48, 72, "initialOpticalFlow",
  "inverseCompostionalLK",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/inverseCompostionalLK.m",
  0 };

static emlrtRSInfo sb_emlrtRSI = { 37, "repmat",
  "/opt/MATLAB/R2016a/toolbox/eml/lib/matlab/elmat/repmat.m" };

/* Function Declarations */
static void error(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location);

/* Function Definitions */
static void error(const emlrtStack *sp, const mxArray *b, emlrtMCInfo *location)
{
  const mxArray *pArray;
  pArray = b;
  emlrtCallMATLABR2012b(sp, 0, NULL, 1, &pArray, "error", true, location);
}

void inverseCompostionalLK(const emlrtStack *sp, const emxArray_real_T
  *previousFrame, const emxArray_real_T *currentFrame, const emxArray_real_T
  *pointsToTrack, real_T windowRadiousY, real_T windowRadiousX, real_T
  maxIterations, real_T stopThreshold, const emxArray_real_T *weightingKernel,
  const emxArray_real_T *initialOpticalFlow, emxArray_real_T *opticalFlow)
{
  emxArray_real_T *gradientX;
  emxArray_real_T *gradientY;
  real_T varargin_1[2];
  int32_T itilerow;
  int32_T nm1d2;
  int32_T currentPointIdx;
  emxArray_real_T *gradientYWindow;
  emxArray_real_T *gradientXWindow;
  emxArray_real_T *templateWindow;
  emxArray_real_T *windowWarped;
  emxArray_real_T *windowPixelsX;
  emxArray_real_T *windowPixelsY;
  emxArray_real_T *r0;
  emxArray_real_T *x;
  emxArray_real_T *y;
  emxArray_real_T *a;
  emxArray_real_T *b_windowWarped;
  emxArray_real_T *r1;
  emxArray_real_T *b_windowPixelsY;
  emxArray_real_T *b_windowPixelsX;
  emxArray_real_T *r2;
  emxArray_real_T *r3;
  emxArray_real_T *r4;
  real_T currentFlow[2];
  int32_T ibmat;
  real_T windowYRangeMin;
  real_T windowYRangeMax;
  real_T windowXRangeMin;
  real_T windowXRangeMax;
  int32_T ntilerows;
  real_T a21;
  real_T apnd;
  real_T ndbl;
  boolean_T n_too_large;
  real_T cdiff;
  real_T absa;
  real_T absb;
  int32_T k;
  const mxArray *b_y;
  char_T u[15];
  static const char_T cv0[15] = { 'M', 'A', 'T', 'L', 'A', 'B', ':', 'p', 'm',
    'a', 'x', 's', 'i', 'z', 'e' };

  const mxArray *m0;
  static const int32_T iv0[2] = { 1, 15 };

  const mxArray *c_y;
  char_T b_u[15];
  static const int32_T iv1[2] = { 1, 15 };

  int32_T iv2[2];
  int32_T b_weightingKernel[2];
  real_T gradientMomentXX;
  int32_T b_gradientXWindow[2];
  const mxArray *d_y;
  char_T c_u[15];
  static const int32_T iv3[2] = { 1, 15 };

  const mxArray *e_y;
  char_T d_u[15];
  int32_T b_gradientYWindow[2];
  static const int32_T iv4[2] = { 1, 15 };

  int32_T iv5[2];
  int32_T c_weightingKernel[2];
  real_T gradientMomentXY;
  int32_T iv6[2];
  int32_T d_weightingKernel[2];
  real_T gradientMomentYY;
  real_T hessian[4];
  boolean_T exitg1;
  int32_T c_windowWarped[2];
  int32_T b_templateWindow[2];
  int32_T c_gradientXWindow[2];
  int32_T d_windowWarped[2];
  int32_T iv7[2];
  int32_T e_weightingKernel[2];
  int32_T c_gradientYWindow[2];
  int32_T e_windowWarped[2];
  int32_T f_windowWarped[2];
  int32_T f_weightingKernel[2];
  real_T steppestDescentUpdate[2];
  real_T flowChange[2];
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &gradientX, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &gradientY, 2, &emlrtRTEI, true);

  /*  References */
  /*  ---------- */
  /*  1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying  */
  /*  Framework International Journal of Computer Vision, 2004, 56, 221-255 */
  /*  Compute spatial gradients of previous frame */
  st.site = &emlrtRSI;
  gradient(&st, previousFrame, gradientX, gradientY);

  /*  Initialize optical flow vectors */
  for (itilerow = 0; itilerow < 2; itilerow++) {
    varargin_1[itilerow] = pointsToTrack->size[itilerow];
  }

  itilerow = opticalFlow->size[0] * opticalFlow->size[1];
  opticalFlow->size[0] = (int32_T)varargin_1[0];
  opticalFlow->size[1] = 2;
  emxEnsureCapacity(sp, (emxArray__common *)opticalFlow, itilerow, (int32_T)
                    sizeof(real_T), &emlrtRTEI);
  nm1d2 = (int32_T)varargin_1[0] << 1;
  for (itilerow = 0; itilerow < nm1d2; itilerow++) {
    opticalFlow->data[itilerow] = 0.0;
  }

  /*  Iterate for every given point to track */
  currentPointIdx = 1;
  emxInit_real_T(sp, &gradientYWindow, 2, &b_emlrtRTEI, true);
  emxInit_real_T(sp, &gradientXWindow, 2, &c_emlrtRTEI, true);
  emxInit_real_T(sp, &templateWindow, 2, &d_emlrtRTEI, true);
  emxInit_real_T(sp, &windowWarped, 2, &e_emlrtRTEI, true);
  emxInit_real_T(sp, &windowPixelsX, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &windowPixelsY, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &r0, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &x, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &y, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &a, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &b_windowWarped, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &r1, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &b_windowPixelsY, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &b_windowPixelsX, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &r2, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &r3, 2, &emlrtRTEI, true);
  emxInit_real_T(sp, &r4, 2, &emlrtRTEI, true);
  while (currentPointIdx - 1 <= pointsToTrack->size[0] - 1) {
    /*  Initialize optical flow estimation for the current point */
    for (ibmat = 0; ibmat < 2; ibmat++) {
      currentFlow[ibmat] = 0.0;
    }

    /*  Determine current point tracking window  */
    itilerow = pointsToTrack->size[0];
    if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
      emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &b_emlrtBCI,
        sp);
    }

    windowYRangeMin = pointsToTrack->data[(currentPointIdx + pointsToTrack->
      size[0]) - 1] - windowRadiousY;
    itilerow = pointsToTrack->size[0];
    if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
      emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &c_emlrtBCI,
        sp);
    }

    windowYRangeMax = pointsToTrack->data[(currentPointIdx + pointsToTrack->
      size[0]) - 1] + windowRadiousY;
    itilerow = pointsToTrack->size[0];
    if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
      emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &d_emlrtBCI,
        sp);
    }

    windowXRangeMin = pointsToTrack->data[currentPointIdx - 1] - windowRadiousX;
    itilerow = pointsToTrack->size[0];
    if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
      emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &e_emlrtBCI,
        sp);
    }

    windowXRangeMax = pointsToTrack->data[currentPointIdx - 1] + windowRadiousX;
    st.site = &b_emlrtRSI;
    b_st.site = &s_emlrtRSI;
    c_st.site = &t_emlrtRSI;
    if (muDoubleScalarIsNaN(windowXRangeMin) || muDoubleScalarIsNaN
        (windowXRangeMax)) {
      ntilerows = 1;
      a21 = rtNaN;
      apnd = windowXRangeMax;
      n_too_large = false;
    } else if (windowXRangeMax < windowXRangeMin) {
      ntilerows = 0;
      a21 = windowXRangeMin;
      apnd = windowXRangeMax;
      n_too_large = false;
    } else if (muDoubleScalarIsInf(windowXRangeMin) || muDoubleScalarIsInf
               (windowXRangeMax)) {
      ntilerows = 1;
      a21 = rtNaN;
      apnd = windowXRangeMax;
      n_too_large = !(windowXRangeMin == windowXRangeMax);
    } else {
      a21 = windowXRangeMin;
      ndbl = muDoubleScalarFloor((windowXRangeMax - windowXRangeMin) + 0.5);
      apnd = windowXRangeMin + ndbl;
      cdiff = apnd - windowXRangeMax;
      absa = muDoubleScalarAbs(windowXRangeMin);
      absb = muDoubleScalarAbs(windowXRangeMax);
      if (muDoubleScalarAbs(cdiff) < 4.4408920985006262E-16 * muDoubleScalarMax
          (absa, absb)) {
        ndbl++;
        apnd = windowXRangeMax;
      } else if (cdiff > 0.0) {
        apnd = windowXRangeMin + (ndbl - 1.0);
      } else {
        ndbl++;
      }

      n_too_large = (2.147483647E+9 < ndbl);
      if (ndbl >= 0.0) {
        ntilerows = (int32_T)ndbl;
      } else {
        ntilerows = 0;
      }
    }

    d_st.site = &u_emlrtRSI;
    if (!n_too_large) {
    } else {
      emlrtErrorWithMessageIdR2012b(&d_st, &o_emlrtRTEI, "Coder:MATLAB:pmaxsize",
        0);
    }

    itilerow = x->size[0] * x->size[1];
    x->size[0] = 1;
    x->size[1] = ntilerows;
    emxEnsureCapacity(&c_st, (emxArray__common *)x, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    if (ntilerows > 0) {
      x->data[0] = a21;
      if (ntilerows > 1) {
        x->data[ntilerows - 1] = apnd;
        nm1d2 = (ntilerows - 1) / 2;
        d_st.site = &v_emlrtRSI;
        for (k = 1; k < nm1d2; k++) {
          x->data[k] = a21 + (real_T)k;
          x->data[(ntilerows - k) - 1] = apnd - (real_T)k;
        }

        if (nm1d2 << 1 == ntilerows - 1) {
          x->data[nm1d2] = (a21 + apnd) / 2.0;
        } else {
          x->data[nm1d2] = a21 + (real_T)nm1d2;
          x->data[nm1d2 + 1] = apnd - (real_T)nm1d2;
        }
      }
    }

    st.site = &b_emlrtRSI;
    b_st.site = &s_emlrtRSI;
    c_st.site = &t_emlrtRSI;
    if (muDoubleScalarIsNaN(windowYRangeMin) || muDoubleScalarIsNaN
        (windowYRangeMax)) {
      ntilerows = 1;
      a21 = rtNaN;
      apnd = windowYRangeMax;
      n_too_large = false;
    } else if (windowYRangeMax < windowYRangeMin) {
      ntilerows = 0;
      a21 = windowYRangeMin;
      apnd = windowYRangeMax;
      n_too_large = false;
    } else if (muDoubleScalarIsInf(windowYRangeMin) || muDoubleScalarIsInf
               (windowYRangeMax)) {
      ntilerows = 1;
      a21 = rtNaN;
      apnd = windowYRangeMax;
      n_too_large = !(windowYRangeMin == windowYRangeMax);
    } else {
      a21 = windowYRangeMin;
      ndbl = muDoubleScalarFloor((windowYRangeMax - windowYRangeMin) + 0.5);
      apnd = windowYRangeMin + ndbl;
      cdiff = apnd - windowYRangeMax;
      absa = muDoubleScalarAbs(windowYRangeMin);
      absb = muDoubleScalarAbs(windowYRangeMax);
      if (muDoubleScalarAbs(cdiff) < 4.4408920985006262E-16 * muDoubleScalarMax
          (absa, absb)) {
        ndbl++;
        apnd = windowYRangeMax;
      } else if (cdiff > 0.0) {
        apnd = windowYRangeMin + (ndbl - 1.0);
      } else {
        ndbl++;
      }

      n_too_large = (2.147483647E+9 < ndbl);
      if (ndbl >= 0.0) {
        ntilerows = (int32_T)ndbl;
      } else {
        ntilerows = 0;
      }
    }

    d_st.site = &u_emlrtRSI;
    if (!n_too_large) {
    } else {
      emlrtErrorWithMessageIdR2012b(&d_st, &o_emlrtRTEI, "Coder:MATLAB:pmaxsize",
        0);
    }

    itilerow = y->size[0] * y->size[1];
    y->size[0] = 1;
    y->size[1] = ntilerows;
    emxEnsureCapacity(&c_st, (emxArray__common *)y, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    if (ntilerows > 0) {
      y->data[0] = a21;
      if (ntilerows > 1) {
        y->data[ntilerows - 1] = apnd;
        nm1d2 = (ntilerows - 1) / 2;
        d_st.site = &v_emlrtRSI;
        for (k = 1; k < nm1d2; k++) {
          y->data[k] = a21 + (real_T)k;
          y->data[(ntilerows - k) - 1] = apnd - (real_T)k;
        }

        if (nm1d2 << 1 == ntilerows - 1) {
          y->data[nm1d2] = (a21 + apnd) / 2.0;
        } else {
          y->data[nm1d2] = a21 + (real_T)nm1d2;
          y->data[nm1d2 + 1] = apnd - (real_T)nm1d2;
        }
      }
    }

    st.site = &b_emlrtRSI;
    if ((x->size[1] == 0) || (y->size[1] == 0)) {
      itilerow = windowPixelsX->size[0] * windowPixelsX->size[1];
      windowPixelsX->size[0] = 0;
      windowPixelsX->size[1] = 0;
      emxEnsureCapacity(&st, (emxArray__common *)windowPixelsX, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      itilerow = windowPixelsY->size[0] * windowPixelsY->size[1];
      windowPixelsY->size[0] = 0;
      windowPixelsY->size[1] = 0;
      emxEnsureCapacity(&st, (emxArray__common *)windowPixelsY, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
    } else {
      b_st.site = &w_emlrtRSI;
      nm1d2 = x->size[1];
      itilerow = a->size[0] * a->size[1];
      a->size[0] = 1;
      a->size[1] = nm1d2;
      emxEnsureCapacity(&b_st, (emxArray__common *)a, itilerow, (int32_T)sizeof
                        (real_T), &emlrtRTEI);
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        a->data[a->size[0] * itilerow] = x->data[itilerow];
      }

      varargin_1[0] = y->size[1];
      varargin_1[1] = 1.0;
      c_st.site = &y_emlrtRSI;
      assertValidSizeArg(&c_st, varargin_1);
      if (varargin_1[0] == varargin_1[0]) {
      } else {
        for (itilerow = 0; itilerow < 15; itilerow++) {
          u[itilerow] = cv0[itilerow];
        }

        b_y = NULL;
        m0 = emlrtCreateCharArray(2, iv0);
        emlrtInitCharArrayR2013a(&b_st, 15, m0, &u[0]);
        emlrtAssign(&b_y, m0);
        c_st.site = &sb_emlrtRSI;
        error(&c_st, b_y, &emlrtMCI);
      }

      nm1d2 = a->size[1];
      if (nm1d2 == a->size[1]) {
      } else {
        for (itilerow = 0; itilerow < 15; itilerow++) {
          b_u[itilerow] = cv0[itilerow];
        }

        c_y = NULL;
        m0 = emlrtCreateCharArray(2, iv1);
        emlrtInitCharArrayR2013a(&b_st, 15, m0, &b_u[0]);
        emlrtAssign(&c_y, m0);
        c_st.site = &sb_emlrtRSI;
        error(&c_st, c_y, &emlrtMCI);
      }

      itilerow = windowPixelsX->size[0] * windowPixelsX->size[1];
      windowPixelsX->size[0] = (int32_T)varargin_1[0];
      windowPixelsX->size[1] = nm1d2;
      emxEnsureCapacity(&b_st, (emxArray__common *)windowPixelsX, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      nm1d2 = a->size[1];
      ntilerows = (int32_T)varargin_1[0];
      c_st.site = &ab_emlrtRSI;
      c_st.site = &bb_emlrtRSI;
      if (nm1d2 > 2147483646) {
        d_st.site = &q_emlrtRSI;
        check_forloop_overflow_error(&d_st);
      }

      for (k = 0; k + 1 <= nm1d2; k++) {
        ibmat = k * ntilerows;
        c_st.site = &cb_emlrtRSI;
        if (ntilerows > 2147483646) {
          d_st.site = &q_emlrtRSI;
          check_forloop_overflow_error(&d_st);
        }

        for (itilerow = 1; itilerow <= ntilerows; itilerow++) {
          windowPixelsX->data[(ibmat + itilerow) - 1] = a->data[k];
        }
      }

      b_st.site = &x_emlrtRSI;
      varargin_1[0] = 1.0;
      varargin_1[1] = x->size[1];
      c_st.site = &y_emlrtRSI;
      assertValidSizeArg(&c_st, varargin_1);
      ibmat = y->size[1];
      nm1d2 = y->size[1];
      if (ibmat == nm1d2) {
      } else {
        for (itilerow = 0; itilerow < 15; itilerow++) {
          c_u[itilerow] = cv0[itilerow];
        }

        d_y = NULL;
        m0 = emlrtCreateCharArray(2, iv3);
        emlrtInitCharArrayR2013a(&b_st, 15, m0, &c_u[0]);
        emlrtAssign(&d_y, m0);
        c_st.site = &sb_emlrtRSI;
        error(&c_st, d_y, &emlrtMCI);
      }

      if (varargin_1[1] == varargin_1[1]) {
      } else {
        for (itilerow = 0; itilerow < 15; itilerow++) {
          d_u[itilerow] = cv0[itilerow];
        }

        e_y = NULL;
        m0 = emlrtCreateCharArray(2, iv4);
        emlrtInitCharArrayR2013a(&b_st, 15, m0, &d_u[0]);
        emlrtAssign(&e_y, m0);
        c_st.site = &sb_emlrtRSI;
        error(&c_st, e_y, &emlrtMCI);
      }

      itilerow = windowPixelsY->size[0] * windowPixelsY->size[1];
      windowPixelsY->size[0] = ibmat;
      windowPixelsY->size[1] = (int32_T)varargin_1[1];
      emxEnsureCapacity(&b_st, (emxArray__common *)windowPixelsY, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      ibmat = y->size[1];
      c_st.site = &ab_emlrtRSI;
      if (varargin_1[1] > 2.147483646E+9) {
        d_st.site = &q_emlrtRSI;
        check_forloop_overflow_error(&d_st);
      }

      for (nm1d2 = 1; nm1d2 <= (int32_T)varargin_1[1]; nm1d2++) {
        ntilerows = (nm1d2 - 1) * ibmat;
        c_st.site = &cb_emlrtRSI;
        c_st.site = &db_emlrtRSI;
        if (ibmat > 2147483646) {
          d_st.site = &q_emlrtRSI;
          check_forloop_overflow_error(&d_st);
        }

        for (k = 1; k <= ibmat; k++) {
          windowPixelsY->data[(ntilerows + k) - 1] = y->data[k - 1];
        }
      }
    }

    /*  Get spatial gradient for current window */
    st.site = &c_emlrtRSI;
    bilinearInterpolate(&st, gradientY, windowPixelsY, windowPixelsX,
                        gradientYWindow);
    st.site = &d_emlrtRSI;
    bilinearInterpolate(&st, gradientX, windowPixelsY, windowPixelsX,
                        gradientXWindow);

    /*  Get template for current window */
    st.site = &e_emlrtRSI;
    bilinearInterpolate(&st, previousFrame, windowPixelsY, windowPixelsX,
                        templateWindow);

    /*  Compute Hessian matrix */
    itilerow = r0->size[0] * r0->size[1];
    r0->size[0] = gradientXWindow->size[0];
    r0->size[1] = gradientXWindow->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r0, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = gradientXWindow->size[0] * gradientXWindow->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r0->data[itilerow] = gradientXWindow->data[itilerow] *
        gradientXWindow->data[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      iv2[itilerow] = r0->size[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      b_weightingKernel[itilerow] = weightingKernel->size[itilerow];
    }

    if ((iv2[0] != b_weightingKernel[0]) || (iv2[1] != b_weightingKernel[1])) {
      emlrtSizeEqCheckNDR2012b(&iv2[0], &b_weightingKernel[0], &f_emlrtECI, sp);
    }

    itilerow = r4->size[0] * r4->size[1];
    r4->size[0] = r0->size[0];
    r4->size[1] = r0->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r4, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = r0->size[0] * r0->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r4->data[itilerow] = r0->data[itilerow] * weightingKernel->data[itilerow];
    }

    st.site = &f_emlrtRSI;
    sum(&st, r4, x);
    st.site = &f_emlrtRSI;
    gradientMomentXX = b_sum(&st, x);
    for (itilerow = 0; itilerow < 2; itilerow++) {
      b_gradientXWindow[itilerow] = gradientXWindow->size[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      b_gradientYWindow[itilerow] = gradientYWindow->size[itilerow];
    }

    if ((b_gradientXWindow[0] != b_gradientYWindow[0]) || (b_gradientXWindow[1]
         != b_gradientYWindow[1])) {
      emlrtSizeEqCheckNDR2012b(&b_gradientXWindow[0], &b_gradientYWindow[0],
        &e_emlrtECI, sp);
    }

    itilerow = r0->size[0] * r0->size[1];
    r0->size[0] = gradientXWindow->size[0];
    r0->size[1] = gradientXWindow->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r0, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = gradientXWindow->size[0] * gradientXWindow->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r0->data[itilerow] = gradientXWindow->data[itilerow] *
        gradientYWindow->data[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      iv5[itilerow] = r0->size[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      c_weightingKernel[itilerow] = weightingKernel->size[itilerow];
    }

    if ((iv5[0] != c_weightingKernel[0]) || (iv5[1] != c_weightingKernel[1])) {
      emlrtSizeEqCheckNDR2012b(&iv5[0], &c_weightingKernel[0], &e_emlrtECI, sp);
    }

    itilerow = r3->size[0] * r3->size[1];
    r3->size[0] = r0->size[0];
    r3->size[1] = r0->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r3, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = r0->size[0] * r0->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r3->data[itilerow] = r0->data[itilerow] * weightingKernel->data[itilerow];
    }

    st.site = &g_emlrtRSI;
    sum(&st, r3, x);
    st.site = &g_emlrtRSI;
    gradientMomentXY = b_sum(&st, x);
    itilerow = r0->size[0] * r0->size[1];
    r0->size[0] = gradientYWindow->size[0];
    r0->size[1] = gradientYWindow->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r0, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = gradientYWindow->size[0] * gradientYWindow->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r0->data[itilerow] = gradientYWindow->data[itilerow] *
        gradientYWindow->data[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      iv6[itilerow] = r0->size[itilerow];
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      d_weightingKernel[itilerow] = weightingKernel->size[itilerow];
    }

    if ((iv6[0] != d_weightingKernel[0]) || (iv6[1] != d_weightingKernel[1])) {
      emlrtSizeEqCheckNDR2012b(&iv6[0], &d_weightingKernel[0], &d_emlrtECI, sp);
    }

    itilerow = r2->size[0] * r2->size[1];
    r2->size[0] = r0->size[0];
    r2->size[1] = r0->size[1];
    emxEnsureCapacity(sp, (emxArray__common *)r2, itilerow, (int32_T)sizeof
                      (real_T), &emlrtRTEI);
    nm1d2 = r0->size[0] * r0->size[1];
    for (itilerow = 0; itilerow < nm1d2; itilerow++) {
      r2->data[itilerow] = r0->data[itilerow] * weightingKernel->data[itilerow];
    }

    st.site = &h_emlrtRSI;
    sum(&st, r2, x);
    st.site = &h_emlrtRSI;
    gradientMomentYY = b_sum(&st, x);
    hessian[0] = gradientMomentXX;
    hessian[2] = gradientMomentXY;
    hessian[1] = gradientMomentXY;
    hessian[3] = gradientMomentYY;

    /*  Estimate and refine optical flow for current point */
    emlrtForLoopVectorCheckR2012b(1.0, 1.0, maxIterations, mxDOUBLE_CLASS,
      (int32_T)maxIterations, &p_emlrtRTEI, sp);
    ibmat = 0;
    exitg1 = false;
    while ((!exitg1) && (ibmat <= (int32_T)maxIterations - 1)) {
      /*  Warp current frame window with last opitcal flow estimation */
      itilerow = b_windowPixelsY->size[0] * b_windowPixelsY->size[1];
      b_windowPixelsY->size[0] = windowPixelsY->size[0];
      b_windowPixelsY->size[1] = windowPixelsY->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)b_windowPixelsY, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      itilerow = initialOpticalFlow->size[0];
      if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
        emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &f_emlrtBCI,
          sp);
      }

      a21 = initialOpticalFlow->data[(currentPointIdx + initialOpticalFlow->
        size[0]) - 1];
      nm1d2 = windowPixelsY->size[0] * windowPixelsY->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        b_windowPixelsY->data[itilerow] = (windowPixelsY->data[itilerow] +
          currentFlow[1]) + a21;
      }

      itilerow = b_windowPixelsX->size[0] * b_windowPixelsX->size[1];
      b_windowPixelsX->size[0] = windowPixelsX->size[0];
      b_windowPixelsX->size[1] = windowPixelsX->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)b_windowPixelsX, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      itilerow = initialOpticalFlow->size[0];
      if (!((currentPointIdx >= 1) && (currentPointIdx <= itilerow))) {
        emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, itilerow, &g_emlrtBCI,
          sp);
      }

      a21 = initialOpticalFlow->data[currentPointIdx - 1];
      nm1d2 = windowPixelsX->size[0] * windowPixelsX->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        b_windowPixelsX->data[itilerow] = (windowPixelsX->data[itilerow] +
          currentFlow[0]) + a21;
      }

      st.site = &i_emlrtRSI;
      bilinearInterpolate(&st, currentFrame, b_windowPixelsY, b_windowPixelsX,
                          windowWarped);

      /*  Compute error image for current window */
      for (itilerow = 0; itilerow < 2; itilerow++) {
        c_windowWarped[itilerow] = windowWarped->size[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        b_templateWindow[itilerow] = templateWindow->size[itilerow];
      }

      if ((c_windowWarped[0] != b_templateWindow[0]) || (c_windowWarped[1] !=
           b_templateWindow[1])) {
        emlrtSizeEqCheckNDR2012b(&c_windowWarped[0], &b_templateWindow[0],
          &c_emlrtECI, sp);
      }

      itilerow = windowWarped->size[0] * windowWarped->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)windowWarped, itilerow, (int32_T)
                        sizeof(real_T), &emlrtRTEI);
      nm1d2 = windowWarped->size[0];
      ntilerows = windowWarped->size[1];
      nm1d2 *= ntilerows;
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        windowWarped->data[itilerow] -= templateWindow->data[itilerow];
      }

      /*  Update steppest descent parameters */
      for (itilerow = 0; itilerow < 2; itilerow++) {
        c_gradientXWindow[itilerow] = gradientXWindow->size[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        d_windowWarped[itilerow] = windowWarped->size[itilerow];
      }

      if ((c_gradientXWindow[0] != d_windowWarped[0]) || (c_gradientXWindow[1]
           != d_windowWarped[1])) {
        emlrtSizeEqCheckNDR2012b(&c_gradientXWindow[0], &d_windowWarped[0],
          &b_emlrtECI, sp);
      }

      itilerow = r0->size[0] * r0->size[1];
      r0->size[0] = gradientXWindow->size[0];
      r0->size[1] = gradientXWindow->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)r0, itilerow, (int32_T)sizeof
                        (real_T), &emlrtRTEI);
      nm1d2 = gradientXWindow->size[0] * gradientXWindow->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        r0->data[itilerow] = gradientXWindow->data[itilerow] *
          windowWarped->data[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        iv7[itilerow] = r0->size[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        e_weightingKernel[itilerow] = weightingKernel->size[itilerow];
      }

      if ((iv7[0] != e_weightingKernel[0]) || (iv7[1] != e_weightingKernel[1]))
      {
        emlrtSizeEqCheckNDR2012b(&iv7[0], &e_weightingKernel[0], &b_emlrtECI, sp);
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        c_gradientYWindow[itilerow] = gradientYWindow->size[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        e_windowWarped[itilerow] = windowWarped->size[itilerow];
      }

      if ((c_gradientYWindow[0] != e_windowWarped[0]) || (c_gradientYWindow[1]
           != e_windowWarped[1])) {
        emlrtSizeEqCheckNDR2012b(&c_gradientYWindow[0], &e_windowWarped[0],
          &emlrtECI, sp);
      }

      itilerow = windowWarped->size[0] * windowWarped->size[1];
      windowWarped->size[0] = gradientYWindow->size[0];
      windowWarped->size[1] = gradientYWindow->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)windowWarped, itilerow, (int32_T)
                        sizeof(real_T), &emlrtRTEI);
      nm1d2 = gradientYWindow->size[0] * gradientYWindow->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        windowWarped->data[itilerow] *= gradientYWindow->data[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        f_windowWarped[itilerow] = windowWarped->size[itilerow];
      }

      for (itilerow = 0; itilerow < 2; itilerow++) {
        f_weightingKernel[itilerow] = weightingKernel->size[itilerow];
      }

      if ((f_windowWarped[0] != f_weightingKernel[0]) || (f_windowWarped[1] !=
           f_weightingKernel[1])) {
        emlrtSizeEqCheckNDR2012b(&f_windowWarped[0], &f_weightingKernel[0],
          &emlrtECI, sp);
      }

      itilerow = r1->size[0] * r1->size[1];
      r1->size[0] = r0->size[0];
      r1->size[1] = r0->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)r1, itilerow, (int32_T)sizeof
                        (real_T), &emlrtRTEI);
      nm1d2 = r0->size[0] * r0->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        r1->data[itilerow] = r0->data[itilerow] * weightingKernel->data[itilerow];
      }

      st.site = &j_emlrtRSI;
      sum(&st, r1, x);
      itilerow = b_windowWarped->size[0] * b_windowWarped->size[1];
      b_windowWarped->size[0] = windowWarped->size[0];
      b_windowWarped->size[1] = windowWarped->size[1];
      emxEnsureCapacity(sp, (emxArray__common *)b_windowWarped, itilerow,
                        (int32_T)sizeof(real_T), &emlrtRTEI);
      nm1d2 = windowWarped->size[0] * windowWarped->size[1];
      for (itilerow = 0; itilerow < nm1d2; itilerow++) {
        b_windowWarped->data[itilerow] = windowWarped->data[itilerow] *
          weightingKernel->data[itilerow];
      }

      st.site = &k_emlrtRSI;
      sum(&st, b_windowWarped, y);
      st.site = &j_emlrtRSI;
      a21 = b_sum(&st, x);
      st.site = &k_emlrtRSI;
      ndbl = b_sum(&st, y);
      steppestDescentUpdate[0] = a21;
      steppestDescentUpdate[1] = ndbl;

      /*  Compute optical flow change */
      st.site = &l_emlrtRSI;
      b_st.site = &nb_emlrtRSI;
      c_st.site = &ob_emlrtRSI;
      if (muDoubleScalarAbs(gradientMomentXY) > muDoubleScalarAbs
          (gradientMomentXX)) {
        nm1d2 = 1;
        ntilerows = 0;
      } else {
        nm1d2 = 0;
        ntilerows = 1;
      }

      a21 = hessian[ntilerows] / hessian[nm1d2];
      ndbl = hessian[2 + ntilerows] - a21 * hessian[2 + nm1d2];
      if ((ndbl == 0.0) || (hessian[nm1d2] == 0.0)) {
        d_st.site = &pb_emlrtRSI;
        e_st.site = &qb_emlrtRSI;
        warning(&e_st);
      }

      flowChange[1] = (steppestDescentUpdate[ntilerows] -
                       steppestDescentUpdate[nm1d2] * a21) / ndbl;
      flowChange[0] = (steppestDescentUpdate[nm1d2] - flowChange[1] * hessian[2
                       + nm1d2]) / hessian[nm1d2];

      /*  Update optical flow by composition with warp inversion */
      for (itilerow = 0; itilerow < 2; itilerow++) {
        currentFlow[itilerow] -= flowChange[itilerow];
      }

      /*  Check stop condition */
      if (norm(flowChange) < stopThreshold) {
        /*  Stop if converged */
        exitg1 = true;
      } else {
        ibmat++;
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b(sp);
        }
      }
    }

    /*  Save result for current point */
    nm1d2 = opticalFlow->size[0];
    if (!((currentPointIdx >= 1) && (currentPointIdx <= nm1d2))) {
      emlrtDynamicBoundsCheckR2012b(currentPointIdx, 1, nm1d2, &emlrtBCI, sp);
    }

    for (itilerow = 0; itilerow < 2; itilerow++) {
      opticalFlow->data[(currentPointIdx + opticalFlow->size[0] * itilerow) - 1]
        = currentFlow[itilerow];
    }

    currentPointIdx++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  emxFree_real_T(&r4);
  emxFree_real_T(&r3);
  emxFree_real_T(&r2);
  emxFree_real_T(&b_windowPixelsX);
  emxFree_real_T(&b_windowPixelsY);
  emxFree_real_T(&r1);
  emxFree_real_T(&b_windowWarped);
  emxFree_real_T(&a);
  emxFree_real_T(&y);
  emxFree_real_T(&x);
  emxFree_real_T(&r0);
  emxFree_real_T(&windowPixelsY);
  emxFree_real_T(&windowPixelsX);
  emxFree_real_T(&gradientY);
  emxFree_real_T(&gradientX);
  emxFree_real_T(&windowWarped);
  emxFree_real_T(&templateWindow);
  emxFree_real_T(&gradientXWindow);
  emxFree_real_T(&gradientYWindow);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (inverseCompostionalLK.c) */
