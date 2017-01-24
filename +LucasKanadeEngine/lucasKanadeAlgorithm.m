function [opticalFlow, trackingSuccessful] = lucasKanadeAlgorithm(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, minHessianDet, weightingKernelFcnHandle, engineFcnHandle, initialOpticalFlow, ... 
    interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle)
    
    % Zero initial flow if another not given
    if nargin < 11
       
        initialOpticalFlow = zeros(size(pointsToTrack));
        
    end
    
    % Compute kernel for current window
    [kernelX, kernelY] = meshgrid(1 : 2 * windowRadiousX + 1, 1 : 2 * windowRadiousY + 1);
    weightingKernel = weightingKernelFcnHandle(kernelY, kernelX);
   
    % Pad images with zero-value pixels, pad size is defined
    % by search window size - prevent from outreaching image boundaries for
    % every point inside image
    initExtendedCurrentFrame = zeros(size(currentFrame,1) + 2 * windowRadiousY + 2, size(currentFrame,2) + 2 * windowRadiousX + 2, class(currentFrame));
    initExtendedPreviousFrame = zeros(size(previousFrame,1) + 2 * windowRadiousY + 2, size(previousFrame,2) + 2 * windowRadiousX + 2, class(previousFrame));
    initExtendedCurrentFrame(windowRadiousY + 2 : size(currentFrame,1) + windowRadiousY + 1, ...
        windowRadiousX + 2 : size(currentFrame,2) + windowRadiousX + 1) = currentFrame;
    currentFrame = initExtendedCurrentFrame;
    initExtendedPreviousFrame(windowRadiousY + 2 : size(previousFrame,1) + windowRadiousY + 1, ...
        windowRadiousX + 2 : size(previousFrame,2) + windowRadiousX + 1) = previousFrame;
    previousFrame = initExtendedPreviousFrame;
    
    % Shift points coordinates - reconcile with padded images
    pointsToTrack(:,2) = pointsToTrack(:,2) + windowRadiousY + 1;
    pointsToTrack(:,1) = pointsToTrack(:,1) + windowRadiousX + 1;

    % Estimate optical flow
    [opticalFlow, trackingSuccessful] = engineFcnHandle(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, minHessianDet, initialOpticalFlow, ...
    interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle);
    
end

