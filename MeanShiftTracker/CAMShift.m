function [currentPosition, candidateModel] = CAMShift(currentFrame, targetModel, ...
    previousPosition, maxIterations, stopThreshold, idxMapFcnHandle)

    %currentFrame = im2uint8(currentFrame);
    range = getrangefromclass(currentFrame);
    
    currentFrameBinIdxMap = idxMapFcnHandle(double(currentFrame), targetModel.histogramBins, range(1), range(2));
    probabilityBackProjection = range(2) * targetModel.histogram(currentFrameBinIdxMap) / max(targetModel.histogram);

    currentPosition = previousPosition;
    candidateModel = targetModel;
    
    %imshow(uint8(probabilityBackProjection));
    %imshow(probabilityBackProjection);
    %hold on;
    %plot(currentPosition(2),currentPosition(1),'rx','LineWidth',2);
    
    for i = 1:maxIterations
    
        searchWindow = [currentPosition(1) - candidateModel.verticalRadious : currentPosition(2) + candidateModel.verticalRadious, ...
            currentPosition(2) - candidateModel.horizontalRadious : currentPosition(2) + candidateModel.horizontalRadious];

        searchWindowMinY = currentPosition(1) - candidateModel.verticalRadious;
        searchWindowMaxY = currentPosition(1) + candidateModel.verticalRadious;
        searchWindowMinX = currentPosition(2) - candidateModel.horizontalRadious;
        searchWindowMaxX = currentPosition(2) + candidateModel.horizontalRadious;

        [M00, M10, M01, M20, M02, M11] = imageMoments(probabilityBackProjection(searchWindowMinY : searchWindowMaxY, searchWindowMinX : searchWindowMaxX));

        newPosition(1) = M01 / M00;
        newPosition(2) = M10 / M00;

        newPosition(1) = newPosition(1) + searchWindowMinY;
        newPosition(2) = newPosition(2) + searchWindowMinX;
        
        newWindowSize = 2 * sqrt(M00 / range(2));
        
        coeff = newWindowSize / (searchWindowMaxX - searchWindowMinX);
        
        candidateModel.verticalRadious = round(candidateModel.verticalRadious * coeff);
        candidateModel.horizontalRadious = round(candidateModel.horizontalRadious * coeff);
        
        currentPosition = round(newPosition);
        %plot(currentPosition(2),currentPosition(1),'rx','LineWidth',2);
        %rectangle('Position', [searchWindowMinX, searchWindowMinY, searchWindowMaxX - searchWindowMinX, searchWindowMaxY - searchWindowMinY], 'EdgeColor', 'red', 'LineWidth',2);
        
        if norm(currentPosition - newPosition) < stopThreshold
            break;
        end
   
    end
    
end

