#ifndef HISTOGRAMENGINE_H
#define HISTOGRAMENGINE_H

#include <math.h>
#include "mex.h"

inline void computeWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *weightedHistogram)
{
    
    int i, j;
    
    // Compute weighted histogram
    for (i = 0; i < binIdxArrayDims[0]; ++i)
    {
        
        for (j = 0; j < binIdxArrayDims[1]; ++j)
        {

            // Mind decreasing bin index given by binsIdxArray by 1, due
            // to different indexing in Matlab and C++
            weightedHistogram[(unsigned)binIdxArray[i + j * binIdxArrayDims[0]] - 1] += 
                    kernel[i + j * binIdxArrayDims[0]];
            
        }
        
    }
    
}

#endif /* HISTOGRAMENGINE_H */
