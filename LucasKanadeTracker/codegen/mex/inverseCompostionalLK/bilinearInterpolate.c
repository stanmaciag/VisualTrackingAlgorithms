/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * bilinearInterpolate.c
 *
 * Code generation for function 'bilinearInterpolate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "bilinearInterpolate.h"
#include "inverseCompostionalLK_emxutil.h"
#include "floor.h"

/* Variable Definitions */
static emlrtRSInfo eb_emlrtRSI = { 3, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRSInfo fb_emlrtRSI = { 4, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRTEInfo h_emlrtRTEI = { 1, 31, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRTEInfo i_emlrtRTEI = { 3, 5, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRTEInfo j_emlrtRTEI = { 4, 5, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRTEInfo k_emlrtRTEI = { 6, 5, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtRTEInfo l_emlrtRTEI = { 7, 5, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtECInfo g_emlrtECI = { 2, 6, 18, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtECInfo h_emlrtECI = { 2, 7, 18, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtECInfo i_emlrtECI = { 2, 9, 26, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtBCInfo h_emlrtBCI = { -1, -1, 9, 72, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo i_emlrtBCI = { -1, -1, 9, 83, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo emlrtDCI = { 9, 72, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo j_emlrtBCI = { -1, -1, 9, 72, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo k_emlrtBCI = { -1, -1, 9, 97, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo l_emlrtBCI = { -1, -1, 9, 108, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo b_emlrtDCI = { 9, 97, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo m_emlrtBCI = { -1, -1, 9, 97, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtECInfo j_emlrtECI = { 2, 10, 11, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtBCInfo n_emlrtBCI = { -1, -1, 10, 51, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo o_emlrtBCI = { -1, -1, 10, 66, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo c_emlrtDCI = { 10, 51, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo p_emlrtBCI = { -1, -1, 10, 51, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo q_emlrtBCI = { -1, -1, 10, 84, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo r_emlrtBCI = { -1, -1, 10, 95, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo d_emlrtDCI = { 10, 84, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo s_emlrtBCI = { -1, -1, 10, 84, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtECInfo k_emlrtECI = { 2, 11, 11, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtBCInfo t_emlrtBCI = { -1, -1, 11, 51, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo u_emlrtBCI = { -1, -1, 11, 62, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo e_emlrtDCI = { 11, 51, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo v_emlrtBCI = { -1, -1, 11, 51, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo w_emlrtBCI = { -1, -1, 11, 76, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo x_emlrtBCI = { -1, -1, 11, 91, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo f_emlrtDCI = { 11, 76, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo y_emlrtBCI = { -1, -1, 11, 76, "image", "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtECInfo l_emlrtECI = { 2, 12, 11, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m"
};

static emlrtBCInfo ab_emlrtBCI = { -1, -1, 12, 45, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo bb_emlrtBCI = { -1, -1, 12, 60, "pixelsY",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo g_emlrtDCI = { 12, 45, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo cb_emlrtBCI = { -1, -1, 12, 45, "image",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo db_emlrtBCI = { -1, -1, 12, 78, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtBCInfo eb_emlrtBCI = { -1, -1, 12, 93, "pixelsX",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

static emlrtDCInfo h_emlrtDCI = { 12, 78, "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  1 };

static emlrtBCInfo fb_emlrtBCI = { -1, -1, 12, 78, "image",
  "bilinearInterpolate",
  "/home/maciag/Dropbox/Praca magisterska/git/matlab/LucasKanadeTracker/bilinearInterpolate.m",
  0 };

/* Function Definitions */
void bilinearInterpolate(const emlrtStack *sp, const emxArray_real_T *image,
  const emxArray_real_T *subpixelsY, const emxArray_real_T *subpixelsX,
  emxArray_real_T *imageInterpolation)
{
  emxArray_real_T *pixelsY;
  int32_T i0;
  int32_T loop_ub;
  emxArray_real_T *pixelsX;
  int32_T b_subpixelsY[2];
  int32_T b_pixelsY[2];
  emxArray_real_T *remainderY;
  int32_T b_subpixelsX[2];
  int32_T b_pixelsX[2];
  emxArray_real_T *remainderX;
  int32_T b_remainderY[2];
  int32_T b_remainderX[2];
  int32_T i1;
  real_T d0;
  int32_T i2;
  int32_T c_remainderY;
  int32_T i3;
  emxArray_real_T *r5;
  int32_T iv8[2];
  emxArray_real_T *b_image;
  int32_T c_image[2];
  int32_T b_loop_ub;
  int32_T d_remainderY[2];
  int32_T c_remainderX[2];
  int32_T i4;
  int32_T i5;
  emxArray_real_T *r6;
  int32_T iv9[2];
  emxArray_real_T *d_image;
  int32_T e_image[2];
  int32_T b_imageInterpolation[2];
  int32_T iv10[2];
  int32_T e_remainderY[2];
  int32_T d_remainderX[2];
  int32_T iv11[2];
  emxArray_real_T *f_image;
  int32_T g_image[2];
  emxArray_real_T *r7;
  int32_T c_imageInterpolation[2];
  int32_T iv12[2];
  int32_T f_remainderY[2];
  int32_T e_remainderX[2];
  int32_T g_remainderY[2];
  emxArray_real_T *h_image;
  int32_T i_image[2];
  int32_T d_imageInterpolation[2];
  int32_T iv13[2];
  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &pixelsY, 2, &i_emlrtRTEI, true);
  i0 = pixelsY->size[0] * pixelsY->size[1];
  pixelsY->size[0] = subpixelsY->size[0];
  pixelsY->size[1] = subpixelsY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)pixelsY, i0, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = subpixelsY->size[0] * subpixelsY->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    pixelsY->data[i0] = subpixelsY->data[i0];
  }

  emxInit_real_T(sp, &pixelsX, 2, &j_emlrtRTEI, true);
  st.site = &eb_emlrtRSI;
  b_floor(&st, pixelsY);
  i0 = pixelsX->size[0] * pixelsX->size[1];
  pixelsX->size[0] = subpixelsX->size[0];
  pixelsX->size[1] = subpixelsX->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)pixelsX, i0, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = subpixelsX->size[0] * subpixelsX->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    pixelsX->data[i0] = subpixelsX->data[i0];
  }

  st.site = &fb_emlrtRSI;
  b_floor(&st, pixelsX);
  for (i0 = 0; i0 < 2; i0++) {
    b_subpixelsY[i0] = subpixelsY->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_pixelsY[i0] = pixelsY->size[i0];
  }

  emxInit_real_T(sp, &remainderY, 2, &k_emlrtRTEI, true);
  if ((b_subpixelsY[0] != b_pixelsY[0]) || (b_subpixelsY[1] != b_pixelsY[1])) {
    emlrtSizeEqCheckNDR2012b(&b_subpixelsY[0], &b_pixelsY[0], &g_emlrtECI, sp);
  }

  i0 = remainderY->size[0] * remainderY->size[1];
  remainderY->size[0] = subpixelsY->size[0];
  remainderY->size[1] = subpixelsY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)remainderY, i0, (int32_T)sizeof
                    (real_T), &h_emlrtRTEI);
  loop_ub = subpixelsY->size[0] * subpixelsY->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    remainderY->data[i0] = subpixelsY->data[i0] - pixelsY->data[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_subpixelsX[i0] = subpixelsX->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_pixelsX[i0] = pixelsX->size[i0];
  }

  emxInit_real_T(sp, &remainderX, 2, &l_emlrtRTEI, true);
  if ((b_subpixelsX[0] != b_pixelsX[0]) || (b_subpixelsX[1] != b_pixelsX[1])) {
    emlrtSizeEqCheckNDR2012b(&b_subpixelsX[0], &b_pixelsX[0], &h_emlrtECI, sp);
  }

  i0 = remainderX->size[0] * remainderX->size[1];
  remainderX->size[0] = subpixelsX->size[0];
  remainderX->size[1] = subpixelsX->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)remainderX, i0, (int32_T)sizeof
                    (real_T), &h_emlrtRTEI);
  loop_ub = subpixelsX->size[0] * subpixelsX->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    remainderX->data[i0] = subpixelsX->data[i0] - pixelsX->data[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_remainderY[i0] = remainderY->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_remainderX[i0] = remainderX->size[i0];
  }

  if ((b_remainderY[0] != b_remainderX[0]) || (b_remainderY[1] != b_remainderX[1]))
  {
    emlrtSizeEqCheckNDR2012b(&b_remainderY[0], &b_remainderX[0], &i_emlrtECI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  if (!(1 <= i0)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i0, &h_emlrtBCI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  i1 = pixelsY->size[0] * pixelsY->size[1];
  if (!((i1 >= 1) && (i1 <= i0))) {
    emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &i_emlrtBCI, sp);
  }

  if (pixelsY->data[0] > pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1])
  {
    i0 = 0;
    i2 = 0;
  } else {
    d0 = pixelsY->data[0];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &emlrtDCI, sp);
    }

    i0 = image->size[0];
    i1 = (int32_T)d0;
    if (!((i1 >= 1) && (i1 <= i0))) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &j_emlrtBCI, sp);
    }

    i0 = i1 - 1;
    d0 = pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &emlrtDCI, sp);
    }

    i1 = image->size[0];
    i2 = (int32_T)d0;
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &j_emlrtBCI, sp);
    }
  }

  i1 = pixelsX->size[0] * pixelsX->size[1];
  if (!(1 <= i1)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i1, &k_emlrtBCI, sp);
  }

  i1 = pixelsX->size[0] * pixelsX->size[1];
  c_remainderY = pixelsX->size[0] * pixelsX->size[1];
  if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
    emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &l_emlrtBCI, sp);
  }

  if (pixelsX->data[0] > pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1])
  {
    i1 = 0;
    i3 = 0;
  } else {
    d0 = pixelsX->data[0];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &b_emlrtDCI, sp);
    }

    i1 = image->size[1];
    c_remainderY = (int32_T)d0;
    if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
      emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &m_emlrtBCI, sp);
    }

    i1 = c_remainderY - 1;
    d0 = pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &b_emlrtDCI, sp);
    }

    c_remainderY = image->size[1];
    i3 = (int32_T)d0;
    if (!((i3 >= 1) && (i3 <= c_remainderY))) {
      emlrtDynamicBoundsCheckR2012b(i3, 1, c_remainderY, &m_emlrtBCI, sp);
    }
  }

  emxInit_real_T(sp, &r5, 2, &h_emlrtRTEI, true);
  c_remainderY = r5->size[0] * r5->size[1];
  r5->size[0] = remainderY->size[0];
  r5->size[1] = remainderY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r5, c_remainderY, (int32_T)sizeof
                    (real_T), &h_emlrtRTEI);
  loop_ub = remainderY->size[0] * remainderY->size[1];
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    r5->data[c_remainderY] = (1.0 - remainderY->data[c_remainderY]) * (1.0 -
      remainderX->data[c_remainderY]);
  }

  for (c_remainderY = 0; c_remainderY < 2; c_remainderY++) {
    iv8[c_remainderY] = r5->size[c_remainderY];
  }

  emxInit_real_T(sp, &b_image, 2, &h_emlrtRTEI, true);
  c_remainderY = b_image->size[0] * b_image->size[1];
  b_image->size[0] = i2 - i0;
  b_image->size[1] = i3 - i1;
  emxEnsureCapacity(sp, (emxArray__common *)b_image, c_remainderY, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = i3 - i1;
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    b_loop_ub = i2 - i0;
    for (i3 = 0; i3 < b_loop_ub; i3++) {
      b_image->data[i3 + b_image->size[0] * c_remainderY] = image->data[(i0 + i3)
        + image->size[0] * (i1 + c_remainderY)];
    }
  }

  for (i2 = 0; i2 < 2; i2++) {
    c_image[i2] = b_image->size[i2];
  }

  emxFree_real_T(&b_image);
  if ((iv8[0] != c_image[0]) || (iv8[1] != c_image[1])) {
    emlrtSizeEqCheckNDR2012b(&iv8[0], &c_image[0], &i_emlrtECI, sp);
  }

  for (i2 = 0; i2 < 2; i2++) {
    d_remainderY[i2] = remainderY->size[i2];
  }

  for (i2 = 0; i2 < 2; i2++) {
    c_remainderX[i2] = remainderX->size[i2];
  }

  if ((d_remainderY[0] != c_remainderX[0]) || (d_remainderY[1] != c_remainderX[1]))
  {
    emlrtSizeEqCheckNDR2012b(&d_remainderY[0], &c_remainderX[0], &j_emlrtECI, sp);
  }

  i2 = pixelsY->size[0] * pixelsY->size[1];
  if (!(1 <= i2)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i2, &n_emlrtBCI, sp);
  }

  i2 = pixelsY->size[0] * pixelsY->size[1];
  c_remainderY = pixelsY->size[0] * pixelsY->size[1];
  if (!((c_remainderY >= 1) && (c_remainderY <= i2))) {
    emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i2, &o_emlrtBCI, sp);
  }

  if (pixelsY->data[0] + 1.0 > pixelsY->data[pixelsY->size[0] * pixelsY->size[1]
      - 1] + 1.0) {
    i2 = 0;
    i3 = 0;
  } else {
    d0 = pixelsY->data[0] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &c_emlrtDCI, sp);
    }

    i2 = image->size[0];
    c_remainderY = (int32_T)d0;
    if (!((c_remainderY >= 1) && (c_remainderY <= i2))) {
      emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i2, &p_emlrtBCI, sp);
    }

    i2 = c_remainderY - 1;
    d0 = pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &c_emlrtDCI, sp);
    }

    c_remainderY = image->size[0];
    i3 = (int32_T)d0;
    if (!((i3 >= 1) && (i3 <= c_remainderY))) {
      emlrtDynamicBoundsCheckR2012b(i3, 1, c_remainderY, &p_emlrtBCI, sp);
    }
  }

  c_remainderY = pixelsX->size[0] * pixelsX->size[1];
  if (!(1 <= c_remainderY)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, c_remainderY, &q_emlrtBCI, sp);
  }

  c_remainderY = pixelsX->size[0] * pixelsX->size[1];
  i4 = pixelsX->size[0] * pixelsX->size[1];
  if (!((i4 >= 1) && (i4 <= c_remainderY))) {
    emlrtDynamicBoundsCheckR2012b(i4, 1, c_remainderY, &r_emlrtBCI, sp);
  }

  if (pixelsX->data[0] > pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1])
  {
    c_remainderY = 0;
    i5 = 0;
  } else {
    d0 = pixelsX->data[0];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &d_emlrtDCI, sp);
    }

    c_remainderY = image->size[1];
    i4 = (int32_T)d0;
    if (!((i4 >= 1) && (i4 <= c_remainderY))) {
      emlrtDynamicBoundsCheckR2012b(i4, 1, c_remainderY, &s_emlrtBCI, sp);
    }

    c_remainderY = i4 - 1;
    d0 = pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &d_emlrtDCI, sp);
    }

    i4 = image->size[1];
    i5 = (int32_T)d0;
    if (!((i5 >= 1) && (i5 <= i4))) {
      emlrtDynamicBoundsCheckR2012b(i5, 1, i4, &s_emlrtBCI, sp);
    }
  }

  emxInit_real_T(sp, &r6, 2, &h_emlrtRTEI, true);
  i4 = r6->size[0] * r6->size[1];
  r6->size[0] = remainderY->size[0];
  r6->size[1] = remainderY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r6, i4, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = remainderY->size[0] * remainderY->size[1];
  for (i4 = 0; i4 < loop_ub; i4++) {
    r6->data[i4] = remainderY->data[i4] * (1.0 - remainderX->data[i4]);
  }

  for (i4 = 0; i4 < 2; i4++) {
    iv9[i4] = r6->size[i4];
  }

  emxInit_real_T(sp, &d_image, 2, &h_emlrtRTEI, true);
  i4 = d_image->size[0] * d_image->size[1];
  d_image->size[0] = i3 - i2;
  d_image->size[1] = i5 - c_remainderY;
  emxEnsureCapacity(sp, (emxArray__common *)d_image, i4, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = i5 - c_remainderY;
  for (i4 = 0; i4 < loop_ub; i4++) {
    b_loop_ub = i3 - i2;
    for (i5 = 0; i5 < b_loop_ub; i5++) {
      d_image->data[i5 + d_image->size[0] * i4] = image->data[(i2 + i5) +
        image->size[0] * (c_remainderY + i4)];
    }
  }

  for (i3 = 0; i3 < 2; i3++) {
    e_image[i3] = d_image->size[i3];
  }

  emxFree_real_T(&d_image);
  if ((iv9[0] != e_image[0]) || (iv9[1] != e_image[1])) {
    emlrtSizeEqCheckNDR2012b(&iv9[0], &e_image[0], &j_emlrtECI, sp);
  }

  i3 = imageInterpolation->size[0] * imageInterpolation->size[1];
  imageInterpolation->size[0] = r5->size[0];
  imageInterpolation->size[1] = r5->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)imageInterpolation, i3, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = r5->size[1];
  for (i3 = 0; i3 < loop_ub; i3++) {
    b_loop_ub = r5->size[0];
    for (i4 = 0; i4 < b_loop_ub; i4++) {
      imageInterpolation->data[i4 + imageInterpolation->size[0] * i3] = r5->
        data[i4 + r5->size[0] * i3] * image->data[(i0 + i4) + image->size[0] *
        (i1 + i3)];
    }
  }

  i0 = r5->size[0] * r5->size[1];
  r5->size[0] = r6->size[0];
  r5->size[1] = r6->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r5, i0, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = r6->size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    b_loop_ub = r6->size[0];
    for (i1 = 0; i1 < b_loop_ub; i1++) {
      r5->data[i1 + r5->size[0] * i0] = r6->data[i1 + r6->size[0] * i0] *
        image->data[(i2 + i1) + image->size[0] * (c_remainderY + i0)];
    }
  }

  for (i0 = 0; i0 < 2; i0++) {
    b_imageInterpolation[i0] = imageInterpolation->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    iv10[i0] = r5->size[i0];
  }

  if ((b_imageInterpolation[0] != iv10[0]) || (b_imageInterpolation[1] != iv10[1]))
  {
    emlrtSizeEqCheckNDR2012b(&b_imageInterpolation[0], &iv10[0], &i_emlrtECI, sp);
  }

  for (i0 = 0; i0 < 2; i0++) {
    e_remainderY[i0] = remainderY->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    d_remainderX[i0] = remainderX->size[i0];
  }

  if ((e_remainderY[0] != d_remainderX[0]) || (e_remainderY[1] != d_remainderX[1]))
  {
    emlrtSizeEqCheckNDR2012b(&e_remainderY[0], &d_remainderX[0], &k_emlrtECI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  if (!(1 <= i0)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i0, &t_emlrtBCI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  i1 = pixelsY->size[0] * pixelsY->size[1];
  if (!((i1 >= 1) && (i1 <= i0))) {
    emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &u_emlrtBCI, sp);
  }

  if (pixelsY->data[0] > pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1])
  {
    i0 = 0;
    i2 = 0;
  } else {
    d0 = pixelsY->data[0];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &e_emlrtDCI, sp);
    }

    i0 = image->size[0];
    i1 = (int32_T)d0;
    if (!((i1 >= 1) && (i1 <= i0))) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &v_emlrtBCI, sp);
    }

    i0 = i1 - 1;
    d0 = pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1];
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &e_emlrtDCI, sp);
    }

    i1 = image->size[0];
    i2 = (int32_T)d0;
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &v_emlrtBCI, sp);
    }
  }

  i1 = pixelsX->size[0] * pixelsX->size[1];
  if (!(1 <= i1)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i1, &w_emlrtBCI, sp);
  }

  i1 = pixelsX->size[0] * pixelsX->size[1];
  c_remainderY = pixelsX->size[0] * pixelsX->size[1];
  if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
    emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &x_emlrtBCI, sp);
  }

  if (pixelsX->data[0] + 1.0 > pixelsX->data[pixelsX->size[0] * pixelsX->size[1]
      - 1] + 1.0) {
    i1 = 0;
    i3 = 0;
  } else {
    d0 = pixelsX->data[0] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &f_emlrtDCI, sp);
    }

    i1 = image->size[1];
    c_remainderY = (int32_T)d0;
    if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
      emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &y_emlrtBCI, sp);
    }

    i1 = c_remainderY - 1;
    d0 = pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &f_emlrtDCI, sp);
    }

    c_remainderY = image->size[1];
    i3 = (int32_T)d0;
    if (!((i3 >= 1) && (i3 <= c_remainderY))) {
      emlrtDynamicBoundsCheckR2012b(i3, 1, c_remainderY, &y_emlrtBCI, sp);
    }
  }

  c_remainderY = r6->size[0] * r6->size[1];
  r6->size[0] = remainderY->size[0];
  r6->size[1] = remainderY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r6, c_remainderY, (int32_T)sizeof
                    (real_T), &h_emlrtRTEI);
  loop_ub = remainderY->size[0] * remainderY->size[1];
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    r6->data[c_remainderY] = (1.0 - remainderY->data[c_remainderY]) *
      remainderX->data[c_remainderY];
  }

  for (c_remainderY = 0; c_remainderY < 2; c_remainderY++) {
    iv11[c_remainderY] = r6->size[c_remainderY];
  }

  emxInit_real_T(sp, &f_image, 2, &h_emlrtRTEI, true);
  c_remainderY = f_image->size[0] * f_image->size[1];
  f_image->size[0] = i2 - i0;
  f_image->size[1] = i3 - i1;
  emxEnsureCapacity(sp, (emxArray__common *)f_image, c_remainderY, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = i3 - i1;
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    b_loop_ub = i2 - i0;
    for (i3 = 0; i3 < b_loop_ub; i3++) {
      f_image->data[i3 + f_image->size[0] * c_remainderY] = image->data[(i0 + i3)
        + image->size[0] * (i1 + c_remainderY)];
    }
  }

  for (i2 = 0; i2 < 2; i2++) {
    g_image[i2] = f_image->size[i2];
  }

  emxFree_real_T(&f_image);
  emxInit_real_T(sp, &r7, 2, &h_emlrtRTEI, true);
  if ((iv11[0] != g_image[0]) || (iv11[1] != g_image[1])) {
    emlrtSizeEqCheckNDR2012b(&iv11[0], &g_image[0], &k_emlrtECI, sp);
  }

  i2 = r7->size[0] * r7->size[1];
  r7->size[0] = r6->size[0];
  r7->size[1] = r6->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r7, i2, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = r6->size[1];
  for (i2 = 0; i2 < loop_ub; i2++) {
    b_loop_ub = r6->size[0];
    for (c_remainderY = 0; c_remainderY < b_loop_ub; c_remainderY++) {
      r7->data[c_remainderY + r7->size[0] * i2] = r6->data[c_remainderY +
        r6->size[0] * i2] * image->data[(i0 + c_remainderY) + image->size[0] *
        (i1 + i2)];
    }
  }

  for (i0 = 0; i0 < 2; i0++) {
    c_imageInterpolation[i0] = imageInterpolation->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    iv12[i0] = r7->size[i0];
  }

  if ((c_imageInterpolation[0] != iv12[0]) || (c_imageInterpolation[1] != iv12[1]))
  {
    emlrtSizeEqCheckNDR2012b(&c_imageInterpolation[0], &iv12[0], &i_emlrtECI, sp);
  }

  for (i0 = 0; i0 < 2; i0++) {
    f_remainderY[i0] = remainderY->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    e_remainderX[i0] = remainderX->size[i0];
  }

  if ((f_remainderY[0] != e_remainderX[0]) || (f_remainderY[1] != e_remainderX[1]))
  {
    emlrtSizeEqCheckNDR2012b(&f_remainderY[0], &e_remainderX[0], &l_emlrtECI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  if (!(1 <= i0)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i0, &ab_emlrtBCI, sp);
  }

  i0 = pixelsY->size[0] * pixelsY->size[1];
  i1 = pixelsY->size[0] * pixelsY->size[1];
  if (!((i1 >= 1) && (i1 <= i0))) {
    emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &bb_emlrtBCI, sp);
  }

  if (pixelsY->data[0] + 1.0 > pixelsY->data[pixelsY->size[0] * pixelsY->size[1]
      - 1] + 1.0) {
    i0 = 0;
    i2 = 0;
  } else {
    d0 = pixelsY->data[0] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &g_emlrtDCI, sp);
    }

    i0 = image->size[0];
    i1 = (int32_T)d0;
    if (!((i1 >= 1) && (i1 <= i0))) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &cb_emlrtBCI, sp);
    }

    i0 = i1 - 1;
    d0 = pixelsY->data[pixelsY->size[0] * pixelsY->size[1] - 1] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &g_emlrtDCI, sp);
    }

    i1 = image->size[0];
    i2 = (int32_T)d0;
    if (!((i2 >= 1) && (i2 <= i1))) {
      emlrtDynamicBoundsCheckR2012b(i2, 1, i1, &cb_emlrtBCI, sp);
    }
  }

  emxFree_real_T(&pixelsY);
  i1 = pixelsX->size[0] * pixelsX->size[1];
  if (!(1 <= i1)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, i1, &db_emlrtBCI, sp);
  }

  i1 = pixelsX->size[0] * pixelsX->size[1];
  c_remainderY = pixelsX->size[0] * pixelsX->size[1];
  if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
    emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &eb_emlrtBCI, sp);
  }

  if (pixelsX->data[0] + 1.0 > pixelsX->data[pixelsX->size[0] * pixelsX->size[1]
      - 1] + 1.0) {
    i1 = 0;
    i3 = 0;
  } else {
    d0 = pixelsX->data[0] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &h_emlrtDCI, sp);
    }

    i1 = image->size[1];
    c_remainderY = (int32_T)d0;
    if (!((c_remainderY >= 1) && (c_remainderY <= i1))) {
      emlrtDynamicBoundsCheckR2012b(c_remainderY, 1, i1, &fb_emlrtBCI, sp);
    }

    i1 = c_remainderY - 1;
    d0 = pixelsX->data[pixelsX->size[0] * pixelsX->size[1] - 1] + 1.0;
    if (d0 != (int32_T)muDoubleScalarFloor(d0)) {
      emlrtIntegerCheckR2012b(d0, &h_emlrtDCI, sp);
    }

    c_remainderY = image->size[1];
    i3 = (int32_T)d0;
    if (!((i3 >= 1) && (i3 <= c_remainderY))) {
      emlrtDynamicBoundsCheckR2012b(i3, 1, c_remainderY, &fb_emlrtBCI, sp);
    }
  }

  emxFree_real_T(&pixelsX);
  c_remainderY = remainderY->size[0] * remainderY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)remainderY, c_remainderY, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = remainderY->size[0];
  c_remainderY = remainderY->size[1];
  loop_ub *= c_remainderY;
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    remainderY->data[c_remainderY] *= remainderX->data[c_remainderY];
  }

  emxFree_real_T(&remainderX);
  for (c_remainderY = 0; c_remainderY < 2; c_remainderY++) {
    g_remainderY[c_remainderY] = remainderY->size[c_remainderY];
  }

  emxInit_real_T(sp, &h_image, 2, &h_emlrtRTEI, true);
  c_remainderY = h_image->size[0] * h_image->size[1];
  h_image->size[0] = i2 - i0;
  h_image->size[1] = i3 - i1;
  emxEnsureCapacity(sp, (emxArray__common *)h_image, c_remainderY, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = i3 - i1;
  for (c_remainderY = 0; c_remainderY < loop_ub; c_remainderY++) {
    b_loop_ub = i2 - i0;
    for (i3 = 0; i3 < b_loop_ub; i3++) {
      h_image->data[i3 + h_image->size[0] * c_remainderY] = image->data[(i0 + i3)
        + image->size[0] * (i1 + c_remainderY)];
    }
  }

  for (i2 = 0; i2 < 2; i2++) {
    i_image[i2] = h_image->size[i2];
  }

  emxFree_real_T(&h_image);
  if ((g_remainderY[0] != i_image[0]) || (g_remainderY[1] != i_image[1])) {
    emlrtSizeEqCheckNDR2012b(&g_remainderY[0], &i_image[0], &l_emlrtECI, sp);
  }

  i2 = r6->size[0] * r6->size[1];
  r6->size[0] = remainderY->size[0];
  r6->size[1] = remainderY->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)r6, i2, (int32_T)sizeof(real_T),
                    &h_emlrtRTEI);
  loop_ub = remainderY->size[1];
  for (i2 = 0; i2 < loop_ub; i2++) {
    b_loop_ub = remainderY->size[0];
    for (c_remainderY = 0; c_remainderY < b_loop_ub; c_remainderY++) {
      r6->data[c_remainderY + r6->size[0] * i2] = remainderY->data[c_remainderY
        + remainderY->size[0] * i2] * image->data[(i0 + c_remainderY) +
        image->size[0] * (i1 + i2)];
    }
  }

  emxFree_real_T(&remainderY);
  for (i0 = 0; i0 < 2; i0++) {
    d_imageInterpolation[i0] = imageInterpolation->size[i0];
  }

  for (i0 = 0; i0 < 2; i0++) {
    iv13[i0] = r6->size[i0];
  }

  if ((d_imageInterpolation[0] != iv13[0]) || (d_imageInterpolation[1] != iv13[1]))
  {
    emlrtSizeEqCheckNDR2012b(&d_imageInterpolation[0], &iv13[0], &i_emlrtECI, sp);
  }

  i0 = imageInterpolation->size[0] * imageInterpolation->size[1];
  emxEnsureCapacity(sp, (emxArray__common *)imageInterpolation, i0, (int32_T)
                    sizeof(real_T), &h_emlrtRTEI);
  loop_ub = imageInterpolation->size[0];
  c_remainderY = imageInterpolation->size[1];
  loop_ub *= c_remainderY;
  for (i0 = 0; i0 < loop_ub; i0++) {
    imageInterpolation->data[i0] = ((imageInterpolation->data[i0] + r5->data[i0])
      + r7->data[i0]) + r6->data[i0];
  }

  emxFree_real_T(&r7);
  emxFree_real_T(&r6);
  emxFree_real_T(&r5);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (bilinearInterpolate.c) */
