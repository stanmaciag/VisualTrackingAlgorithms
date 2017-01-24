function [gradientX, gradientY] = imageGradient(image, pixelY, pixelX)

    
    pixelIdxY1X0 = sub2ind(size(image), pixelY + 1, pixelX);
    pixelIdxY0X1 = sub2ind(size(image), pixelY, pixelX + 1); 
    pixelIdxYn1X0 = sub2ind(size(image), pixelY - 1, pixelX);
    pixelIdxY0Xn1 = sub2ind(size(image), pixelY, pixelX - 1);
 
    gradientX = (image(pixelIdxY0X1) - image(pixelIdxY0Xn1)) / 2;
    gradientY = (image(pixelIdxY1X0) - image(pixelIdxYn1X0)) / 2;
    

end

