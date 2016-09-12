#include <math.h>
#include "mex.h"

void computeBinArray(const double *image, const double *bins, const mwSize *imageDim, const double minRange, const double maxRange, double *binIdxArray);

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

void computeBinArray(const double *image, const double *bins, const mwSize *imageDim, const double minRange, const double maxRange, double *binIdxArray)
{
    
    unsigned i, j, k;
  
    double *binRange, multiplier;
    binRange = (double*)mxCalloc(imageDim[2],sizeof(double));
    
    for (i = 0; i < imageDim[2]; ++i)
    {
        binRange[i] = ((double)maxRange - (double)minRange) / ((double)bins[i] - 1.0);
    }
    
    for (i = 0; i < imageDim[0]; ++i)
    {
        
        for (j = 0; j < imageDim[1]; ++j)
        {
            
            multiplier = 1.0;
            
            for (k = 0; k < imageDim[2]; ++k)
            {
                
                binIdxArray[i + j * imageDim[0]] += floor(image[i + imageDim[0] * (j + imageDim[1] * k)] / binRange[k]) * multiplier;
                multiplier *= bins[k];
                
            }
            
            // Increment index to achive consistency with Matlab indexing convention
            binIdxArray[i + j * imageDim[0]] += 1.0;
            
        }
        
    }

    mxFree(binRange);
    
}