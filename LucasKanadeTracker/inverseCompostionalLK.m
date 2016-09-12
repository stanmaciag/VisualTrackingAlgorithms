function opticalFlow = inverseCompostionalLK(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernelFcnHandle, initialOpticalFlow)
    % References
    % ----------
    % 1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying 
    % Framework International Journal of Computer Vision, 2004, 56, 221-255

    % Use uniform kernlen if another not given
    if nargin < 8
        
        weightingKernelFcnHandle = @uniformKernel;
        
    end
    
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
 
    % Compute spatial gradients of previous frame
    [gradientX, gradientY] = gradient(previous);
    
    % Shift points coordinates - reconcile with padded gradient matrices
    pointsToTrack(:,2) = pointsToTrack(:,2) + windowRadiousY + 1;
    pointsToTrack(:,1) = pointsToTrack(:,1) + windowRadiousX + 1;

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
        gradientYWindow = bilinearInterpolate(templateGradientY, windowPixelsY, windowPixelsX);
        gradientXWindow = bilinearInterpolate(templateGradientX, windowPixelsY, windowPixelsX);
        
        % Get template for current window
        templateWindow = bilinearInterpolate(previousFrame, windowPixelsY, windowPixelsX);
        
        % Compute Hessian matrix
        gradientMomentXX = sum(sum(gradientXWindow .* gradientXWindow .* weightingKernel));
        gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow .* weightingKernel));
        gradientMomentYY = sum(sum(gradientYWindow .* gradientYWindow .* weightingKernel));
        hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
        
        % Estimate and refine optical flow for current point
        for i = 1:maxIterations

            % Warp current frame window with last opitcal flow estimation
            windowWarped = bilinearInterpolate(currentFrame, ...
                   windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx, 2), ...
                   windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx, 1));

            % Compute error image for current window
            gradientTWindow = windowWarped - templateWindow;
            
            % Update steppest descent parameters
            steppestDescentUpdate = [sum(sum(gradientXWindow .* gradientTWindow .* weightingKernel)); ... 
                    sum(sum(gradientYWindow .* gradientTWindow .* weightingKernel))];

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

