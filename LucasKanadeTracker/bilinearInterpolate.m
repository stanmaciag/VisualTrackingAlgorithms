function imageInterpolation = bilinearInterpolate(image, subpixelsY, subpixelsX)

    pixelsY = floor(subpixelsY);
    pixelsX = floor(subpixelsX);

    remainderY = subpixelsY - pixelsY;
    remainderX = subpixelsX - pixelsX;
    
    imageInterpolation = (1 - remainderY) .* (1 - remainderX) .* image(pixelsY(1):pixelsY(end), pixelsX(1):pixelsX(end)) ...
        + remainderY .* (1 - remainderX) .* image(pixelsY(1) + 1:pixelsY(end) + 1, pixelsX(1):pixelsX(end)) ...
        + (1 - remainderY) .* remainderX .* image(pixelsY(1):pixelsY(end), pixelsX(1) + 1:pixelsX(end) + 1) ...
        + remainderY .* remainderX .* image(pixelsY(1) + 1:pixelsY(end) + 1, pixelsX(1) + 1:pixelsX(end) + 1);
            
end

