#include "histogramEngine.h"

void computeBinArray(const double *image, const double *bins, const mwSize *imageDim, const double minRange, const double maxRange, double *binIdxArray)
{
    
    unsigned i;
  
    double *binRange, multiplier;
    binRange = (double*)mxCalloc(imageDim[2],sizeof(double));
    
    for (i = 0; i < imageDim[2]; ++i)
    {
        binRange[i] = (maxRange - minRange) / ((double)bins[i] - 1.0);
    }
    
    #pragma omp parallel for
    for (i = 0; i < imageDim[0]; ++i)
    {
        unsigned j, k;
       
        for (j = 0; j < imageDim[1]; ++j)
        {
            
            multiplier = 1;
            
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

void computeNormalizedWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *normalizedWeightedHistogram)
{
    
    int i, j;
    double normalizationConstant = 0, normalizationConstantAcc = 0;
    
    // Accumulate normalization constant
    for (i = 0; i < binIdxArrayDims[0]; ++i)
                
    {
        
        for (j = 0; j < binIdxArrayDims[1]; ++j)
        {
                
            normalizationConstantAcc += kernel[i + j * binIdxArrayDims[0]];
            
        }
        
    }
    
    // Compute normalization constant 
    normalizationConstant = 1 / normalizationConstantAcc;
    
    // Compute weighted histogram
    for (i = 0; i < binIdxArrayDims[0]; ++i)
    {
        
        for (j = 0; j < binIdxArrayDims[1]; ++j)
        {

            // Mind decreasing bin index given by binsIdxArray by 1, due
            // to different indexing in Matlab and C++
            normalizedWeightedHistogram[(unsigned)binIdxArray[i + j * binIdxArrayDims[0]] - 1] += 
                    normalizationConstant * kernel[i + j * binIdxArrayDims[0]];
            
        }
        
    }
    
}

void computeWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *weightedHistogram)
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