/*
 * Student License - for use by students to meet course requirements and
 * perform academic research at degree granting institutions only.  Not
 * for government, commercial, or other organizational use.
 *
 * _coder_inverseCompostionalLK_mex.c
 *
 * Code generation for function '_coder_inverseCompostionalLK_mex'
 *
 */

/* Include files */
#include "inverseCompostionalLK.h"
#include "_coder_inverseCompostionalLK_mex.h"
#include "inverseCompostionalLK_terminate.h"
#include "_coder_inverseCompostionalLK_api.h"
#include "inverseCompostionalLK_initialize.h"
#include "inverseCompostionalLK_data.h"

/* Function Declarations */
static void c_inverseCompostionalLK_mexFunc(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[9]);

/* Function Definitions */
static void c_inverseCompostionalLK_mexFunc(int32_T nlhs, mxArray *plhs[1],
  int32_T nrhs, const mxArray *prhs[9])
{
  int32_T n;
  const mxArray *inputs[9];
  const mxArray *outputs[1];
  int32_T b_nlhs;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 9) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 9, 4,
                        21, "inverseCompostionalLK");
  }

  if (nlhs > 1) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 21,
                        "inverseCompostionalLK");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  inverseCompostionalLK_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  inverseCompostionalLK_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(inverseCompostionalLK_atexit);

  /* Initialize the memory manager. */
  /* Module initialization. */
  inverseCompostionalLK_initialize();

  /* Dispatch the entry-point. */
  c_inverseCompostionalLK_mexFunc(nlhs, plhs, nrhs, prhs);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_inverseCompostionalLK_mex.c) */
