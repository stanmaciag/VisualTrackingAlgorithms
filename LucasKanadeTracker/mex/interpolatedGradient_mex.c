#include "interpolationEngine.h"

#define MINDIFF 10e-7

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Input arguments
    double *image, *subpixelY, *subpixelX;
    mwSize imageDims, subpixelYDims, subpixelXDims;
    mwSize imageDim[2];
    
    // Output argument
    double *gradientX, *gradientY;
    
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
    gradientX = (double*)mxGetData(plhs[0]);
    plhs[1] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxDOUBLE_CLASS, mxREAL);
    gradientY = (double*)mxGetData(plhs[1]);
    
    size_t elementNum = mxGetNumberOfElements(prhs[1]);
    
    
    for (i = 0; i < elementNum; ++i)
    {
        
        double rY, rX, y, x, interpolation, gradientX_X0Y0, gradientY_X0Y0;
    
        y = floor(subpixelY[i]);
        x = floor(subpixelX[i]);
        rY = subpixelY[i] - y;
        rX = subpixelX[i] - x;
        
        gradientX_X0Y0 = (image[(unsigned)y - 1 + imageDim[0] * (unsigned)x] \
                - image[(unsigned)y - 1 + imageDim[0] * ((unsigned)x - 2)]) / 2.0;
        
        gradientY_X0Y0 = (image[(unsigned)y + imageDim[0] * ((unsigned)x - 1)] \
                - image[(unsigned)y - 2 + imageDim[0] * ((unsigned)x - 1)]) / 2.0;
        
        if (rX < MINDIFF && rY< MINDIFF)
        {
            
            gradientX[i] = gradientX_X0Y0;
            gradientY[i] = gradientY_X0Y0;
            
        }
        else
        {
            
            double gradientX_X1Y0, gradientX_X0Y1, gradientX_X1Y1;
            double gradientY_X1Y0, gradientY_X0Y1, gradientY_X1Y1;
            
            gradientX_X1Y0 = (image[(unsigned)y - 1 + imageDim[0] * ((unsigned)x + 1)] \
                    - image[(unsigned)y - 1 + imageDim[0] * ((unsigned)x - 1)]) / 2.0;
            
            gradientX_X0Y1 = (image[(unsigned)y + imageDim[0] * (unsigned)x] \
                - image[(unsigned)y + imageDim[0] * ((unsigned)x - 2)]) / 2.0;
            
            gradientX_X1Y1 = (image[(unsigned)y + imageDim[0] * ((unsigned)x + 1)] \
                - image[(unsigned)y + imageDim[0] * ((unsigned)x - 1)]) / 2.0;
            
            double gradientXWindow[4] = {gradientX_X0Y0, gradientX_X0Y1, gradientX_X1Y0, gradientX_X1Y1};
            mwSize gradientXWindowDim[2] = {2,2};
            
            gradientX[i] = interpolatePoint(gradientXWindow, gradientXWindowDim, rY, rX);
            
            gradientY_X1Y0 = (image[(unsigned)y + imageDim[0] * (unsigned)x] \
                - image[(unsigned)y - 2 + imageDim[0] * (unsigned)x]) / 2.0;
            
            gradientY_X0Y1 = (image[(unsigned)y + 1 + imageDim[0] * ((unsigned)x - 1)] \
                - image[(unsigned)y - 1 + imageDim[0] * ((unsigned)x - 1)]) / 2.0;
           
            gradientY_X1Y1 = (image[(unsigned)y + 1 + imageDim[0] * (unsigned)x] \
                - image[(unsigned)y - 1 + imageDim[0] * (unsigned)x]) / 2.0;
            
            double gradientYWindow[4] = {gradientY_X0Y0, gradientY_X0Y1, gradientY_X1Y0, gradientY_X1Y1};
            mwSize gradientYWindowDim[2] = {2,2};
            
            gradientY[i] = interpolatePoint(gradientYWindow, gradientYWindowDim, rY, rX);
            
        }
        
        
    }
   
    
}