function [opticalFlow, trackingSuccessful] = inverseCompostionalLK(previousFrame, currentFrame, ...
    trackedPoints, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, minHessianDet, initialOpticalFlow, ...
    interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle)
    % References
    % ----------
    % 1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying 
    % Framework International Journal of Computer Vision, 2004, 56, 221-255

    % Compute spatial gradients of previous frame
    %[gradientX, gradientY] = gradient(previousFrame);
    
    % Initialize optical flow vectors
    opticalFlow = zeros(size(trackedPoints));
    
    % Reject features that already have left the image area
    pointsOutBounds = trackedPoints(:,1) + initialOpticalFlow(:,1) < windowRadiousX + 2 | ...
        trackedPoints(:,2) + initialOpticalFlow(:,2) < windowRadiousY + 2 | ...
        trackedPoints(:,1) + initialOpticalFlow(:,1) > size(currentFrame,2) - windowRadiousX - 1 | ...
        trackedPoints(:,2) + initialOpticalFlow(:,2) > size(currentFrame,1) - windowRadiousY - 1;

    trackingSuccessful = ~pointsOutBounds;
    
    % Initialize search window 3d array filled with meshgrid of coordinates for every 
    % tracked point (faster way than for loop preinitialization with zeros and
    % looping)
    [windowPixelsX, windowPixelsY] = meshgrid(-windowRadiousX : windowRadiousX, -windowRadiousY : windowRadiousY);
    windowPixelsX = repmat(windowPixelsX, 1, 1, size(trackedPoints,1));
    windowPixelsY = repmat(windowPixelsY, 1, 1, size(trackedPoints,1));
    initialDsplX = permute(trackedPoints(:,1), [3, 2, 1]);
    initialDsplX = repmat(initialDsplX, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    initialDsplY = permute(trackedPoints(:,2), [3, 2, 1]);
    initialDsplY = repmat(initialDsplY, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    
    windowPixelsX = windowPixelsX + initialDsplX;
    windowPixelsY = windowPixelsY + initialDsplY;
    
    % Get rid of unused variables
    clear initialDsplX initialDsplY;
    
    % Replicate weighting kernel to fit size of search windows array
    weightingKernel = repmat(weightingKernel,1,1,size(trackedPoints,1));
    
    
    gradientYWindow = zeros(size(windowPixelsY));
    gradientXWindow = zeros(size(windowPixelsX));
    templateWindow = zeros(size(windowPixelsY));
    
    % Compute template's spatial gradients in every search window (has to
    % be interpolated, because function accetps non-integer coordinates of
    % tracked points)
    %gradientYWindow = bilinearInterpolateFcnHandle(gradientY, windowPixelsY, windowPixelsX);
    %gradientXWindow = bilinearInterpolateFcnHandle(gradientX, windowPixelsY, windowPixelsX);
    %[gradientXWindow, gradientYWindow] = interpolatedGradientFcnHandle(previousFrame, windowPixelsY, windowPixelsX);
    [gradientXWindow(:,:,trackingSuccessful), gradientYWindow(:,:,trackingSuccessful)] = ....
        interpolatedGradientFcnHandle(previousFrame, windowPixelsY(:,:,trackingSuccessful), windowPixelsX(:,:,trackingSuccessful));

    % Get template image in every search window
    %templateWindow = bilinearInterpolateFcnHandle(previousFrame, windowPixelsY, windowPixelsX);
    templateWindow(:,:,trackingSuccessful) = bilinearInterpolateFcnHandle(previousFrame, windowPixelsY(:,:,trackingSuccessful), ...
        windowPixelsX(:,:,trackingSuccessful));
    
    %gradientMomentXX = zeros(1, 1 ,size(gradientXWindow, 3));
    %gradientMomentXY = zeros(1, 1, size(gradientXWindow, 3));
    %gradientMomentYY = zeros(1, 1, size(gradientXWindow, 3));
    %hessian = zeros(2, 2, size(gradientXWindow, 3));
    hessianDet = zeros(1, 1, size(gradientXWindow, 3));
    invHessian = zeros(2, 2, size(gradientXWindow, 3));
    
    % Calculate Hessian matrix for every search window
    %gradientMomentXX(:,:,trackingSuccessful) = sum(sum(gradientXWindow(:,:,trackingSuccessful) .* gradientXWindow(:,:,trackingSuccessful) .* weightingKernel(:,:,trackingSuccessful)));
    %gradientMomentXY(:,:,trackingSuccessful) = sum(sum(gradientXWindow(:,:,trackingSuccessful) .* gradientYWindow(:,:,trackingSuccessful) .* weightingKernel(:,:,trackingSuccessful)));
    %gradientMomentYY(:,:,trackingSuccessful) = sum(sum(gradientYWindow(:,:,trackingSuccessful) .* gradientYWindow(:,:,trackingSuccessful) .* weightingKernel(:,:,trackingSuccessful)));
    gradientMomentXX = sum(sum(gradientXWindow .* gradientXWindow .* weightingKernel));
    gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow .* weightingKernel));
    gradientMomentYY = sum(sum(gradientYWindow .* gradientYWindow .* weightingKernel));

    %hessian(:,:,trackingSuccessful) = [gradientMomentXX(:,:,trackingSuccessful) gradientMomentXY(:,:,trackingSuccessful); gradientMomentXY(:,:,trackingSuccessful) gradientMomentYY(:,:,trackingSuccessful)];
    hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];

    % Compute Hessian inversion
    hessianDet(:,:,trackingSuccessful) = (hessian(1,1,trackingSuccessful) .* hessian(2,2,trackingSuccessful) - hessian(1,2,trackingSuccessful) .* hessian(2,1,trackingSuccessful));
    %hessianDet = (hessian(1,1,:) .* hessian(2,2,:) - hessian(1,2,:) .* hessian(2,1,:));
    
    % Reject degenerated features
    trackingSuccessful = trackingSuccessful & (permute(hessianDet, [3, 2, 1]) >= minHessianDet);
    
    invHessian(:,:,trackingSuccessful) = [hessian(2,2,trackingSuccessful) ./ hessianDet(:,:,trackingSuccessful), -hessian(1,2,trackingSuccessful) ./ hessianDet(:,:,trackingSuccessful); ...
        -hessian(2,1,trackingSuccessful) ./ hessianDet(:,:,trackingSuccessful), hessian(1,1,trackingSuccessful) ./ hessianDet(:,:,trackingSuccessful)];
    
    
    
    % Initialize main loop
    convergedPoints = false(size(trackedPoints,1),1);
    %opticalFlow =  zeros(size(trackedPoints));
    
    for i = 1:maxIterations
        
        % Select points, which have not converged yet
        toProcessIdx = ~convergedPoints & trackingSuccessful;
        
        % Stop if every point converged
        if isempty(toProcessIdx)
            
            break;
            
        end
        
        % Expand current optical flow estimation to homogenous field for
        % every point (faster than looping)
        currentFlowFieldY = opticalFlow(toProcessIdx,2) + initialOpticalFlow(toProcessIdx, 2);
        currentFlowFieldY = repmat(currentFlowFieldY, 1, size(windowPixelsY,1), size(windowPixelsY,2));
        currentFlowFieldY = permute(currentFlowFieldY, [2, 3, 1]);
        
        currentFlowFieldX = opticalFlow(toProcessIdx,1) + initialOpticalFlow(toProcessIdx, 1);
        currentFlowFieldX = repmat(currentFlowFieldX, 1, size(windowPixelsX,1), size(windowPixelsX,2));
        currentFlowFieldX = permute(currentFlowFieldX, [2, 3, 1]);

        % Compute warped current search window
        windowWarped = bilinearInterpolateFcnHandle(currentFrame, ...
                   windowPixelsY(:,:,toProcessIdx) + currentFlowFieldY, ...
                   windowPixelsX(:,:,toProcessIdx) + currentFlowFieldX);
               
        % Compute error image for current window
        errorImage = windowWarped - templateWindow(:,:,toProcessIdx);
        
        % Update steppest descent parameters
        steppestDescentUpdate = [sum(sum(gradientXWindow(:,:,toProcessIdx) .* errorImage .* weightingKernel(:, :, toProcessIdx))); ... 
                sum(sum(gradientYWindow(:, :, toProcessIdx) .* errorImage .* weightingKernel(:, :, toProcessIdx)))];
        
        % Compute optical flow change
        flowChange = [invHessian(1, 1, toProcessIdx) .* steppestDescentUpdate(1, 1, :) + invHessian(1, 2, toProcessIdx) .* steppestDescentUpdate(2, 1, :), ...
            invHessian(2, 1, toProcessIdx) .* steppestDescentUpdate(1, 1, :) + invHessian(2, 2, toProcessIdx) .* steppestDescentUpdate(2, 1, :)];
        
        % Rearrange result dimensions to fit convention
        flowChange = permute(flowChange,[3,2,1]);
        
        % Update optical flow by composition with warp inversion
        opticalFlow(toProcessIdx,:) = opticalFlow(toProcessIdx,:) - flowChange;

        % Check for converged points in currently processed set
        convergedPoints(toProcessIdx) = sqrt(flowChange(:,1).^2 + flowChange(:,2).^2) < stopThreshold;
        
        % Reject features that left the image area
        pointsOutBounds = trackedPoints(:,1) + opticalFlow(:,1)  + initialOpticalFlow(:,1) < windowRadiousX + 2 | ...
            trackedPoints(:,2) + opticalFlow(:,2)  + initialOpticalFlow(:,2) < windowRadiousY + 2 | ...
            trackedPoints(:,1) + opticalFlow(:,1)  + initialOpticalFlow(:,1) > size(currentFrame,2) - windowRadiousX - 1 | ...
            trackedPoints(:,2) + opticalFlow(:,2)   + initialOpticalFlow(:,2) > size(currentFrame,1) - windowRadiousY - 1;
        
        trackingSuccessful = trackingSuccessful & ~pointsOutBounds;
        
    end
    
    opticalFlow(~trackingSuccessful, 1) = 0;
    opticalFlow(~trackingSuccessful, 2) = 0;
    
end

