function pyramid = imagePyramid(image, depth)

    imageSize = size(image);
    pyramid = zeros(imageSize(1), imageSize(2), depth + 1);
    
    pyramid(:,:,1) = image;
    
    pyramidSize = zeros(depth + 1, 2);
    pyramidSize(1,:) = imageSize;
    
    for currentLevel = 2 : depth + 1
        
        baseImageSize = pyramidSize(currentLevel - 1, :);
        
        baseImage = zeros(baseImageSize(1) + 2, ...
            baseImageSize(2) + 2);
        
        baseImage(2 : baseImageSize(1) + 1, 2 : baseImageSize(2) + 1) = pyramid(1:baseImageSize(1),1:baseImageSize(2),currentLevel - 1);
        
        baseImage(1,:) = baseImage(2,:);
        baseImage(:,1) = baseImage(:,2);
        baseImage(end - 1,:) = baseImage(end - 2,:);
        baseImage(:,end - 1) = baseImage(:, end - 2);
        
        currentLevelImage = zeros(floor((baseImageSize(1) + 1) / 2), ...
            floor((baseImageSize(2) + 1) / 2));
       
        pyramidSize(currentLevel, :) = size(currentLevelImage);
        
        y = 1:pyramidSize(currentLevel,1);
        x = 1:pyramidSize(currentLevel,2);
      
        pyramid(y, x, currentLevel) = 0.25 * baseImage(2 * y, 2 * x) + ...
            0.125 * (baseImage(2 * y - 1, 2 * x) + baseImage(2 * y + 1, 2 * x) + ...
            baseImage(2 * y, 2 * x - 1) + baseImage(2 * y, 2 * x + 1)) + ...
            0.0625 * (baseImage(2 * y - 1, 2 * x - 1) + baseImage(2 * y + 1, 2 * x + 1) + ...
            baseImage(2 * y - 1, 2 * x + 1) + baseImage(2 * y + 1, 2 * x - 1));
        
    end

end

