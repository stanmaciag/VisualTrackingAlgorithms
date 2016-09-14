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
   
    % Compute image pyramids for current and previous frame
    previousPyramid = imagePyramid(double(previousFrame), pyramidDepth);
    currentPyramid = imagePyramid(double(currentFrame), pyramidDepth);
   
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
        levelOpticalFlow(:, :, L) = lucasKanadeAlgorithm(previousPyramidCurrentLevel, ...
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

