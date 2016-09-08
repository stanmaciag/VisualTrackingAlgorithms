function [currentPosition, similarityCoeff, candidateModel] = meanShift(currentFrame, previousPosition, ...
    targetModel, windowBandwidth, windowProfileFcnHandle, windowDProfileFcnHandle, maxIterations, stopThreshold, idxMapFcnHandle, ...
    histogramFcnHandle, pixelWeightsFcnHandle)
% Dorin Comaniciu and Visvanathan Ramesh and Peter Meer - Kernel-based object tracking
% Dorin Comaniciu and Visvanathan Ramesh and Peter Meer - Real-time tracking of non-rigid objects using mean shift
    
    % Get pixel value range from current frame class
    range = getrangefromclass(currentFrame);
    
    % Compute kernel matrix
    [kernelX, kernelY] = meshgrid(-windowBandwidth : 1/targetModel.horizontalRadious : ...
        windowBandwidth, -windowBandwidth : 1/targetModel.verticalRadious : windowBandwidth);
    kernel = windowProfileFcnHandle(sqrt(((kernelX/windowBandwidth).^2 + (kernelY/windowBandwidth).^2)).^2);
    kernelDerivative = windowDProfileFcnHandle(sqrt(((kernelX/windowBandwidth).^2 + (kernelY/windowBandwidth).^2)).^2);
    
    % Initialize position in current frame with previous position
    currentPosition = previousPosition;
    
    % Iterate while not converged or until iterations limit is reached
    for i = 1:maxIterations
 
        % Get extremal coordinates of search window
        roiMinY = currentPosition(1) - round(targetModel.verticalRadious * windowBandwidth);
        roiMaxY = currentPosition(1) + round(targetModel.verticalRadious * windowBandwidth);
        roiMinX = currentPosition(2) - round(targetModel.horizontalRadious * windowBandwidth);
        roiMaxX = currentPosition(2) + round(targetModel.horizontalRadious * windowBandwidth);
        
        % Adjust ROI size to fit kernel
        roiMaxY = roiMaxY - (roiMaxY - roiMinY + 1 - size(kernel,1));
        roiMaxX = roiMaxX - (roiMaxX - roiMinX + 1 - size(kernel,2));
        
        % Compute sizes of necessary zeros-padding areas - asserts proper
        % operation when selected search window outreaches calculation
        % region
        roiMinYPad = max(1 - roiMinY, 0);
        roiMaxYPad = max(roiMaxY - size(currentFrame,1), 0);
        roiMinXPad = max(1 - roiMinX, 0);
        roiMaxXPad = max(roiMaxX - size(currentFrame,2), 0);
        
         % Get target ROI from current frame (resistant to
        % outreaching image boundaries)
        roi = zeros(roiMaxY - roiMinY + 1, roiMaxX - roiMinX + 1, size(currentFrame,3));    
        roi(roiMinYPad + 1 : size(roi,1) - roiMaxYPad, roiMinXPad + 1 : size(roi,2) - roiMaxXPad, :) = double(currentFrame(roiMinY + roiMinYPad : roiMaxY - roiMaxYPad, roiMinX + roiMinXPad : roiMaxX - roiMaxXPad,:));
        
        % Compute bin index map and weighted normalized histogram of the target ROI image
        candidateIdxMap = idxMapFcnHandle(roi, targetModel.histogramBins,  range(1), range(2));
        candidateHistogram = histogramFcnHandle(roi, kernel, candidateIdxMap, targetModel.histogramBins);
        
        % Compute pixel weights
        weightsMap = pixelWeightsFcnHandle(targetModel.histogram, candidateHistogram, kernel, candidateIdxMap);
        
        % Calculate sum of weights
        weightsMapSum = sum(sum(weightsMap.*-kernelDerivative));
        
        % Get grid of global ROI coordinates
        [roiXgrid, roiYgrid] = meshgrid(roiMinX:roiMaxX, roiMinY:roiMaxY);
        
        % Calculate new position
        newPosition = round([sum(sum(roiYgrid.*weightsMap.*-kernelDerivative))/weightsMapSum, sum(sum(roiXgrid.*weightsMap.*-kernelDerivative))/weightsMapSum]);
        
        % Check convergence condition - stop if position shift is smaller
        % than given threshold
        if norm(currentPosition - newPosition) < stopThreshold
            break;
        end

        % Set current position as new position (rounded to integer values)
        currentPosition = newPosition;
        
    end
    
    % Update candidate model
    candidateModel.verticalRadious = targetModel.verticalRadious;
    candidateModel.horizontalRadious = targetModel.horizontalRadious;
    candidateModel.histogramBins = targetModel.histogramBins; 
    candidateModel.histogram = candidateHistogram;
    candidateModel.binIdxMap = candidateIdxMap;
    
    % Calculate current similarity coefficient as Bhattacharyya coefficient
    similarityCoeff = sum(sqrt(candidateModel.histogram.*targetModel.histogram));
    
end