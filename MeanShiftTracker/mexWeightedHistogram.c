#include "histogramEngine.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    // Input arguments
    double *image, *kernel, *binsInput, *bins;
    mwSize imageDims, kernelDims, minRange, maxRange;
    mwSize imageDim[3];
    
    // Output arguments
    double *weightedHistogram;
    //uint32_T *binIdxArray;  
    double *binIdxArray;
    
    // Variables
    //double normalizationConstant = 0, normalizationConstantAcc = 0;
    
    int i = 0, j = 0;
    
    // Check number of inputs:
    if (nrhs != 5)
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "5 input arguments required.");
    }
    
    // Read input arguments:
    image = (double*)mxGetPr(prhs[0]);
    kernel = (double*)mxGetPr(prhs[1]);
    //bins = (mwSize)mxGetScalar(prhs[2]);
    binsInput = (double*)mxGetPr(prhs[2]);
    //minRange = (mwSize)mxGetScalar(prhs[3]);
    //maxRange = (mwSize)mxGetScalar(prhs[4]);
    minRange = (double)mxGetScalar(prhs[3]);
    maxRange = (double)mxGetScalar(prhs[4]);
    
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
    
    kernelDims = mxGetNumberOfDimensions(prhs[1]);
    
    if (kernelDims != 2)
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "Invalid input kernel - must be 2 dimensional array.");
    }
    
    const mwSize *kernelDim = mxGetDimensions(prhs[1]);
    
    if (kernelDim[0] != imageDim[0] || kernelDim[1] != imageDim[1])
    {
        mexErrMsgIdAndTxt("MeanShift:Func:BadNInput", "Invalid input kernel - must be the same size as input image.");
    }
    
    bins = (double*)mxCalloc(imageDim[2],sizeof(double));
    const mwSize *binsDim = mxGetDimensions(prhs[2]);
    
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
    
    // Compute histogram size 
    unsigned outputSize = (unsigned)bins[0];
    
    for (i = 1; i < imageDim[2]; ++i)
    {       
        
        outputSize *= (unsigned)bins[i];
        
    }
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateDoubleMatrix(outputSize, 1, mxREAL);
    weightedHistogram = mxGetPr(plhs[0]);
    
    plhs[1] = mxCreateDoubleMatrix(imageDim[0], imageDim[1], mxREAL);
    binIdxArray = (double*)mxGetData(plhs[1]);

    
    computeBinArray(image, bins, imageDim, minRange, maxRange, binIdxArray);
    
    computeWeightedHistogram(binIdxArray, kernel, imageDim, weightedHistogram);

    mxFree(bins);
    
    return;
    
}
