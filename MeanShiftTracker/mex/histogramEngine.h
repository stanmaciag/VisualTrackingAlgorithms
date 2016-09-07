#ifndef HISTOGRAMENGINE_H
#define HISTOGRAMENGINE_H

#include <math.h>
#include "mex.h"

void computeBinArray(const double *image, const double *bins, const mwSize *imageDim, const double minRange, const double maxRange, double *binIdxArray);
void computeNormalizedWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *normalizedWeightedHistogram);
void computeWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *weightedHistogram);

#endif /* HISTOGRAMENGINE_H */