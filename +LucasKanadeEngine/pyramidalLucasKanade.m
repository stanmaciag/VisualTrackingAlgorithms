function [opticalFlow, trackingSuccessful] = pyramidalLucasKanade(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, pyramidDepth, minHessianDet, engileFcnHandle, weightingKernelFcnHandle, ...
    imagePyramidFcnHandle, interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle)
    %PYRAMIDALLUCASKANADE Summary of this function goes here
    %   Detailed explanation goes here
    % References
    % ----------
    % 1. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
    % tracker - Description of the algorithm Intel Corporation - Microprocessor
    % Research Labs, 2000
    
    minPointX = floor(min(min(pointsToTrack(:,1))));
    maxPointX = ceil(max(max(pointsToTrack(:,1))));
    minPointY = floor(min(min(pointsToTrack(:,2))));
    maxPointY = ceil(max(max(pointsToTrack(:,2))));

    roiMinX = max(minPointX - (2 ^ (pyramidDepth + 1)) * windowRadiousX, 1);
    roiMaxX = min(maxPointX + (2 ^ (pyramidDepth + 1)) * windowRadiousX, size(currentFrame,2));
    roiMinY = max(minPointY - (2 ^ (pyramidDepth + 1)) * windowRadiousY, 1);
    roiMaxY = min(maxPointY + (2 ^ (pyramidDepth + 1)) * windowRadiousY, size(currentFrame,1));
   
    pointsToTrack(:,1) = pointsToTrack(:,1) - roiMinX + 1;
    pointsToTrack(:,2) = pointsToTrack(:,2) - roiMinY + 1;
    
    % Compute image pyramids for current and previous frame
    previousFrame = previousFrame(roiMinY:roiMaxY, roiMinX:roiMaxX);
    currentFrame = currentFrame(roiMinY:roiMaxY, roiMinX:roiMaxX);
    [previousPyramid, levelSize] = imagePyramidFcnHandle(previousFrame, pyramidDepth);
    currentPyramid = imagePyramidFcnHandle(currentFrame, pyramidDepth);
   
    % Initialize pyramid optical flow guess and current level guess optical flow 
    pyramidGuessOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);
    levelOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);

    trackingSuccessful = true(size(pointsToTrack, 1), 1);
    
    for L = pyramidDepth + 1 : -1 : 1
        
        % Get images from pyramids
        previousPyramidCurrentLevel = previousPyramid(1:levelSize(L, 1), 1:levelSize(L, 2), L);
        currentPyramidCurrentLevel = currentPyramid(1:levelSize(L, 1), 1:levelSize(L, 2), L);
        
        % Project tracked points to current level
        levelPointsToTrack = pointsToTrack ./ (2 ^ (L - 1));
        
        % Estimate optical flow for current level
        [currentLevelOpticalFlow, currentTrackingSuccessful] = LucasKanadeEngine.lucasKanadeAlgorithm(previousPyramidCurrentLevel, ...
            currentPyramidCurrentLevel, levelPointsToTrack(trackingSuccessful, :), windowRadiousY, ...
            windowRadiousX, maxIterations, stopThreshold, minHessianDet, weightingKernelFcnHandle, ...
            engileFcnHandle, pyramidGuessOpticalFlow(trackingSuccessful, :, L), interpolatedGradientFcnHandle, ...
            bilinearInterpolateFcnHandle);
        
        trackingSuccessful(trackingSuccessful) = trackingSuccessful(trackingSuccessful) & currentTrackingSuccessful;
        levelOpticalFlow(trackingSuccessful, :, L) = currentLevelOpticalFlow(currentTrackingSuccessful, :);

        %pointsToTrack = pointsToTrack(trackingSuccessful, :);
        %pyramidGuessOpticalFlow = pyramidGuessOpticalFlow(trackingSuccessful, :, :);
        %levelOpticalFlow = levelOpticalFlow(trackingSuccessful, :, :);
        
        % Project current level estimation to the previous level
        if L > 1
            pyramidGuessOpticalFlow(trackingSuccessful, :, L - 1) = 2 * (pyramidGuessOpticalFlow(trackingSuccessful, :, L) + levelOpticalFlow(trackingSuccessful, :, L));
        end
        
    end
    
    opticalFlow = zeros(size(pointsToTrack));
    
    % Calculate final optical flow estimation
    opticalFlow(trackingSuccessful, :) = levelOpticalFlow(trackingSuccessful, :, 1) + pyramidGuessOpticalFlow(trackingSuccessful, :, 1);
    
end

