/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_inverseCompostionalLK_api.c
 *
 * Code generation for function '_coder_inverseCompostionalLK_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "inverseCompostionalLK.h"
#include "_coder_inverseCompostionalLK_api.h"
#include "inverseCompostionalLK_emxutil.h"
#include "inverseCompostionalLK_data.h"

/* Variable Definitions */
static emlrtRTEInfo n_emlrtRTEI = { 1, 1, "_coder_inverseCompostionalLK_api", ""
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *pointsToTrack, const char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *windowRadiousY, const char_T *identifier);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *previousFrame,
  const char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  g_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *pointsToTrack, const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  d_emlrt_marshallIn(sp, emlrtAlias(pointsToTrack), &thisId, y);
  emlrtDestroyArray(&pointsToTrack);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  h_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static real_T e_emlrt_marshallIn(const emlrtStack *sp, const mxArray
  *windowRadiousY, const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(windowRadiousY), &thisId);
  emlrtDestroyArray(&windowRadiousY);
  return y;
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *previousFrame,
  const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(previousFrame), &thisId, y);
  emlrtDestroyArray(&previousFrame);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m2;
  static const int32_T iv17[2] = { 0, 0 };

  y = NULL;
  m2 = emlrtCreateNumericArray(2, iv17, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m2, (void *)u->data);
  emlrtSetDimensions((mxArray *)m2, u->size, 2);
  emlrtAssign(&y, m2);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, -1 };

  boolean_T bv0[2] = { true, true };

  int32_T iv18[2];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv0[0],
    iv18);
  ret->size[0] = iv18[0];
  ret->size[1] = iv18[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  static const int32_T dims[2] = { -1, 2 };

  boolean_T bv1[2] = { true, false };

  int32_T iv19[2];
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims, &bv1[0],
    iv19);
  ret->size[0] = iv19[0];
  ret->size[1] = iv19[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static real_T i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void inverseCompostionalLK_api(const mxArray * const prhs[9], const mxArray
  *plhs[1])
{
  emxArray_real_T *previousFrame;
  emxArray_real_T *currentFrame;
  emxArray_real_T *pointsToTrack;
  emxArray_real_T *weightingKernel;
  emxArray_real_T *initialOpticalFlow;
  emxArray_real_T *opticalFlow;
  real_T windowRadiousY;
  real_T windowRadiousX;
  real_T maxIterations;
  real_T stopThreshold;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &previousFrame, 2, &n_emlrtRTEI, true);
  emxInit_real_T(&st, &currentFrame, 2, &n_emlrtRTEI, true);
  emxInit_real_T(&st, &pointsToTrack, 2, &n_emlrtRTEI, true);
  emxInit_real_T(&st, &weightingKernel, 2, &n_emlrtRTEI, true);
  emxInit_real_T(&st, &initialOpticalFlow, 2, &n_emlrtRTEI, true);
  emxInit_real_T(&st, &opticalFlow, 2, &n_emlrtRTEI, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "previousFrame", previousFrame);
  emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "currentFrame", currentFrame);
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "pointsToTrack", pointsToTrack);
  windowRadiousY = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]),
    "windowRadiousY");
  windowRadiousX = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]),
    "windowRadiousX");
  maxIterations = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[5]), "maxIterations");
  stopThreshold = e_emlrt_marshallIn(&st, emlrtAliasP(prhs[6]), "stopThreshold");
  emlrt_marshallIn(&st, emlrtAlias(prhs[7]), "weightingKernel", weightingKernel);
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[8]), "initialOpticalFlow",
                     initialOpticalFlow);

  /* Invoke the target function */
  inverseCompostionalLK(&st, previousFrame, currentFrame, pointsToTrack,
                        windowRadiousY, windowRadiousX, maxIterations,
                        stopThreshold, weightingKernel, initialOpticalFlow,
                        opticalFlow);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(opticalFlow);
  opticalFlow->canFreeData = false;
  emxFree_real_T(&opticalFlow);
  initialOpticalFlow->canFreeData = false;
  emxFree_real_T(&initialOpticalFlow);
  weightingKernel->canFreeData = false;
  emxFree_real_T(&weightingKernel);
  pointsToTrack->canFreeData = false;
  emxFree_real_T(&pointsToTrack);
  currentFrame->canFreeData = false;
  emxFree_real_T(&currentFrame);
  previousFrame->canFreeData = false;
  emxFree_real_T(&previousFrame);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_inverseCompostionalLK_api.c) */
