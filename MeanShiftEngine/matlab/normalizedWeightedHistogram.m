function histogram = normalizedWeightedHistogram(image, kernel, binIdxArray, binsInput)

    if (~ismatrix(image) && ndims(image) ~= 3)
       
        error('MeanShift:IncorrectDim', 'Invalid input image - must be represented as 2 or 3 dimensional array.');
        
    end
    
    if (size(image,1) ~= size(kernel,1) || size(image,2) ~= size(kernel,2))
       
        error('MeanShift:IncorrectSize', 'Invalid input kernel - must be the same size as input image.');
        
    end
    
    if (size(image,1) ~= size(binIdxArray,1) || size(image,2) ~= size(binIdxArray,2))
       
        error('MeanShift:IncorrectSize', 'Invalid input bin index array - must be the same size as input image.');
        
    end

    if (isscalar(binsInput))
       
        bins = binsInput(ones(size(image,3),1));
        
    else
        
        if (size(image,3) ~= size(binsInput,1) && size(image,3) ~= size(binsInput,2))
           
            error('MeanShift:IncorrectSize', 'Invalid input bins sizes - must be a scalar or vector which length equals to number of image channels.');
            
        else
            
            bins = binsInput;
            
        end
        
    end
    
    histogram = zeros(prod(bins),1);
    
    normalizationConstant = 1 / sum(sum(kernel));
    
    for i = 1:size(binIdxArray,1)
        
        for j = 1:size(binIdxArray,2)

            histogram(binIdxArray(i,j)) = histogram(binIdxArray(i,j)) + ...
                    normalizationConstant * kernel(i,j);
                    
        end
        
    end

    
end

