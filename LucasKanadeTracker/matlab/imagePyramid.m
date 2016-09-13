function pyramid = imagePyramid(image, depth)

    imageSize = size(image);
    pyramid = zeros(imageSize(1), imageSize(2), depth);
    
    pyramid(:,:,1) = image;
    
    for currentLevel = 2 : depth + 1
       
        
        
    end

end

