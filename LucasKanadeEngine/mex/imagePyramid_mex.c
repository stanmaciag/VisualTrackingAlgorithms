#include <math.h>
#include <string.h>
#include "mex.h"

#define pyramid(x, y, z) pyramid[(x) + ((currentSizeY) * ((y) + ((currentSizeX) * (z))))]

// Type of input image
typedef float imageType;
// Classid for mxCreateNumericArray(), make sure that is defined as Matlab 
// equivalent for imageType
#define mxMATRIX_CLASS mxSINGLE_CLASS

// Kernel elements weights
const float h1 = 0.140625;
const float h2 = 0.125;
const float h3 = 0.0625;
const float h4 = 0.0234375;
const float h5 = 0.015625;
const float h6 = 0.00390625;

// Global current base level pyramid size
mwIndex currentSizeY = 0, currentSizeX = 0;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Input arguments
    imageType *image;
    mwSize depth;
    
    // Output argument
    imageType *pyramid;
    unsigned *levelSize;
    
    // Variables
    int i = 0, j = 0, k = 0;
    mwSize imageDims, imageDim[2];
    
    // Check number of inputs:
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:imagePyramid:BadNInput", "2 input arguments required.");
    }
    
    // Read input arguments:
    image = (imageType*)mxGetPr(prhs[0]);
    depth = (mwSize)mxGetScalar(prhs[1]);
    
    // Get number of image dimensions
    imageDims = mxGetNumberOfDimensions(prhs[0]);
    
    // Validate image
    if (imageDims != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Invalid input image - must be represented as 2 dimensional array.");
    }
   
    // Get image dimensions
    imageDim[0] = mxGetDimensions(prhs[0])[0];
    imageDim[1] = mxGetDimensions(prhs[0])[1];
    
    
    // Output size matrix dimensions
    mwSize outputSizeDim[2] = {depth + 1, 2};
    
    // Allocate output size matrix
    plhs[1] = mxCreateNumericArray(2, outputSizeDim, mxUINT32_CLASS, mxREAL);
    levelSize = (unsigned*)mxGetData(plhs[1]);
    
    // Zero level size is equal to image size
    levelSize[0] = imageDim[0];
    levelSize[depth + 1] = imageDim[1];
    
    // Calculate level's sizes
    for (i = 1; i < depth + 1; ++i)
    {
        
        //levelSize[i] = (mwSize*)mxCalloc(2, sizeof(mwSize));
        levelSize[i] = floor(levelSize[i - 1] + 1) / 2;
        levelSize[i + depth + 1] = floor(levelSize[i - 1 + depth + 1] + 1) / 2;
        
    }
    
    // Output pyramid dimensions
    mwSize outputPyramidDim[3] = {levelSize[0], levelSize[depth + 1], depth + 1};
    
    // Allocate output pyramid array and initialize all values with 0:
    plhs[0] = mxCreateNumericArray(3, outputPyramidDim, mxMATRIX_CLASS, mxREAL);
    pyramid = (imageType*)mxGetData(plhs[0]);
    
    // Copy input image to 0th level
    memcpy(pyramid, image, imageDim[0] * imageDim[1] * sizeof(imageType));
    
    mwIndex yn2, yn1, y0, y1, y2, xn2, xn1, x0, x1, x2, yEnd, xEnd;

    // Set global base level pyramid size (for MACRO) 
    currentSizeY = levelSize[0];
    currentSizeX = levelSize[depth + 1];
    
    // For all pyramid levels
    for (k = 1; k < depth + 1; ++k)
    {

        // Compute end indices
        yEnd = levelSize[k] - 1;
        xEnd = levelSize[k + depth + 1] - 1;

        // For every row
        for (i = 0; i < levelSize[k]; ++i)
        {

            // Special case point (0,j)
            if (i == 0)
            {
                
                yn2 = 0;
                yn1 = 0;
                        
            }
            // Special case point (1,j)
            else if (i == 1)
            {
                
                yn2 = 0;
                yn1 = 1;
                
            }
            // Ordinary case
            else
            {
                
                yn2 = 2 * i - 2;
                yn1 = 2 * i - 1;
                
            }
            
            // Special case point (yEnd,j)
            if (i == yEnd)
            {
                
                y1 = 2 * yEnd;
                y2 = 2 * yEnd;
                
            }
            // Special case point (yEnd - 1,j)
            else if (i == yEnd - 1)
            {
                
                y1 = 2 * yEnd - 1;
                y2 = 2 * yEnd;
                
            }
            // Ordinary case
            else
            {
                
                y1 = 2 * i + 1;
                y2 = 2 * i + 2;
                
            }
            
            y0 = 2 * i;
            
            // For every column
            for (j = 0; j < levelSize[k + depth + 1]; ++j)
            {

                // Special case point (i,0)
                if (j == 0)
                {

                    xn2 = 0;
                    xn1 = 0;

                }
                // Special case point (i,1)
                else if (j == 1)
                {
                    
                    xn2 = 0;
                    xn1 = 1;
                    
                }
                // Ordinary case
                else
                {

                    xn2 = 2 * j - 2;
                    xn1 = 2 * j - 1;

                }

                // Special case point (i, xEnd)
                if (j == xEnd)
                {

                    x1 = 2 * xEnd;
                    x2 = 2 * xEnd;

                }
                // Special case point (i, xEnd - 1)
                else if (j == xEnd - 1)
                {
                    
                    x1 = 2 * xEnd - 1;
                    x2 = 2 * xEnd;
                    
                }
                // Ordinary case
                else
                {

                    x1 = 2 * j + 1;
                    x2 = 2 * j + 2;

                }
                
                x0 = 2 * j;
                
                // Compute current level value at point (i,j)
                // Mind notation pyramid(i,j,k) - check MACRO at the beginning of this file
                pyramid(i, j, k) = (imageType)(h1 * pyramid(y0, x0, k - 1) + h2 * (pyramid(yn1, x0, k - 1) + pyramid(y0, xn1, k - 1) + \
                        pyramid(y1, x0, k - 1) + pyramid(y0, x1, k - 1)) + h3 * (pyramid(yn1, xn1, k - 1) + \
                        pyramid(y1, xn1, k - 1) + pyramid(y1, x1, k - 1) + pyramid(yn1, x1, k - 1)) + \
                        h4 * (pyramid(yn2, x0, k - 1) + pyramid(y0, xn2, k - 1) + pyramid(y2, x0, k - 1) + \
                        pyramid(y0, x2, k - 1)) + h5 * (pyramid(yn2, xn1, k - 1) + pyramid(yn2, x1, k - 1) + \
                        pyramid(yn1, xn2, k - 1) + pyramid(yn1, x2, k - 1) + pyramid(y1, xn2, k - 1) + \
                        pyramid(y1, x2, k - 1) + pyramid(y2, xn1, k - 1) + pyramid(y2, x1, k - 1)) + \
                        h6 * (pyramid(yn2, xn2, k - 1) + pyramid(yn2, x2, k - 1) + pyramid(y2, x2, k - 1) + \
                        pyramid(y2, xn2, k - 1)));

            }

        }
    
    }
    
}