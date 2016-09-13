function opticalFlow = inverseCompostionalLK(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, initialOpticalFlow)
    % References
    % ----------
    % 1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying 
    % Framework International Journal of Computer Vision, 2004, 56, 221-255

    % Compute spatial gradients of previous frame
    %[gradientX, gradientY] = gradient(previousFrame);
    
    % Initialize optical flow vectors
    opticalFlow = zeros(size(pointsToTrack));
    
    % Initialize search window 3d array filled with meshgrid of coordinates for every 
    % tracked point (faster way than for loop preinitialization with zeros and
    % looping)
    [windowPixelsX, windowPixelsY] = meshgrid(-windowRadiousX : windowRadiousX, -windowRadiousY : windowRadiousY);
    windowPixelsX = repmat(windowPixelsX, 1, 1, size(pointsToTrack,1));
    windowPixelsY = repmat(windowPixelsY, 1, 1, size(pointsToTrack,1));
    initialDsplX = permute(pointsToTrack(:,1), [3, 2, 1]);
    initialDsplX = repmat(initialDsplX, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    initialDsplY = permute(pointsToTrack(:,2), [3, 2, 1]);
    initialDsplY = repmat(initialDsplY, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    
    windowPixelsX = windowPixelsX + initialDsplX;
    windowPixelsY = windowPixelsY + initialDsplY;
    
    % Get rid of unused variables
    clear initialDsplX initialDsplY;
    
    % Replicate weighting kernel to fit size of search windows array
    weightingKernel = repmat(weightingKernel,1,1,size(pointsToTrack,1));
    
    % Compute template's spatial gradients in every search window (has to
    % be interpolated, because function accetps non-integer coordinates of
    % tracked points)
    %gradientYWindow = bilinearInterpolate_mex(gradientY, windowPixelsY, windowPixelsX);
    %gradientXWindow = bilinearInterpolate_mex(gradientX, windowPixelsY, windowPixelsX);
    %[gradientXWindow, gradientYWindow] = interpolatedGradient(previousFrame, windowPixelsY, windowPixelsX);
    [gradientXWindow, gradientYWindow] = interpolatedGradient_mex(previousFrame, windowPixelsY, windowPixelsX);
    
    % Get template image in every search window
    templateWindow = bilinearInterpolate_mex(previousFrame, windowPixelsY, windowPixelsX);
    
    % Calculate Hessian matrix for every search window
    gradientMomentXX = sum(sum(gradientXWindow .* gradientXWindow .* weightingKernel));
    gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow .* weightingKernel));
    gradientMomentYY = sum(sum(gradientYWindow .* gradientYWindow .* weightingKernel));
    hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
    
    % Compute Hessian inversion
    hessianDet = (hessian(1,1,:) .* hessian(2,2,:) - hessian(1,2,:) .* hessian(2,1,:));
    invHessian = [hessian(2,2,:) ./ hessianDet, -hessian(1,2,:) ./ hessianDet; ...
        -hessian(2,1,:) ./ hessianDet, hessian(1,1,:) ./ hessianDet];
    
    % Initialize main loop
    convergedPoints = zeros(size(pointsToTrack,1),1);
    
    for i = 1:maxIterations
        
        % Select points, which have not converged yet
        toProcessIdx = find(~convergedPoints);
        
        % Stop if every point converged
        if isempty(toProcessIdx)
            
            break;
            
        end
        
        % Expand current optical flow estimation to homogenous matrix for
        % every point (faster than looping)
        currentFlowFieldY = opticalFlow(toProcessIdx,2) + initialOpticalFlow(toProcessIdx, 2);
        currentFlowFieldY = repmat(currentFlowFieldY,1,size(windowPixelsY,1),size(windowPixelsY,2));
        currentFlowFieldY = permute(currentFlowFieldY, [3, 2, 1]);
        
        currentFlowFieldX = opticalFlow(toProcessIdx,1) + initialOpticalFlow(toProcessIdx, 1);
        currentFlowFieldX = repmat(currentFlowFieldX,1,size(windowPixelsX,1),size(windowPixelsX,2));
        currentFlowFieldX = permute(currentFlowFieldX, [3, 2, 1]);
        
        % Compute warped current search window
        windowWarped = bilinearInterpolate_mex(currentFrame, ...
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
        
    end
    
end

