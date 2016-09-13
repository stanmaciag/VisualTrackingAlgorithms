function imageInterpolation = bilinearInterpolate(image, subpixelY, subpixelX)

    pixelY = floor(subpixelY);
    pixelX = floor(subpixelX);

    remainderY = subpixelY - pixelY;
    remainderX = subpixelX - pixelX;
    
    pixelIdxY0X0 = sub2ind(size(image),pixelY,pixelX);
    pixelIdxY1X0 = sub2ind(size(image),pixelY + 1,pixelX);
    pixelIdxY0X1 = sub2ind(size(image),pixelY,pixelX + 1);
    pixelIdxY1X1 = sub2ind(size(image),pixelY + 1,pixelX + 1);
    
    imageInterpolation = (1 - remainderY) .* (1 - remainderX) .* image(pixelIdxY0X0) ...
        + remainderY .* (1 - remainderX) .* image(pixelIdxY1X0) ...
        + (1 - remainderY) .* remainderX .* image(pixelIdxY0X1) ...
        + remainderY .* remainderX .* image(pixelIdxY1X1);
            
end