#ifndef HISTOGRAMENGINE_H
#define HISTOGRAMENGINE_H

#include <math.h>
#include "mex.h"

void computeWeightedHistogram(const double *binIdxArray, const double *kernel, const mwSize binIdxArrayDims[2], double *weightedHistogram);

#endif /* HISTOGRAMENGINE_H */