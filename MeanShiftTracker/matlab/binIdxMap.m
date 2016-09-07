function b = binIdxMap(image, bins, minRange, maxRange)

    binRange = (maxRange - minRange) ./ (bins - 1);

    b = zeros(size(image,1),size(image,2));
    
    multiplier = 1;
    
    for i = 1:size(image,3)
    
        b = b + floor(image(:,:,i) / binRange(i)) * multiplier;
        %b = b + floor(image(:,:,i) / binRange) * bins^(i - 1);
        
        multiplier = multiplier * bins(i);
        
    end

    b = b + 1;

    
end