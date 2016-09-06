function opticalFlow = iterativeLucasKanade(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, weightingKernel, initialOpticalFlow)
%ITERATIVELUCASKANADE Estimates optical flow using Lucas-Kanade algorithm
% OPTICALFLOW = ITERATIVELUCASKANADE(PREVIOUSFRAME, CURRENTFRAME, 
% POINTSTOTRACK, WINDOWRADIOUSY, WINDOWRADIOUSX, MAXITERATIONS, 
% STOPTHRESHOLD, WEIGHTINGKERNEL, INITIALOPTICALFLOW) estimates an optical 
% flow between two succeeding frames of video sequence, PREVIOUSFRAME and
% CURRENTFRAME, which are same-sized, gray-scale images. Input matrix Nx2 
% POINTSTOTRACK defines sparse set of (Y,X) coordinates of points to be
% tracked, WINDOWRADIOUSY and WINDOWRADIOUSX sets the size of search 
% window, MAXITERATIONS limits the maximum flow vector rectification loop 
% runs per point and STOPTHRESHOLD defines the value of vectors 
% rectification norm that that ends the calculation for every point.
% Optional arugment WEIGHTINGKERNEL assigns each pixel a value, by which it
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
% % flow = iterativeLucasKanade(frame1, frame2, points, 22, 22, 3, 0.5);
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
% 3. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
% tracker - Description of the algorithm Intel Corporation - Microprocessor
% Research Labs, 2000
    
    % Check if optional argument weightingKernel present
    if nargin < 8
       
        % Set uniform weight for all pixels in the window
        weightingKernel = ones(2 * windowRadiousY + 1, 2 * windowRadiousX + 1) / ...
            ((2 * windowRadiousY + 1) * (2 * windowRadiousX + 1));
        
    end
    
    % Convert weighting kernel to vector (compatible with other factors)
    weightingKernel = weightingKernel(:);

    if nargin < 9
       
        initialOpticalFlow = zeros(size(pointsToTrack));
        
    end
    
    % Convert window size variables to double type (required by Coder's
    % type assertion)
    windowRadiousY = double(windowRadiousY);
    windowRadiousX = double(windowRadiousX);
    
    
    % Convert images to double type
    previousFrame = double(previousFrame);
    currentFrame = double(currentFrame);
    
    % Compute image spatial gradients
    [gradientX, gradientY] = gradient(previousFrame);
    %[gradientX, gradientY] = imgradientxy(previousFrame, 'Central');
    
    % Extend images and images gradients with zero-value pixels, border size is defined
    % by search window size - allows to compute Hessian matrix for every
    % actual pixel on the image
    borderY = zeros(size(previousFrame,1), windowRadiousX + 1);
    borderX = zeros(windowRadiousY + 1, size(previousFrame,2) + 2 * (windowRadiousX + 1));
    
    previousFrame = [borderX; borderY, previousFrame, borderY; borderX];
    currentFrame = [borderX; borderY, currentFrame, borderY; borderX];
    gradientY = [borderX; borderY, gradientY, borderY; borderX];
    gradientX = [borderX; borderY, gradientX, borderY; borderX];

    % Shift points coordinates - reconcile with extended gradient matrices
    pointsToTrack(:,1) = pointsToTrack(:,1) + windowRadiousY + 1;
    pointsToTrack(:,2) = pointsToTrack(:,2) + windowRadiousX + 1;
    
    % Initialize main loop
    currentPointIdx = 1;
    
    % Initalize optical flow values
    opticalFlow = zeros(size(pointsToTrack)); 
    
    while currentPointIdx <= size(pointsToTrack,1)
        
        % Initialize estimation for the current point
        currentFlow = [0; 0];
        
        % Determine current point tracking window 
        windowYRangeMin = pointsToTrack(currentPointIdx, 2) - windowRadiousY;
        windowYRangeMax = pointsToTrack(currentPointIdx, 2) + windowRadiousY;
        windowXRangeMin = pointsToTrack(currentPointIdx, 1) - windowRadiousX;
        windowXRangeMax = pointsToTrack(currentPointIdx, 1) + windowRadiousX;
       
        % Get spatial gradients in the current window
        [windowPixelsX, windowPixelsY] = meshgrid(windowXRangeMin : windowXRangeMax, windowYRangeMin : windowYRangeMax);
        %gradientYWindow = gradientY(windowYRangeMin : windowYRangeMax, windowXRangeMin : windowXRangeMax);
        %gradientXWindow = gradientX(windowYRangeMin : windowYRangeMax, windowXRangeMin : windowXRangeMax);
        %gradientYWindow = interp2(gradientY, windowPixelsX, windowPixelsY, 'linear');
        %gradientXWindow = interp2(gradientX, windowPixelsX, windowPixelsY, 'linear');
        gradientYWindow = bilinearInterpolate(gradientY, windowPixelsY, windowPixelsX);
        gradientXWindow = bilinearInterpolate(gradientX, windowPixelsY, windowPixelsX);
        
        gradientYWindow = gradientYWindow(:);
        gradientXWindow = gradientXWindow(:);
        
        % Compute Hessian
        gradientMomentXX = sum(gradientXWindow.^2 .* weightingKernel);
        gradientMomentXY = sum(gradientXWindow .* gradientYWindow .* weightingKernel);
        gradientMomentYY = sum(gradientYWindow.^2 .* weightingKernel);
        hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
        
        % Estimate and refine optical flow for current point
        for i = 1:maxIterations
            
            % First estimation does not need interpolation (previous
            % estimation is assumed to be zero - no warp)
            %if (firstIteration)
               
            %    firstIteration = false;
            %    currentFrameProcessed = currentFrame;

            %else
                
                % Warp current frame
                %currentFrameWarped = interp2(pixelsX, pixelsY, currentFrame, ... 
                %    pixelsX + currentFlow(2), pixelsY + currentFlow(1), 'bilinear');
                %currentFrameWarped = interp2(currentFrame, ... 
                %    pixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx, 1), pixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx, 2), 'linear');
                %currentFrameProcessed = currentFrameWarped;
                
            %end
            
            % Compute temporal gradient and steppest descent update
            % parameters
            %windowWarped = interp2(currentFrame, ...
            %    windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx, 1), windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx, 2), 'linear');
            windowWarped = bilinearInterpolate(currentFrame, ...
               windowPixelsY + currentFlow(2) + initialOpticalFlow(currentPointIdx, 2), windowPixelsX + currentFlow(1) + initialOpticalFlow(currentPointIdx, 1));
            
            %gradientT = previousFrame - currentFrameProcessed;
            %gradientTWindow = gradientT(windowYRangeMin : windowYRangeMax, windowXRangeMin : windowXRangeMax);
            %gradientTWindow = previousFrame(windowYRangeMin : windowYRangeMax, windowXRangeMin : windowXRangeMax) - windowWarped;
            %gradientTWindow = interp2(previousFrame, windowPixelsX, windowPixelsY, 'linear') - windowWarped;
            gradientTWindow = bilinearInterpolate(previousFrame, windowPixelsY, windowPixelsX) - windowWarped;
            
            gradientTWindow = gradientTWindow(:);
            steppestDescentUpdate = [sum(gradientTWindow .* gradientXWindow .* weightingKernel); ... 
                sum(gradientTWindow .* gradientYWindow .* weightingKernel)];
            
            % Compute optical flow change
            %flowChange = inv(hessian) * steppestDescentUpdate;
            flowChange = hessian \ steppestDescentUpdate;
            currentFlow = currentFlow + flowChange;
            
            % Check stop condition
            if norm(flowChange) < stopThreshold
                
                break;
                
            end
            
        end
        
        % Save result
        opticalFlow(currentPointIdx, :) = currentFlow;
        
        % Advance to the next point
        currentPointIdx = currentPointIdx + 1;
        
    end
    
end