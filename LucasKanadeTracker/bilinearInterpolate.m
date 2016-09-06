function imageInterpolation = bilinearInterpolate(image, subpixelsY, subpixelsX)

    pixelsY = floor(subpixelsY);
    pixelsX = floor(subpixelsX);

    remainderY = subpixelsY - pixelsY;
    remainderX = subpixelsX - pixelsX;
    
    %if sum(sum(remainderX)) == 0 && sum(sum(remainderY)) == 0
        
    %    imageInterpolation = image(subpixelsY, subpixelsX);
        
    %end
        
    
    imageInterpolation = (1 - remainderY) .* (1 - remainderX) .* image(pixelsY(1):pixelsY(end), pixelsX(1):pixelsX(end)) ...
        + remainderY .* (1 - remainderX) .* image(pixelsY(1) + 1:pixelsY(end) + 1, pixelsX(1):pixelsX(end)) ...
        + (1 - remainderY) .* remainderX .* image(pixelsY(1):pixelsY(end), pixelsX(1) + 1:pixelsX(end) + 1) ...
        + remainderY .* remainderX .* image(pixelsY(1) + 1:pixelsY(end) + 1, pixelsX(1) + 1:pixelsX(end) + 1);
    
    %imageInterpolation = zeros(size(subpixelsY));
    
    
    %for i = 1:size(subpixelsY,2) 
        
    %    for j = 1:size(subpixelsY,1)
            
    %        imageInterpolation(j,i) = (1 - remainderY(j, i)) * (1 - remainderX(j, i)) * image(pixelsY(j, i), pixelsX(j, i)) ...
    %            + remainderY(j, i) * (1 - remainderX(j, i)) * image(pixelsY(j, i) + 1, pixelsX(j, i)) ...
    %            + (1 - remainderY(j, i)) * remainderX(j, i) * image(pixelsY(j, i), pixelsX(j, i) + 1) ...
    %            + remainderY(j, i) * remainderX(j, i) * image(pixelsY(j, i) + 1, pixelsX(j, i) + 1);
             
    %    end
        
    %end
            
end

