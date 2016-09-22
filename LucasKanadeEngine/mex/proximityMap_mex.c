#include <math.h>
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    // Input arguments
    bool *positionMap;
    int proximityRadious;
    mwSize mapDims;
    mwSize mapDim[2];
    
    // Output argument
    double *proximityMap;
    
    // Variables
    int i = 0, j = 0, l = 0, k = 0;
    
    // Check number of inputs:
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:proximityMap:BadNInput", "3 input arguments required.");
    }
    
    // Read input arguments:
    positionMap = (bool*)mxGetLogicals(prhs[0]);
    proximityRadious = (int)mxGetScalar(prhs[1]);
    
    /*mapDims = mxGetNumberOfDimensions(prhs[0]);
    
    if (mapDims != 2)
    {
        mexErrMsgIdAndTxt("LucasKanade:proximityMap:BadNInput", "Invalid input image - must be represented as 2 dimensional array.");
    }*/
   
    mapDim[0] = mxGetDimensions(prhs[0])[0];
    mapDim[1] = mxGetDimensions(prhs[0])[1];
    
    // Allocate output argument array and initialize all values with 0:
    plhs[0] = mxCreateDoubleMatrix(mapDim[0], mapDim[1], mxREAL);
    proximityMap = (double*)mxGetData(plhs[0]);
    
    for (i = 0; i < mapDim[0]; ++i)
    {
    
        for (j = 0; j < mapDim[1]; ++j)
        {
         
            if (positionMap[i + j * mapDim[0]])
            {
                
                for (k = -proximityRadious; k <= proximityRadious; ++k)
                {

                    for (l = -proximityRadious; l <= proximityRadious; ++l)
                    {
                        
                        if (k + i >= 0 && l + j >= 0 && k + i < mapDim[0] && l + j < mapDim[1])
                        {
                            
                            if (sqrt(k * k + l * l) <= (double)proximityRadious)
                            {
          
                                proximityMap[k + i + (l + j) * mapDim[0]] += 1.0;
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
      
    }
   
    
}