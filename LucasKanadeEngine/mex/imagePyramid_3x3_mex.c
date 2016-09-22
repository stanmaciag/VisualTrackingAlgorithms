#include <math.h>
#include <string.h>
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Input arguments
    double *image;
    mwSize depth, imageDims;
    mwSize imageDim[2], **levelSize;
    
    // Output argument
    double *pyramid;
    
    // Variables
    int i = 0, j = 0, k = 0;
    
    // Check number of inputs:
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:imagePyramid:BadNInput", "2 input arguments required.");
    }
    
    // Read input arguments:
    image = (double*)mxGetPr(prhs[0]);
    depth = (mwSize)mxGetScalar(prhs[1]);
    
    imageDims = mxGetNumberOfDimensions(prhs[0]);
    
    if (imageDims != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:bilinearInterpolate:BadNInput", "Invalid input image - must be represented as 2 dimensional array.");
    }
   
    imageDim[0] = mxGetDimensions(prhs[0])[0];
    imageDim[1] = mxGetDimensions(prhs[0])[1];
    
    // Compute levels sizes
    levelSize = (mwSize**)mxCalloc(depth + 1, sizeof(mwSize*));
    
    // Zero level size is equal to image size
    levelSize[0] = (mwSize*)mxCalloc(2, sizeof(mwSize));
    levelSize[0][0] = imageDim[0];
    levelSize[0][1] = imageDim[1];
    
    //mexPrintf("%d %d\n", levelSize[0][0], levelSize[0][1]);
    
    for (i = 1; i < depth + 1; ++i)
    {
        
        levelSize[i] = (mwSize*)mxCalloc(2, sizeof(mwSize));
        levelSize[i][0] = floor(levelSize[i - 1][0] + 1) / 2;
        levelSize[i][1] = floor(levelSize[i - 1][1] + 1) / 2;
        
        //mexPrintf("%d %d\n", levelSize[i][0], levelSize[i][1]);
        
    }
    
    // Output size array
    mwSize outputSize[3] = {levelSize[0][0], levelSize[0][1], depth + 1};
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateNumericArray(3, outputSize, mxDOUBLE_CLASS, mxREAL);
    pyramid = (double*)mxGetData(plhs[0]);
    
    //size_t elementNum = mxGetNumberOfElements(plhs[0]);
    
    // Copy input image to zero level
    /*for (i = 0; i < imageDim[1]; ++i)
    {
        
        memcpy(pyramid + i * imageDim[0], image + i * imageDim[0], (imageDim[0] * sizeof(double)));

    }*/
    
    memcpy(pyramid, image, (imageDim[0] * imageDim[1] * sizeof(double)));
    
    double iy0x0, iy0x1, iy1x0, iy1x1, iyn1x0, iy0xn1, iyn1xn1, iyn1x1, iy1xn1;
    unsigned yEnd, xEnd;
    
    // For all pyramid levels
    for (k = 1; k < depth + 1; ++k)
    {
        /*image[i + imageDim[0] * (j + imageDim[1] * k)]
                
        pyramid(y, x, currentLevel) = 0.25 * baseImage(2 * y + 1, 2 * x + 1) + ...
            0.125 * (baseImage(2 * y, 2 * x + 1) + baseImage(2 * y + 2, 2 * x + 1) + ...
            baseImage(2 * y + 1, 2 * x) + baseImage(2 * y + 1, 2 * x + 2)) + ...
            0.0625 * (baseImage(2 * y, 2 * x) + baseImage(2 * y + 2, 2 * x + 2) + ...
            baseImage(2 * y, 2 * x + 2) + baseImage(2 * y + 2, 2 * x)); */       
        
        yEnd = levelSize[k][0] - 1;
        xEnd = levelSize[k][1] - 1;
        
        //mexPrintf("%d %d\n", yEnd, xEnd);
        
        // Special case - point (0,0)
        iy0x0 = pyramid[levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        // Extrapolate with nearest image pixel
        iyn1x0 = pyramid[levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        iy1x0 = pyramid[1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        // Extrapolate with nearest image pixel
        iy0xn1 = pyramid[levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        iy0x1 = pyramid[levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1xn1 = pyramid[levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        iy1x1 = pyramid[1 + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1x1 = pyramid[levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1xn1 = pyramid[1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        
        pyramid[levelSize[k][0] * levelSize[k][1] * k] = 0.25 * iy0x0 + \
                0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
 
        // Special case - point (yEnd, 0)
        iy0x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        iyn1x0 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        // Extrapolate with nearest image pixel
        iy1x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        // Extrapolate with nearest image pixel
        iy0xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        iy0x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1xn1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        // Extrapolate with nearest image pixe
        iy1x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        iyn1x1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
        
        pyramid[yEnd + levelSize[k][0] * levelSize[k][1] * k] = 0.25 * iy0x0 + \
                0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
        
        
        // Special case - point (0,xEnd)     
        iy0x0 = pyramid[levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1x0 = pyramid[levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        iy1x0 = pyramid[1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        iy0xn1 = pyramid[levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy0x1 = pyramid[levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1xn1 = pyramid[levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1x1 = pyramid[1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iyn1x1 = pyramid[levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        iy1xn1 = pyramid[1 + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        
        pyramid[levelSize[k][0] * (xEnd + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
        
        
        // Special case - point (yEnd,xEnd)
        iy0x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))]; 
        iyn1x0 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        iy0xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy0x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        iyn1xn1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))]; 
        // Extrapolate with nearest image pixel
        iyn1x1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
        // Extrapolate with nearest image pixel
        iy1xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
        
        pyramid[yEnd + levelSize[k][0] * (xEnd + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
        
        // Special case - left edge without extreme points (yi, 0), where i != 0 and i != end
        for (i = 1; i < levelSize[k][0] - 1; ++i)
        {
            
            iy0x0 = pyramid[2 * i + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
            iyn1x0 = pyramid[2 * i - 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
            iy1x0 = pyramid[2 * i + 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
            // Extrapolate with nearest image pixel
            iy0xn1 = pyramid[2 * i + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
            iy0x1 = pyramid[2 * i + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iyn1xn1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];
            iy1x1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
            iyn1x1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy1xn1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * levelSize[k - 1][1] * (k - 1)];

            pyramid[i + levelSize[k][0] * levelSize[k][1] * k] = 0.25 * iy0x0 + \
                    0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                    0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
            
            
        }
        
        // Special case - upper edge without extreme points (0, xi), where i != 0 and i != end
        for (i = 1; i < levelSize[k][1] - 1; ++i)
        {
            
            iy0x0 = pyramid[levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iyn1x0 = pyramid[levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))];
            iy1x0 = pyramid[1 + levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))];
            iy0xn1 = pyramid[levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];
            iy0x1 = pyramid[levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iyn1xn1 = pyramid[levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];
            iy1x1 = pyramid[1 + levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iyn1x1 = pyramid[levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))];
            iy1xn1 = pyramid[1 + levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];

            pyramid[levelSize[k][0] * (i + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                    0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                    0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
            
            
        }
        
        // Special case - right edge without extreme points (yi, xEnd), where i != 0 and i != end
        for (i = 1; i < levelSize[k][0] - 1; ++i)
        {
            
            iy0x0 = pyramid[2 * i + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            iyn1x0 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            iy1x0 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            iy0xn1 = pyramid[2 * i + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy0x1 = pyramid[2 * i + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            iyn1xn1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy1x1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iyn1x1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * xEnd + levelSize[k - 1][1] * (k - 1))];
            iy1xn1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * xEnd - 1 + levelSize[k - 1][1] * (k - 1))];

            pyramid[i + levelSize[k][0] * (xEnd + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                    0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                    0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
            
            
        }
        
        // Special case - lower edge without extreme points (yEnd, xi), where i != 0 and i != end
        for (i = 1; i < levelSize[k][1] - 1; ++i)
        {
            
            iy0x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))]; 
            iyn1x0 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy1x0 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i + levelSize[k - 1][1] * (k - 1))];
            iy0xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];
            iy0x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))];
            iyn1xn1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy1x1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))]; 
            iyn1x1 = pyramid[2 * yEnd - 1 + levelSize[k - 1][0] * (2 * i + 1 + levelSize[k - 1][1] * (k - 1))];
            // Extrapolate with nearest image pixel
            iy1xn1 = pyramid[2 * yEnd + levelSize[k - 1][0] * (2 * i - 1 + levelSize[k - 1][1] * (k - 1))];

            pyramid[yEnd + levelSize[k][0] * (i + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                    0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                    0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
            
            
        }
        
        // Area wihtout edges
        for (i = 1; i < levelSize[k][0] - 1; ++i)
        {
            
            for (j = 1; j < levelSize[k][1] - 1; ++j)
            {
                
                iy0x0 = pyramid[2 * i + levelSize[k - 1][0] * (2 * j + levelSize[k - 1][1] * (k - 1))]; 
                iyn1x0 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * j + levelSize[k - 1][1] * (k - 1))];
                iy1x0 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * j + levelSize[k - 1][1] * (k - 1))];
                iy0xn1 = pyramid[2 * i + levelSize[k - 1][0] * (2 * j - 1 + levelSize[k - 1][1] * (k - 1))];
                iy0x1 = pyramid[2 * i + levelSize[k - 1][0] * (2 * j + 1 + levelSize[k - 1][1] * (k - 1))];
                iyn1xn1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * j - 1 + levelSize[k - 1][1] * (k - 1))];
                iy1x1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * j + 1 + levelSize[k - 1][1] * (k - 1))]; 
                iyn1x1 = pyramid[2 * i - 1 + levelSize[k - 1][0] * (2 * j + 1 + levelSize[k - 1][1] * (k - 1))];
                iy1xn1 = pyramid[2 * i + 1 + levelSize[k - 1][0] * (2 * j - 1 + levelSize[k - 1][1] * (k - 1))];

                pyramid[i + levelSize[k][0] * (j + levelSize[k][1] * k)] = 0.25 * iy0x0 + \
                        0.125 * (iyn1x0 + iy1x0 + iy0xn1 + iy0x1) + \
                        0.0625 * (iyn1xn1 + iy1x1 + iyn1x1 + iy1xn1);
                
            }
            
        }
        
    }
    
    
    for (i = 0; i < depth + 1; ++i)
    {
        
        mxFree(levelSize[i]);
        
    }
    
    mxFree(levelSize);
    
}