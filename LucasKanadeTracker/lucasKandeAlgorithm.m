function opticalFlow = lucasKandeAlgorithm(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernelFcnHandle, engineFcnHandle, initialOpticalFlow)
    
    % Zero initial flow if another not given
    if nargin < 9
       
        initialOpticalFlow = zeros(size(pointsToTrack));
        
    end
    
    % Compute kernel for current window
    [kernelX, kernelY] = meshgrid(1 : 2 * windowRadiousX + 1, 1 : 2 * windowRadiousY + 1);
    weightingKernel = weightingKernelFcnHandle(kernelY, kernelX);
   
    % Pad images with zero-value pixels, pad size is defined
    % by search window size - prevent from outreaching image boundaries for
    % every point inside image
    initExtendedCurrentFrame = zeros(size(currentFrame,1) + 2 * windowRadiousY + 2, size(currentFrame,2) + 2 * windowRadiousX + 2);
    initExtendedPreviousFrame = zeros(size(previousFrame,1) + 2 * windowRadiousY + 2, size(previousFrame,2) + 2 * windowRadiousX + 2);
    initExtendedCurrentFrame(windowRadiousY + 1 : size(currentFrame,1) + windowRadiousY, ...
        windowRadiousX + 1 : size(currentFrame,2) + windowRadiousX) = currentFrame;
    currentFrame = initExtendedCurrentFrame;
    initExtendedPreviousFrame(windowRadiousY + 1 : size(previousFrame,1) + windowRadiousY, ...
        windowRadiousX + 1 : size(previousFrame,2) + windowRadiousX) = previousFrame;
    previousFrame = initExtendedPreviousFrame;
    
    % Shift points coordinates - reconcile with padded gradient matrices
    pointsToTrack(:,2) = pointsToTrack(:,2) + windowRadiousY + 1;
    pointsToTrack(:,1) = pointsToTrack(:,1) + windowRadiousX + 1;

    % Estimate optical flow
    opticalFlow = engineFcnHandle(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, initialOpticalFlow);
    
end

