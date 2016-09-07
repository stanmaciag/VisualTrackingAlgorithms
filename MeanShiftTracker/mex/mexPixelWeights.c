#include <math.h>
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    // Input arguments
    double *targetHistogram, *candidateHistogram, *kernel, *binIdxMap;
    
    // Output argument
    double *weightsMap;
    
    // Check number of inputs:
    if (nrhs != 4)
    {
        mexErrMsgIdAndTxt("MeanShift:BadNInput", "4 input arguments required.");
    }
    
    // Read input arguments:
    targetHistogram = (double*)mxGetPr(prhs[0]);
    candidateHistogram = (double*)mxGetPr(prhs[1]);
    kernel = (double*)mxGetPr(prhs[2]);
    //binIdxMap = (uint32_T*)mxGetPr(prhs[3]);
    binIdxMap = mxGetPr(prhs[3]);
    
    mwSize targetHistogramDim = mxGetDimensions(prhs[0])[0], candidateHistogramDim = mxGetDimensions(prhs[1])[0];
    
    if (targetHistogramDim != candidateHistogramDim)
    {
        mexErrMsgIdAndTxt("MeanShift:IncorrectSize", "Invalid input - inconsistent histgrams size.");
    }
    
    mwSize kernelDims = mxGetNumberOfDimensions(prhs[2]);
    
    if (kernelDims != 2)
    {
        mexErrMsgIdAndTxt("MeanShift:IncorrectDim", "Invalid input kernel - must be a matrix.");
    }
    
    const mwSize *kernelDim = mxGetDimensions(prhs[2]);
    
    mwSize binIdxMapDims = mxGetNumberOfDimensions(prhs[3]);
    
    if (binIdxMapDims != 2)
    {
        mexErrMsgIdAndTxt("MeanShift:IncorrectDim", "Invalid input bin index map - must be a matrix.");
    }
    
    const mwSize *binIdxMapDim = mxGetDimensions(prhs[3]);
    
    if (kernelDim[0] != binIdxMapDim[0] || kernelDim[1] != binIdxMapDim[1])
    {
        mexErrMsgIdAndTxt("MeanShift:IncorrectSize", "Invalid input - inconsistent size of bin index map and kernel.");
    }   
        
    plhs[0] = mxCreateDoubleMatrix(binIdxMapDim[0], binIdxMapDim[1], mxREAL);
    weightsMap = (double*)mxGetPr(plhs[0]);
    
    unsigned i, j;
    
    for (i = 0; i < binIdxMapDim[0]; ++i)
    {
        
        for (j = 0; j < binIdxMapDim[1]; ++j)
        {
            
            if (kernel[i + j * binIdxMapDim[0]] > 0)
            {
                
                weightsMap[i + j * binIdxMapDim[0]] = sqrt(targetHistogram[(unsigned)binIdxMap[i + j * binIdxMapDim[0]] - 1] / candidateHistogram[(unsigned)binIdxMap[i + j * binIdxMapDim[0]] - 1]);
            
            }

        }
        
    }
    
    return;
    
}