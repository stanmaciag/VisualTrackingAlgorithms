function weightsMap = pixelWeights(targetHistogram, candidateHistogram, kernel, binIdxMap)

    if (size(targetHistogram) ~= size(candidateHistogram))
    
        error('MeanShift:IncorrectSize', 'Invalid input - inconsistent histgrams size.');
        
    end
    
    if (size(kernel) ~= size(binIdxMap))
    
        error('MeanShift:IncorrectSize', 'Invalid input - inconsistent size of bin index map and kernel.');
        
    end
    
    weightsMap = zeros(size(binIdxMap));
    
    for i = 1:size(binIdxMap,1)
        
        for j = 1:size(binIdxMap,2)
     
            if (kernel(i,j) > 0)
            
               weightsMap(i,j) = sqrt(targetHistogram(binIdxMap(i,j)) / candidateHistogram(binIdxMap(i,j)));
            
            end
        
        end
        
    end

end

