#ifndef INTERPOLATIONENGINE_H
#define INTERPOLATIONENGINE_H

#include <math.h>
#include "mex.h"

inline double interpolatePoint(const double *image, const mwSize *imageDim, double subpixelY, double subpixelX)
{
    
    double rY, rX, y, x, interpolation;
    
    y = floor(subpixelY);
    x = floor(subpixelX);
    rY = subpixelY - y;
    rX = subpixelX - x;
    
    interpolation = (1.0 - rY) * (1.0 - rX) * image[(unsigned)y + imageDim[0] * (unsigned)x] \
    + rY * (1.0 - rX) * image[(unsigned)y + 1 + imageDim[0] * (unsigned)x] \
    + (1.0 - rY) * rX * image[(unsigned)y + imageDim[0] * ((unsigned)x + 1)] \
    + rY * rX * image[(unsigned)y + 1 + imageDim[0] * ((unsigned)x + 1)];  
 
    return interpolation;
    
}

#endif /* INTERPOLATIONENGINE_H */