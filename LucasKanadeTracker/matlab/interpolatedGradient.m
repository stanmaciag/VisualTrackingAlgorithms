function [gradientX, gradientY] = interpolatedGradient(image, subpixelY, subpixelX)

    pixelY = floor(subpixelY);
    pixelX = floor(subpixelX);

    remainderY = subpixelY - pixelY;
    remainderX = subpixelX - pixelX;
    
    pixelIdxY0X0 = sub2ind(size(image), pixelY, pixelX);
    pixelIdxY1X0 = sub2ind(size(image), pixelY + 1, pixelX);
    pixelIdxY0X1 = sub2ind(size(image), pixelY, pixelX + 1);
    pixelIdxY1X1 = sub2ind(size(image), pixelY + 1, pixelX + 1);
    pixelIdxYn1X0 = sub2ind(size(image), pixelY - 1, pixelX);
    pixelIdxY0Xn1 = sub2ind(size(image), pixelY, pixelX - 1);
    pixelIdxY0X2 = sub2ind(size(image), pixelY, pixelX + 2);
    pixelIdxY1Xn1 = sub2ind(size(image), pixelY + 1, pixelX - 1);
    pixelIdxY1X2 = sub2ind(size(image), pixelY + 1, pixelX + 2);
    pixelIdxYn1X1 = sub2ind(size(image), pixelY - 1, pixelX + 1);
    pixelIdxY2X0 = sub2ind(size(image), pixelY + 2, pixelX);
    pixelIdxY2X1 = sub2ind(size(image), pixelY + 2, pixelX + 1);
    
    intIdx = find((remainderX == 0) & (remainderY == 0));
    nonIntIdx = find((remainderX ~= 0) | (remainderY ~= 0));
    
    gradientX = zeros(size(subpixelX));
    gradientY = zeros(size(subpixelX));
    
    gradientXY0X0 = (image(pixelIdxY0X1) - image(pixelIdxY0Xn1)) / 2;
    gradientYY0X0 = (image(pixelIdxY1X0) - image(pixelIdxYn1X0)) / 2;
    
    gradientX(intIdx) = gradientXY0X0(intIdx);
    gradientY(intIdx) = gradientYY0X0(intIdx);
    
    gradientXY0X1 = (image(pixelIdxY0X2(nonIntIdx)) - image(pixelIdxY0X0(nonIntIdx))) / 2;
    gradientXY1X0 = (image(pixelIdxY1X1(nonIntIdx)) - image(pixelIdxY1Xn1(nonIntIdx))) / 2;
    gradientXY1X1 = (image(pixelIdxY1X2(nonIntIdx)) - image(pixelIdxY1X0(nonIntIdx))) / 2;
    
    gradientYY0X1 = (image(pixelIdxY1X1(nonIntIdx)) - image(pixelIdxYn1X1(nonIntIdx))) / 2;
    gradientYY1X0 = (image(pixelIdxY2X0(nonIntIdx)) - image(pixelIdxY0X0(nonIntIdx))) / 2;
    gradientYY1X1 = (image(pixelIdxY2X1(nonIntIdx)) - image(pixelIdxY0X1(nonIntIdx))) / 2;

    gradientX(nonIntIdx) = (1 - remainderY(nonIntIdx)) .* (1 - remainderX(nonIntIdx)) .* gradientXY0X0(nonIntIdx) ...
        + remainderY(nonIntIdx) .* (1 - remainderX(nonIntIdx)) .* gradientXY1X0 ...
        + (1 - remainderY(nonIntIdx)) .* remainderX(nonIntIdx) .* gradientXY0X1 ...
        + remainderY(nonIntIdx) .* remainderX(nonIntIdx) .* gradientXY1X1;
    
    gradientY(nonIntIdx) = (1 - remainderY(nonIntIdx)) .* (1 - remainderX(nonIntIdx)) .* gradientYY0X0(nonIntIdx) ...
        + remainderY(nonIntIdx) .* (1 - remainderX(nonIntIdx)) .* gradientYY1X0 ...
        + (1 - remainderY(nonIntIdx)) .* remainderX(nonIntIdx) .* gradientYY0X1 ...
        + remainderY(nonIntIdx) .* remainderX(nonIntIdx) .* gradientYY1X1;
    
end

