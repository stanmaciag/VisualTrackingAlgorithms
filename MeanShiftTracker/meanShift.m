function [currentPosition, similarityCoeff, candidateModel] = meanShift(currentFrame, previousPosition, ...
    targetModel, windowBandwidth, windowProfileFcnHandle, maxIterations, stopThreshold, idxMapFcnHandle, ...
    histogramFcnHandle, pixelWeightsFcnHandle)
% Dorin Comaniciu and Visvanathan Ramesh and Peter Meer - Kernel-based object tracking
% Dorin Comaniciu and Visvanathan Ramesh and Peter Meer - Real-time tracking of non-rigid objects using mean shift
    
    range = getrangefromclass(currentFrame);
    
    [kernelX, kernelY] = meshgrid(-windowBandwidth : 1/targetModel.horizontalRadious : ...
        windowBandwidth, -windowBandwidth : 1/targetModel.verticalRadious : windowBandwidth);
    kernel = windowProfileFcnHandle(sqrt(((kernelX/windowBandwidth).^2 + (kernelY/windowBandwidth).^2)).^2);

    currentPosition = previousPosition;
    
 
    for i = 1:maxIterations
 
        roiMinY = currentPosition(1) - round(targetModel.verticalRadious * windowBandwidth);
        roiMaxY = currentPosition(1) + round(targetModel.verticalRadious * windowBandwidth);
        roiMinX = currentPosition(2) - round(targetModel.horizontalRadious * windowBandwidth);
        roiMaxX = currentPosition(2) + round(targetModel.horizontalRadious * windowBandwidth);
        
        roiMaxY = roiMaxY - (roiMaxY - roiMinY + 1 - size(kernel,1));
        roiMaxX = roiMaxX - (roiMaxX - roiMinX + 1 - size(kernel,2));
        
        roiMinYPad = max(1 - roiMinY, 0);
        roiMaxYPad = max(roiMaxY - size(currentFrame,1), 0);
        roiMinXPad = max(1 - roiMinX, 0);
        roiMaxXPad = max(roiMaxX - size(currentFrame,2), 0);
        
        roi = zeros(roiMaxY - roiMinY + 1, roiMaxX - roiMinX + 1, size(currentFrame,3));    
        roi(roiMinYPad + 1 : size(roi,1) - roiMaxYPad, roiMinXPad + 1 : size(roi,2) - roiMaxXPad, :) = double(currentFrame(roiMinY + roiMinYPad : roiMaxY - roiMaxYPad, roiMinX + roiMinXPad : roiMaxX - roiMaxXPad,:));
        
        %[candidateHistogram, candidateIdxMap] = mexNormalizedWeightedHistogram(roi, kernel, targetModel.histogramBins, range(1), range(2));
        %[candidateHistogram, candidateIdxMap] = computeWeightedHistogram(roi, kernel, [16; 16; 16], range(1), range(2));
        candidateIdxMap = idxMapFcnHandle(roi, targetModel.histogramBins,  range(1), range(2));
        candidateHistogram = histogramFcnHandle(roi, kernel, candidateIdxMap, targetModel.histogramBins);
        
        weightsMap = pixelWeightsFcnHandle(targetModel.histogram, candidateHistogram, kernel, candidateIdxMap);
        
        weightsMapSum = sum(sum(weightsMap));
        
        [roiXgrid, roiYgrid] = meshgrid(roiMinX:roiMaxX, roiMinY:roiMaxY);
        
        newPosition = round([sum(sum(roiYgrid.*weightsMap))/weightsMapSum, sum(sum(roiXgrid.*weightsMap))/weightsMapSum]);
        
        if norm(currentPosition - newPosition) < stopThreshold
            break;
        end

        currentPosition = newPosition;
        
    end
    
    
    
    candidateModel.verticalRadious = targetModel.verticalRadious;
    candidateModel.horizontalRadious = targetModel.horizontalRadious;
    candidateModel.histogramBins = targetModel.histogramBins; 
    candidateModel.histogram = candidateHistogram;
    candidateModel.binIdxMap = candidateIdxMap;
    
    similarityCoeff = sum(sqrt(candidateModel.histogram.*targetModel.histogram));
    
end