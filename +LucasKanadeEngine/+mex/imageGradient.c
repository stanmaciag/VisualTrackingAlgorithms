#include <math.h>
#include "mex.h"

// Type of input image
typedef float imageType;
// Classid for mxCreateNumericArray(), make sure that is defined as Matlab 
// equivalent for imageType
#define mxMATRIX_CLASS mxSINGLE_CLASS

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Input arguments
    imageType *image;
    double *pixelY, *pixelX;
    mwSize imageDims, subpixelYDims, subpixelXDims;
    mwSize imageDim[2];
    
    // Output argument
    imageType *gradientX, *gradientY;
    
    // Variables
    int i = 0, j = 0;
    
    // Check number of inputs:
    if (nrhs != 3)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "3 input arguments required.");
    }
    
    // Read input arguments:
    image = (imageType*)mxGetPr(prhs[0]);
    pixelY = (double*)mxGetPr(prhs[1]);
    pixelX = (double*)mxGetPr(prhs[2]);
    
    /*imageDims = mxGetNumberOfDimensions(prhs[0]);
    
    if (imageDims != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Invalid input image - must be represented as 2 dimensional array.");
    }*/
   
    imageDim[0] = mxGetDimensions(prhs[0])[0];
    imageDim[1] = mxGetDimensions(prhs[0])[1];
    
    /*subpixelYDims = mxGetNumberOfDimensions(prhs[1]);
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
        
    }*/
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxMATRIX_CLASS, mxREAL);
    gradientX = (imageType*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxMATRIX_CLASS, mxREAL);
    gradientY = (imageType*)mxGetData(plhs[1]);
    
    size_t elementNum = mxGetNumberOfElements(prhs[1]);
    
    
    for (i = 0; i < elementNum; ++i)
    {
    
        gradientX[i] = (image[(int)pixelY[i] - 1 + imageDim[0] * (unsigned)pixelX[i]] \
                - image[(unsigned)pixelY[i] - 1 + imageDim[0] * ((unsigned)pixelX[i] - 2)]) / 2.0;
        
        gradientY[i] = (image[(unsigned)pixelY[i] + imageDim[0] * ((unsigned)pixelX[i] - 1)] \
                - image[(unsigned)pixelY[i] - 2 + imageDim[0] * ((unsigned)pixelX[i] - 1)]) / 2.0;
        
      
    }
   
    
}