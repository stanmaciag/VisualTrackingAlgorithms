function opticalFlow = pyramidalLucasKanade(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, pyramidDepth, engileFcnHandle, weightingKernelFcnHandle)
    %PYRAMIDALLUCASKANADE Summary of this function goes here
    %   Detailed explanation goes here
    % References
    % ----------
    % 1. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
    % tracker - Description of the algorithm Intel Corporation - Microprocessor
    % Research Labs, 2000
   
    % Initialize image pyramids for current and previous frame
    previousPyramid = zeros(size(previousFrame, 1), size(previousFrame, 2), pyramidDepth + 1);
    currentPyramid = zeros(size(currentFrame, 1),  size(currentFrame, 2), pyramidDepth + 1);
    previousPyramid(:,:,1) = previousFrame;
    currentPyramid(:,:,1) = currentFrame;
    
    % Compute image pyramids
    L = 1;
    
    while L < pyramidDepth + 1
    
        previousSize = size(previousFrame) / (2 ^ (L - 1));
        L = L + 1;
        currentSize = size(previousFrame) / (2 ^ (L - 1));
        previousPyramid(1:currentSize(1),1:currentSize(2),L) = impyramid(previousPyramid(1:previousSize(1), 1:previousSize(2), L - 1), 'reduce');
        currentPyramid(1:currentSize(1),1:currentSize(2),L) = impyramid(currentPyramid(1:previousSize(1), 1:previousSize(2), L - 1), 'reduce');
        
    end

    % Initialize pyramid optical flow guess and current level guess optical flow 
    pyramidGuessOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);
    levelOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);
    
    for L = pyramidDepth + 1 : -1 : 1
        
        % Compute size of images for current level
        currentSize = size(previousFrame) / (2 ^ (L - 1));
        
        % Get images from pyramids
        previousPyramidCurrentLevel = previousPyramid(1:currentSize(1), 1:currentSize(2), L);
        currentPyramidCurrentLevel = currentPyramid(1:currentSize(1), 1:currentSize(2), L);
        
        % Project tracked points to current level
        levelPointsToTrack = pointsToTrack ./ (2 ^ (L - 1));
        
        % Estimate optical flow for current level
        levelOpticalFlow(:, :, L) = lucasKandeAlgorithm(previousPyramidCurrentLevel, ...
            currentPyramidCurrentLevel, levelPointsToTrack, windowRadiousY, ...
            windowRadiousX, maxIterations, stopThreshold, weightingKernelFcnHandle, ...
            engileFcnHandle, pyramidGuessOpticalFlow(:, :, L));
        
        % Project current level estimation to the previous level
        if L > 1
            pyramidGuessOpticalFlow(:, :, L - 1) = 2 * (pyramidGuessOpticalFlow(:, :, L) + levelOpticalFlow(:, :, L));
        end
        
    end
    
    % Calculate final optical flow estimation
    opticalFlow = levelOpticalFlow(:, :, 1) + pyramidGuessOpticalFlow(:, :, 1);
    
end

