function [pyramid, pyramidSize] = imagePyramid(image, depth)

    imageSize = size(image);
    pyramid = zeros(imageSize(1), imageSize(2), depth + 1);
    
    pyramid(:,:,1) = image;
    
    pyramidSize = zeros(depth + 1, 2);
    pyramidSize(1,:) = imageSize;
    
    for currentLevel = 2 : depth + 1
        
        baseImageSize = pyramidSize(currentLevel - 1, :);
        
        baseImage = zeros(baseImageSize(1) + 4, ...
            baseImageSize(2) + 4);
        
        baseImage(3 : baseImageSize(1) + 2, 3 : baseImageSize(2) + 2) = pyramid(1:baseImageSize(1),1:baseImageSize(2),currentLevel - 1);
        
        baseImage(1,:) = baseImage(3,:);
        baseImage(2,:) = baseImage(3,:);
        baseImage(:,1) = baseImage(:,3);
        baseImage(:,2) = baseImage(:,3);
        baseImage(end - 2,:) = baseImage(end - 3,:);
        baseImage(end - 1,:) = baseImage(end - 3,:);
        baseImage(:,end - 2) = baseImage(:, end - 3);
        baseImage(:,end - 1) = baseImage(:, end - 3);
        
        currentLevelImage = zeros(floor((baseImageSize(1) + 1) / 2), ...
            floor((baseImageSize(2) + 1) / 2));
       
        pyramidSize(currentLevel, :) = size(currentLevelImage);
        
        y = 1:pyramidSize(currentLevel,1);
        x = 1:pyramidSize(currentLevel,2);
       
        yB = 2 * y + 1;
        xB = 2 * x + 1;
        
        pyramid(y, x, currentLevel) = 0.140625 * baseImage(yB, xB) + ...
            0.125 * (baseImage(yB - 1, xB) + baseImage(yB + 1, xB) + ...
            baseImage(yB, xB - 1) + baseImage(yB, xB + 1)) + ...
            0.0625 * (baseImage(yB - 1, xB - 1) + baseImage(yB + 1, xB + 1) + ...
            baseImage(yB - 1, xB + 1) + baseImage(yB + 1, xB - 1)) + ... 
            0.00390625 * (baseImage(yB - 2, xB - 2) + baseImage(yB - 2, xB + 2) + ...
            baseImage(yB + 2, xB + 2) + baseImage(yB + 2, xB - 2)) + ...
            0.015625 * (baseImage(yB - 2, xB - 1) + baseImage(yB - 2, xB + 1) + ...
            baseImage(yB - 1, xB - 2) + baseImage(yB - 1, xB + 2) + ...
            baseImage(yB + 1, xB - 2) + baseImage(yB + 1, xB + 2) + ...
            baseImage(yB + 2, xB - 1) + baseImage(yB + 2, xB + 1)) + ...
            0.0234375 * (baseImage(yB - 2, xB) + baseImage(yB, xB - 2) + ...
            baseImage(yB + 2, xB) + baseImage(yB, xB + 2));
        
    end

end

