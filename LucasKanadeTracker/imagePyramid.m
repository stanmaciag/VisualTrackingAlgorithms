function pyramid = imagePyramid(image, depth)
%IMAGEPYRAMID Summary of this function goes here
%   Detailed explanation goes here
    
    pyramid{1} = image;
    
    L = 1;
    
    while L < depth + 1
    
        L = L + 1;
        pyramid{end + 1} = impyramid(pyramid{L - 1}, 'reduce');
        
    end
    
end

