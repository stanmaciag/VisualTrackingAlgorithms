#include "histogramEngine.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    // Input arguments
    double *image, *binsInput, *bins;
    mwSize imageDims, minRange, maxRange;
    mwSize imageDim[3];
    
    // Output argument
    double *binIdxArray;
    
    // Variables
    int i = 0, j = 0;
    
    // Check number of inputs:
    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "4 input arguments required.");
    }
    
    // Read input arguments:
    image = (double*)mxGetPr(prhs[0]);
    binsInput = (double*)mxGetPr(prhs[1]);
    minRange = (double)mxGetScalar(prhs[2]);
    maxRange = (double)mxGetScalar(prhs[3]);
    
    imageDims = mxGetNumberOfDimensions(prhs[0]);
    
    if (imageDims != 2 && imageDims != 3)
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "Invalid input image - must be represented as 2 or 3 dimensional array.");
    }
   
    imageDim[0] = mxGetDimensions(prhs[0])[0];
    imageDim[1] = mxGetDimensions(prhs[0])[1];
    
    if (imageDims == 2)
    {
        imageDim[2] = 1;
    }
    else
    {
        imageDim[2] = mxGetDimensions(prhs[0])[2];
    }
    
    bins = (double*)mxCalloc(imageDim[2],sizeof(double));
    const mwSize *binsDim = mxGetDimensions(prhs[1]);
    
    if (binsDim[0] == 1 && binsDim[1] == 1)
    {
        for (i = 0; i < imageDim[2]; ++i)
        {
            bins[i] = binsInput[0];
        }
    }
    else if ((binsDim[0] == 1 && binsDim[1] == imageDim[2]) || ((binsDim[0] == imageDim[2] && binsDim[1] == 1)))
    {
        for (i = 0; i < imageDim[2]; ++i)
        {
            bins[i] = binsInput[i];
        }
    }
    else
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "Invalid input bins sizes - must be a scalar or vector which length equals to number of image channels.");
    }
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateDoubleMatrix(imageDim[0], imageDim[1], mxREAL);
    binIdxArray = (double*)mxGetData(plhs[0]);
    
    computeBinArray(image, bins, imageDim, minRange, maxRange, binIdxArray);

    mxFree(bins);
    
    return;
    
    
}
