function [M00, M10, M01, M20, M02, M11] = imageMoments(image)

    image = double(image);
    [x, y] = meshgrid(1:size(image,2), 1:size(image,1));
    
    M00 = sum(sum(image));
    M10 = sum(sum(image.*x));
    M01 = sum(sum(image.*y));
    M20 = sum(sum(image.*x.^2));
    M02 = sum(sum(image.*y.^2));
    M11 = sum(sum(image.*x.*y));
    
end