#ifndef INTERPOLATIONENGINE_H
#define INTERPOLATIONENGINE_H

#include <math.h>
#include "mex.h"

// Type of input image
typedef float imageType;
// Classid for mxCreateNumericArray(), make sure that is defined as Matlab 
// equivalent for imageType
#define mxMATRIX_CLASS mxSINGLE_CLASS

inline imageType interpolatePoint(const imageType *image, const mwSize *imageDim, double subpixelY, double subpixelX)
{
    
    imageType interpolation;
    double rY, rX, y, x;
    
    y = floor(subpixelY);
    x = floor(subpixelX);
    rY = subpixelY - y;
    rX = subpixelX - x;
    
    interpolation = (imageType)((1.0 - rY) * (1.0 - rX)) * image[(unsigned)y + imageDim[0] * (unsigned)x] \
    + (imageType)(rY * (1.0 - rX)) * image[(unsigned)y + 1 + imageDim[0] * (unsigned)x] \
    + (imageType)((1.0 - rY) * rX) * image[(unsigned)y + imageDim[0] * ((unsigned)x + 1)] \
    + (imageType)(rY * rX) * image[(unsigned)y + 1 + imageDim[0] * ((unsigned)x + 1)];  
 
    return interpolation;
    
}

#endif /* INTERPOLATIONENGINE_H */