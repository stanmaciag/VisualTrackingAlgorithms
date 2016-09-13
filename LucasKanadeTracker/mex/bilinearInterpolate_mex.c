#include <math.h>
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Input arguments
    double *image, *subpixelY, *subpixelX, *pixelY, *pixelX ,*remainderY, *remainderX;
    mwSize imageDims, subpixelYDims, subpixelXDims;
    mwSize imageDim[2];
    
    // Output argument
    double *imageInterpolation;
    
    // Variables
    int i = 0, j = 0;
    
    // Check number of inputs:
    if (nrhs != 3)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "3 input arguments required.");
    }
    
    // Read input arguments:
    image = (double*)mxGetPr(prhs[0]);
    subpixelY = (double*)mxGetPr(prhs[1]);
    subpixelX = (double*)mxGetPr(prhs[2]);
    
    imageDims = mxGetNumberOfDimensions(prhs[0]);
    
    if (imageDims != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Invalid input image - must be represented as 2 dimensional array.");
    }
   
    imageDim[0] = mxGetDimensions(prhs[0])[0];
    imageDim[1] = mxGetDimensions(prhs[0])[1];
    
    subpixelYDims = mxGetNumberOfDimensions(prhs[1]);
    subpixelXDims = mxGetNumberOfDimensions(prhs[2]);
    
    if (subpixelYDims != subpixelXDims)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Coordinates input arrays must have the same size.");
    }
    
    for (i = 0; i < subpixelYDims; ++i)
    {
        
        if (mxGetDimensions(prhs[1])[i] != mxGetDimensions(prhs[2])[i])
        {
            mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Coordinates input arrays must have the same size.");
        }
        
    }
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxDOUBLE_CLASS, mxREAL);
    imageInterpolation = (double*)mxGetData(plhs[0]);
    
    size_t elementNum = mxGetNumberOfElements(prhs[1]);
    
    double rY, rX, y, x;
    
    for (i = 0; i < elementNum; ++i)
    {
        
        y = floor(subpixelY[i]);
        x = floor(subpixelX[i]);
        rY = subpixelY[i] - y;
        rX = subpixelX[i] - x;
        
        imageInterpolation[i] = (1.0 - rY) * (1.0 - rX) * image[(unsigned)y - 1 + imageDim[0] * ((unsigned)x - 1)] \
        + rY * (1.0 - rX) * image[(unsigned)y + imageDim[0] * ((unsigned)x - 1)] \
        + (1.0 - rY) * rX * image[(unsigned)y - 1 + imageDim[0] * (unsigned)x] \
        + rY * rX * image[(unsigned)y + imageDim[0] * (unsigned)x];
        
    }
   
    
}