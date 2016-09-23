function [currentPosition, candidateModel, orientation, dimensions] = CAMShift(currentFrame, targetModel, ...
    previousPosition, calculationBandwidth, maxIterations, stopThreshold)
% Object tracking using CamShift algorithm and multiple quantized feature
% spaces - John G. Allen and Richard Y. D. Xu and Jesse S. Jin
% Real time face and object tracking as a component of a perceptual user
% interface - Gary R. Bradski

    %currentFrame = double(currentFrame);

    % Get pixel value range from current frame class
    range = getrangefromclass(currentFrame);
    
    % Initialize candidate model with target model
    candidateModel = targetModel;
    
    %calculationRegionMinY = max(1, previousPosition(1) - round(candidateModel.verticalRadious * calculationBandwidth));
    %calculationRegionMaxY = min(size(currentFrame,1), previousPosition(1) + round(candidateModel.verticalRadious * calculationBandwidth));
    %calculationRegionMinX = max(1, previousPosition(2) - round(candidateModel.horizontalRadious * calculationBandwidth));
    %calculationRegionMaxX = min(size(currentFrame,2), previousPosition(2) + round(candidateModel.horizontalRadious * calculationBandwidth));
    
    % Get extremal coordinates of calculation region (limited by image
    % boundaries) - calculation region is square, its size is based on
    % larger candidate's model radious and bandwidth
    maxRadious = max(candidateModel.verticalRadious, candidateModel.horizontalRadious);
    calculationRegionMinY = max(1, previousPosition(1) - round(maxRadious * calculationBandwidth));
    calculationRegionMaxY = min(size(currentFrame,1), previousPosition(1) + round(maxRadious * calculationBandwidth));
    calculationRegionMinX = max(1, previousPosition(2) - round(maxRadious * calculationBandwidth));
    calculationRegionMaxX = min(size(currentFrame,2), previousPosition(2) + round(maxRadious * calculationBandwidth));
    
    % Compute bin index map for calculation region
    currentFrameBinIdxMap = binIdxMap_mex(double(currentFrame(calculationRegionMinY:calculationRegionMaxY, ...
        calculationRegionMinX: calculationRegionMaxX, :)), targetModel.histogramBins, range(1), range(2));
    
    % Back-project target histogram using current bin index map (compute
    % pixels probabilities of membership to target model)
    probabilityBackProjection = range(2) * targetModel.histogram(currentFrameBinIdxMap) / max(targetModel.histogram);
    
    % Initialize position in current frame with previous position expressed
    % in local calcalution region coordinates
    currentPosition = previousPosition - [calculationRegionMinY, calculationRegionMinX];
    
    % Get grid of local calculation region coordinates
    %[coordsHorizontal, coordsVertical] = meshgrid(1 : 2 * candidateModel.horizontalRadious + 1, ... 
    %   1 : 2 * candidateModel.verticalRadious + 1);
    [coordsHorizontal, coordsVertical] = meshgrid(1 : 2 * maxRadious + 1, ... 
       1 : 2 * maxRadious + 1);
    
    % Iterate while not converged or until iterations limit is reached
    for i = 1:maxIterations
        
        % Get extremal coordinates of search window
        %searchWindowMinY = currentPosition(1) - candidateModel.verticalRadious;
        %searchWindowMaxY = currentPosition(1) + candidateModel.verticalRadious;
        %searchWindowMinX = currentPosition(2) - candidateModel.horizontalRadious;
        %searchWindowMaxX = currentPosition(2) + candidateModel.horizontalRadious;
        searchWindowMinY = currentPosition(1) - maxRadious;
        searchWindowMaxY = currentPosition(1) + maxRadious;
        searchWindowMinX = currentPosition(2) - maxRadious;
        searchWindowMaxX = currentPosition(2) + maxRadious;

        % Compute sizes of necessary zeros-padding areas - asserts proper
        % operation when selected search window outreaches calculation
        % region
        searchWindowMinYPad = max(1 - searchWindowMinY, 0);
        searchWindowMaxYPad = max(searchWindowMaxY - size(probabilityBackProjection,1), 0);
        searchWindowMinXPad = max(1 - searchWindowMinX, 0);
        searchWindowMaxXPad = max(searchWindowMaxX - size(probabilityBackProjection,2), 0);
        
        % Get target ROI from probability back projection map (resistant to
        % outreaching calculation region)
        roi = zeros(searchWindowMaxY - searchWindowMinY + 1, searchWindowMaxX - searchWindowMinX + 1);    
        roi(searchWindowMinYPad + 1 : size(roi,1) - searchWindowMaxYPad, searchWindowMinXPad + 1 : size(roi,2) - searchWindowMaxXPad) = ...
            probabilityBackProjection(searchWindowMinY + searchWindowMinYPad : searchWindowMaxY - searchWindowMaxYPad, ...
            searchWindowMinX + searchWindowMinXPad : searchWindowMaxX - searchWindowMaxXPad);

        % Calculate zero and first order statistical moments of target ROI
        M00 = sum(sum(roi));
        M10 = sum(sum(roi.*coordsHorizontal));
        M01 = sum(sum(roi.*coordsVertical));
        
        % Terminate if zero order moment is null (would cause error,
        % also indicates losing the target - all probabilites are zero, 
        % this case is extremely rare)
        if M00 == 0
            
            break;
        
        end
        
        % Calculate new positon of centroid
        newPosition(1) = M01 / M00;
        newPosition(2) = M10 / M00;

        % Shfit new position to global coordinate system
        newPosition(1) = newPosition(1) + searchWindowMinY;
        newPosition(2) = newPosition(2) + searchWindowMinX;
    
        % Check convergence condition - stop if position shift is smaller
        % than given threshold
        if norm(currentPosition - round(newPosition)) < stopThreshold
            currentPosition = round(newPosition);
            break;
        end
        
        % Set current position as new position (rounded to integer values)
        currentPosition = round(newPosition);
   
    end
    
    % If tracking successful
    if M00 > 0
        
        % Calculate new search window size
        newWindowSize = 2 * sqrt(M00 / range(2));

        % Calculate window size change coefficient 
        sizeCoeff = newWindowSize / (searchWindowMaxX - searchWindowMinX);
        
        candidateModel.verticalRadious = round(candidateModel.verticalRadious * sizeCoeff);
        candidateModel.horizontalRadious = round(candidateModel.horizontalRadious * sizeCoeff);
        
        % Set new search window size if bigger than given minimal value -
        % prevents from window disappearing
        %newHorizontalRadious = round(candidateModel.horizontalRadious * sizeCoeff);     
        %if (newHorizontalRadious > minHorizontalRadious)
        
        %    candidateModel.verticalRadious = round(candidateModel.verticalRadious * sizeCoeff);
        %    candidateModel.horizontalRadious = newHorizontalRadious;
        
        %end
        
        % Calculate second order statistical moments of target ROI
        M20 = sum(sum(roi.*coordsHorizontal.^2));
        M02 = sum(sum(roi.*coordsVertical.^2));
        M11 = sum(sum(roi.*coordsHorizontal.*coordsVertical));
        
        % Calculate subsidiary coefficients
        a = M20 / M00 - (M10 / M00) ^ 2;
        b = 2 * (M11 / M00 - M10 / M00 * M01 / M00);
        c = M02 / M00 - (M01 / M00) ^ 2;
        
        % Calculate target orientation and radiouses in vertical and
        % horizontal direciton
        orientation = 0.5 * atan(b / (a - c));
        dimensions(2) = 2 * round(sqrt(((a + c) + sqrt(b ^ 2 + (a - c) ^ 2))/2)) + 1;
        dimensions(1) = 2 * round(sqrt(((a + c) - sqrt(b ^ 2 + (a - c) ^ 2))/2)) + 1;
        
    else
        
        % Set target orientation and radiouses to zero (tracking failed)
        orientation = 0;
        dimensions = [0, 0];
        
    end
    
    % Shift current position to global coordinate system
    currentPosition = currentPosition + [calculationRegionMinY, calculationRegionMinX];
        
end

