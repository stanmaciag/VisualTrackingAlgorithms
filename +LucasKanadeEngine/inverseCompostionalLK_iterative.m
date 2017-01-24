function opticalFlow = inverseCompostionalLK_iterative(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, initialOpticalFlow, interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle)
    % References
    % ----------
    % 1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying 
    % Framework International Journal of Computer Vision, 2004, 56, 221-255

    % Compute spatial gradients of previous frame
    [gradientX, gradientY] = gradient(previousFrame);
    
    % Initialize optical flow vectors
    opticalFlow = zeros(size(pointsToTrack));
    
    % Iterate for every given point to track
    for currentPointIdx = 1:size(pointsToTrack,1)
    
        % Initialize optical flow estimation for the current point
        currentFlow = [0; 0];
        
        % Determine current point tracking window 
        windowYRangeMin = pointsToTrack(currentPointIdx, 2) - windowRadiousY;
        windowYRangeMax = pointsToTrack(currentPointIdx, 2) + windowRadiousY;
        windowXRangeMin = pointsToTrack(currentPointIdx, 1) - windowRadiousX;
        windowXRangeMax = pointsToTrack(currentPointIdx, 1) + windowRadiousX;
     
        [windowPixelsX, windowPixelsY] = meshgrid(windowXRangeMin : windowXRangeMax, windowYRangeMin : windowYRangeMax); 
        
        % Get spatial gradient for current window
        gradientYWindow = bilinearInterpolateFcnHandle(gradientY, windowPixelsY, windowPixelsX);
        gradientXWindow = bilinearInterpolateFcnHandle(gradientX, windowPixelsY, windowPixelsX);
        
        % Get template for current window
        templateWindow = bilinearInterpolateFcnHandle(previousFrame, windowPixelsY, windowPixelsX);
        
        % Compute Hessian matrix
        gradientMomentXX = sum(sum(gradientXWindow .* gradientXWindow .* weightingKernel));
        gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow .* weightingKernel));
        gradientMomentYY = sum(sum(gradientYWindow .* gradientYWindow .* weightingKernel));
        hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
        
        % Estimate and refine optical flow for current point
        for i = 1:maxIterations

            % Warp current frame window with last opitcal flow estimation
            windowWarped = bilinearInterpolateFcnHandle(currentFrame, ...
                   windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx, 2), ...
                   windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx, 1));

            % Compute error image for current window
            errorImage = windowWarped - templateWindow;
            
            % Update steppest descent parameters
            steppestDescentUpdate = [sum(sum(gradientXWindow .* errorImage .* weightingKernel)); ... 
                    sum(sum(gradientYWindow .* errorImage .* weightingKernel))];

            % Compute optical flow change
            flowChange = hessian \ steppestDescentUpdate;

            % Update optical flow by composition with warp inversion
            currentFlow = currentFlow - flowChange;

            % Check stop condition
            if norm(flowChange) < stopThreshold
                
                % Stop if converged
                break;

            end

        end

        % Save result for current point
        opticalFlow(currentPointIdx, :) = currentFlow;
        
    end
    
end

