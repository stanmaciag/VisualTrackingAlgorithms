function opticalFlow = forwardAdditiveLK(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, initialOpticalFlow, ...
    interpolatedGradientFcnHandle, bilinearInterpolateFcnHandle)
    %ITERATIVELUCASKANADE Estimates optical flow using Lucas-Kanade algorithm
    % OPTICALFLOW = ITERATIVELUCASKANADE(PREVIOUSFRAME, CURRENTFRAME, 
    % POINTSTOTRACK, WINDOWRADIOUSY, WINDOWRADIOUSX, MAXITERATIONS, 
    % STOPTHRESHOLD, WEIGHTINGKERNELFCNHANDLE, INITIALOPTICALFLOW) estimates an optical 
    % flow between two succeeding frames of video sequence, PREVIOUSFRAME and
    % CURRENTFRAME, which are same-sized, gray-scale images. Input matrix Nx2 
    % POINTSTOTRACK defines sparse set of (Y,X) coordinates of points to be
    % tracked, WINDOWRADIOUSY and WINDOWRADIOUSX sets the size of search 
    % window, MAXITERATIONS limits the maximum flow vector rectification loop 
    % runs per point and STOPTHRESHOLD defines the value of vectors 
    % rectification norm that that ends the calculation for every point.
    % Argument WEIGHTINGKERNELFCNHANDLE  assigns each pixel a value, by which it
    % weights during computation of Hessian matrix and steppest descent image
    % (i.e., could be Gaussian kernel to emphasise central area of the window, 
    % by default it is uniform), has to be sized 2 * WINDOWRADIOUSY + 1 x 
    % 2 * WINDOWRADIOUSX + 1. Function returns Nx2 matrix OPTICALFLOW, 
    % containing estimated optical flow vectors (V,U) assigned to input points 
    % by corresponding indices.
    %
    % Notes
    % -----
    % 1. Input matrix POINTSTOTRACK should contain rows of pairs of pixel
    % coordinates on input image PREVIOUSFRAME. The first coordinate
    % should correspond to Y coordinate (along vertical axis) of pixel on
    % the input image and the secod should correspond to X coordinate (along
    % horizontal axis) respectively. It may appear rather illogical, but is
    % consistent with MATLAB's convention, which defines first index of an 
    % element in two-dimensional array as row index and second as column index.
    % Consequently, output matrix OPTICALFLOW contains pairs of opitcal flow
    % vectors components, from among first describes movement along Y axis and
    % second along X axis.
    % 2. This function is meant to be the core engine for optical flow
    % estimation which can be used in another algorithms or wrapped in
    % classes. Because of that, it contains only essential code that implements
    % the method and excludes additional features, like image noise reduction.
    % Primarily, it lacks arguments validation, which should be accomplished 
    % by calling subject.
    %
    % Example 1
    % ---------
    % This example estimates optical flow for four sample points between image
    % and its rotation and shows the result.
    %
    % frame1 = imread('cameraman.tif');
    % frame2 = imrotate(frame1, 1,'bilinear','crop');
    %
    % y = round([size(frame1,1) / 3, 2 * size(frame1,1) / 3]);
    % x = round([size(frame1,2) / 3, 2 * size(frame1,2) / 3]);
    % [pointsY, pointsX] = meshgrid(y,x);
    % points = [pointsY(:), pointsX(:)];
    %
    % % flow = forwardAdditiveLK(frame1, frame2, points, 22, 22, 3, 0.5);
    % imshow(frame1);
    % hold on;
    % quiver(points(:,1), points(:,2), flow(:,1), flow(:,2));
    %
    % References
    % ----------
    % 1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying 
    % Framework International Journal of Computer Vision, 2004, 56, 221-255
    % 2. Tomasi, C. & Kanade, T. Detection and Tracking of Point Features
    % School of Computer Science Carnegie Mellon University, 1991
  
    
    % Initialize optical flow vectors
    opticalFlow = zeros(size(pointsToTrack));
    
    % Compute spatial gradients of current frame
    [gradientX, gradientY] = gradient(currentFrame);
    
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
        
        % Estimate and refine optical flow for current point
        for i = 1:maxIterations
            
            % Warp current frame window with last opitcal flow estimation
            windowWarped = bilinearInterpolateFcnHandle(currentFrame, ...
            	windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx,2), ...
            	windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx,1));
            
            % Warp vertical gradient window with last opitcal flow estimation
            gradientYWindow = bilinearInterpolateFcnHandle(gradientY, ...
                windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx,2), ...
            	windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx,1));
            
            % Warp horizontal gradient window with last opitcal flow estimation
            gradientXWindow = bilinearInterpolateFcnHandle(gradientX, ...
                windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx,2), ...
                windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx,1));
            
            % Compute Hessian matrix
            gradientMomentXX = sum(sum(gradientXWindow .^ 2 .* weightingKernel));
            gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow .* weightingKernel));
            gradientMomentYY = sum(sum(gradientYWindow .^ 2 .* weightingKernel));
            hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
            
            % Compute error image for current window
            errorImageWindow = bilinearInterpolateFcnHandle(previousFrame, windowPixelsY, windowPixelsX) - windowWarped;
            
            % Update steppest descent parameters
            steppestDescentUpdate = [sum(sum(gradientXWindow .* errorImageWindow .* weightingKernel)); ... 
                sum(sum(gradientYWindow .* errorImageWindow .* weightingKernel))];
            
            % Compute optical flow change
            flowChange = hessian \ steppestDescentUpdate;
            
            % Update optical flow by addition
            currentFlow = currentFlow + flowChange;
            
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