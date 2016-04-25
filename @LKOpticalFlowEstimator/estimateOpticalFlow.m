function opticalFlow = estimateOpticalFlow(obj, pointsXY, previousFrame, currentFrame)
    
    % Suppress warnings about matrix singularity
    suppressedWarning1 = warning('error', 'MATLAB:nearlySingularMatrix'); %#ok<CTPCT>
    suppressedWarning2 = warning('error', 'MATLAB:singularMatrix'); %#ok<CTPCT>

    % Check input data size - should be matrix 2xN or Nx2
    if size(pointsXY,2) ~= 2
    
        pointsXY = pointsXY';
        
        if size(pointsXY,2) ~= 2
    
            pointsSizeErr = MException('LKOpticalFlowEstimator:inputDataSize', 'Input points must be given as a vector of pairs of coordinates (Nx2 or 2xN matrix)');
            throw(pointsSizeErr)
            
        end
        
    end
    
    % Check frames size consistency
    if size(previousFrame) ~= size(currentFrame)
        
        frameSizeErr = MException('LKOpticalFlowEstimator:inputDataSize', 'Input frames must have the same size');
        throw(frameSizeErr)
        
    end
    
    % Window size cannot be larger than frame size
    if size(previousFrame, 2) < obj.windowWidth || size(previousFrame, 1) < obj.windowHeight
        
        frameSizeErr = MException('LKOpticalFlowEstimator:inputDataSize', 'Selected window is larger than input frames');
        throw(frameSizeErr)
        
    end
    
    % Initialize output data fields
    if obj.detailedOutput
    
        opticalFlow.finalEstimation = zeros(size(pointsXY));
        opticalFlow.points = pointsXY;
        
        % Allocate space for all possible estimation steps
        estimationStep = struct('point', zeros(2,1), 'estimations', zeros(obj.maxIterations, 2), 'flowChange', ...
            zeros(obj.maxIterations, 2), 'computationTime', zeros(obj.maxIterations, 1), 'pointComputationTime', 0);
        opticalFlow.estimationSteps = repmat(estimationStep, size(pointsXY, 1), 1);
        
    else
        
        opticalFlow = zeros(size(pointsXY));
    
    end
    
    
    if obj.detailedOutput
        
        % Start measuring entire computation time
        tic;
        
    end
    
    % Coverting to grayscale if RGB
    if ~ismatrix(previousFrame)
        
        previousFrame = rgb2gray(previousFrame);
        if obj.showWarnings
            warning('LucasKanadeOpticalFlow:imageColorspace', 'Converting previous frame to grayscale');
        end
        
    end
    
    if ~ismatrix(currentFrame)
        
        currentFrame = rgb2gray(currentFrame);
        if obj.showWarnings
            warning('LucasKanadeOpticalFlow:imageColorspace', 'Converting current frame to grayscale');
        end
        
    end
    
    % Convert images to double type
    previousFrame = double(previousFrame);
    currentFrame = double(currentFrame);
    
    % All pixels coordinates
    [pixelsX, pixelsY] = meshgrid(1:size(previousFrame, 2), 1:size(previousFrame, 1));
 
    % Filter previous frame depending on choosen filter type 
    if isequal(obj.imageFilter, 'gaussian')
        
        previousFrame = imgaussfilt(previousFrame, obj.gaussianSigma, 'FilterSize', obj.filterSize, 'FilterDomain', 'spatial');
    
    elseif isequal(obj.imageFilter, 'median')
       
        previousFrame = medfilt2(previousFrame, obj.filterSize);
        
    end
        
    % Compute image spatial gradients, gradientType cell to string
    % conversion
    [gradientX, gradientY] = imgradientxy(previousFrame, obj.gradientType{1});
    
    % Initialize main loop
    currentPointIdx = 1;
    
    while currentPointIdx <= size(pointsXY,1)
       
        if obj.showMessages
        
            msg = sprintf('Point: (%d, %d)', pointsXY(currentPointIdx, 1), pointsXY(currentPointIdx, 2));
            disp(msg);
            
        end
        
        if obj.detailedOutput
                
            opticalFlow.estimationSteps(currentPointIdx).point = pointsXY(currentPointIdx,:);
            pointStartTime = tic;
            
        end
        
        % Initialize current point flow computation
        currentFlow = [0; 0];
        firstIteration = true;
        
        % Determine current point window
        windowXRangeMin = pointsXY(currentPointIdx, 1) - obj.windowRadiousX;
        windowXRangeMax = pointsXY(currentPointIdx, 1) + obj.windowRadiousX;
        windowYRangeMin = pointsXY(currentPointIdx, 2) - obj.windowRadiousY;
        windowYRangeMax = pointsXY(currentPointIdx, 2) + obj.windowRadiousY;
        gradientXWindow = gradientX(windowXRangeMin : windowXRangeMax, windowYRangeMin : windowYRangeMax);
        gradientYWindow = gradientY(windowXRangeMin : windowXRangeMax, windowYRangeMin : windowYRangeMax);
        gradientXWindow = gradientXWindow(:);
        gradientYWindow = gradientYWindow(:);
        
        % Compute Hessian
        gradientMomentXX = sum(gradientXWindow.^2);
        gradientMomentXY = sum(gradientXWindow .* gradientYWindow);
        gradientMomentYY = sum(gradientYWindow.^2);
        hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
        
        % Estimate and refine optical flow for current point
        for i = 1:obj.maxIterations
            
            if obj.detailedOutput

                iterStartTime = tic;
            
            end
            
            % First estimation does not need interpolation (previous
            % estimation is assumed to be zero - no warp)
            if (firstIteration)
               
                firstIteration = false;
                
                % Filter current frame depending on choosen filter type
                if isequal(obj.imageFilter, 'gaussian')
                    currentFrameProcessed = imgaussfilt(currentFrame, obj.gaussianSigma, 'FilterSize', obj.filterSize, 'FilterDomain', 'spatial');
                elseif isequal(obj.imageFilter, 'median')
                    currentFrameProcessed = medfilt2(currentFrame, obj.filterSize);
                else
                    currentFrameProcessed = currentFrame;
                end

            else
                
                % Warp current frame
                currentFrameWarped = interp2(pixelsX, pixelsY, currentFrame, pixelsX + currentFlow(1), pixelsY + currentFlow(2), 'bilinear');
                
                % Filter current frame depending on choosen filter type
                if isequal(obj.imageFilter, 'gaussian')
                    currentFrameProcessed = imgaussfilt(currentFrameWarped, obj.gaussianSigma, 'FilterSize', obj.filterSize, 'FilterDomain', 'spatial');
                elseif isequal(obj.imageFilter, 'median')
                    currentFrameProcessed = medfilt2(currentFrameWarped, obj.filterSize);
                else    
                    currentFrameProcessed = currentFrameWarped;
                end
            
            end
            
            % Compute temporal gradient and steppest descent update
            % parameters
            gradientT = previousFrame - currentFrameProcessed;
            gradientTWindow = gradientT(windowXRangeMin : windowXRangeMax, windowYRangeMin : windowYRangeMax);
            gradientTWindow = gradientTWindow(:);
            steppestDescentUpdate = [sum(gradientTWindow .* gradientXWindow); sum(gradientTWindow .* gradientYWindow)];

            % Compute optical flow estimation change
            try
                
                %flowChange = (steppestDescentUpdate \ hessian)';
                flowChange = inv(hessian) * steppestDescentUpdate;
                currentFlow = currentFlow + flowChange;
                
            catch ME
               
                if obj.showWarnings
                    rethrow(ME)
                end
                
                flowChange = [NaN; NaN];
                
            end
                
                
            if obj.showMessages
        
                msg = sprintf('  Iteration: %d\n    Optical flow estimation: (%f, %f)\n    Stop condition value: %f', i, currentFlow(1), currentFlow(2), norm(flowChange));
                disp(msg);
            
            end
            
            if obj.detailedOutput
                
                opticalFlow.estimationSteps(currentPointIdx).estimations(i, :) = currentFlow;
                opticalFlow.estimationSteps(currentPointIdx).flowChange(i, :) = flowChange;
                opticalFlow.estimationSteps(currentPointIdx).computationTime(i) = toc(iterStartTime);
                
            end
            
            % Check stop condition
            if norm(flowChange) < obj.stopThreshold
                
                if obj.detailedOutput
                    opticalFlow.estimationSteps(currentPointIdx).estimations = opticalFlow.estimationSteps(currentPointIdx).estimations(1:i, :);
                    opticalFlow.estimationSteps(currentPointIdx).flowChange = opticalFlow.estimationSteps(currentPointIdx).flowChange(1:i, :);
                    opticalFlow.estimationSteps(currentPointIdx).computationTime = opticalFlow.estimationSteps(currentPointIdx).computationTime(1:i, :);
                end
                
                break;
            end
            
        end
        
        if obj.showMessages
           
            msg = sprintf('\0');
            disp(msg);
            
        end
   
        % Save the final result
        if obj.detailedOutput
            
            opticalFlow.finalEstimation(currentPointIdx, 1) = currentFlow(1);
            opticalFlow.finalEstimation(currentPointIdx, 2) = currentFlow(2);
            opticalFlow.estimationSteps(currentPointIdx).pointComputationTime = toc(pointStartTime);
            
        else
            
            opticalFlow(currentPointIdx, 1) = currentFlow(1);
            opticalFlow(currentPointIdx, 2) = currentFlow(2);
            
        end
        
        
        % Advance to the next point
        currentPointIdx = currentPointIdx + 1;
        
    end
   
     if (obj.detailedOutput)
        
        % Read entire computation time
        opticalFlow.entireComputaionTime = toc;

    end
    
    % Restore suppressed warnings
    warning(suppressedWarning1);
    warning(suppressedWarning2);

    
end