function opticalFlow = pyramidalLucasKanade(previousFrame, currentFrame, ...
    pointsToTrack, windowRadiousY, windowRadiousX, maxIterations, ...
    stopThreshold, pyramidDepth, weightingKernel)
%PYRAMIDALLUCASKANADE Summary of this function goes here
%   Detailed explanation goes here
% References
% ----------
% 1. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
% tracker - Description of the algorithm Intel Corporation - Microprocessor
% Research Labs, 2000

    if (nargin < 8)
       
        pyramidDepth = 3;
        
    end
    
    if (nargin < 9)
       
        % Set uniform weight for all pixels in the window
        weightingKernel = ones(2 * windowRadiousY + 1, 2 * windowRadiousX + 1) / ...
            ((2 * windowRadiousY + 1) * (2 * windowRadiousX + 1));
        
    end
    
    pyramidDepth = double(pyramidDepth);
    
    previousPyramid = zeros(size(previousFrame, 1), size(previousFrame, 2), pyramidDepth + 1);
    currentPyramid = zeros(size(currentFrame, 1),  size(currentFrame, 2), pyramidDepth + 1);
    previousPyramid(:,:,1) = previousFrame;
    currentPyramid(:,:,1) = currentFrame;
    
    L = 1;
    
    while L < pyramidDepth + 1
    
        previousSize = size(previousFrame) / (2 ^ (L - 1));
        L = L + 1;
        currentSize = size(previousFrame) / (2 ^ (L - 1));
        previousPyramid(1:currentSize(1),1:currentSize(2),L) = impyramid(previousPyramid(1:previousSize(1), 1:previousSize(2), L - 1), 'reduce');
        currentPyramid(1:currentSize(1),1:currentSize(2),L) = impyramid(currentPyramid(1:previousSize(1), 1:previousSize(2), L - 1), 'reduce');
        
    end

    pyramidGuessOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);
    levelOpticalFlow = zeros([size(pointsToTrack), pyramidDepth + 1]);
    
    for L = pyramidDepth + 1 : -1 : 1
        
        currentSize = size(previousFrame) / (2 ^ (L - 1));
        previousPyramidCurrentLevel = previousPyramid(1:currentSize(1), 1:currentSize(2), L);
        currentPyramidCurrentLevel = currentPyramid(1:currentSize(1), 1:currentSize(2), L);
        
        levelPointsToTrack = pointsToTrack ./ (2 ^ (L - 1));
        
        levelOpticalFlow(:, :, L) = iterativeLucasKanade(previousPyramidCurrentLevel, ...
            currentPyramidCurrentLevel, levelPointsToTrack, windowRadiousY, ...
            windowRadiousX, maxIterations, stopThreshold, weightingKernel, pyramidGuessOpticalFlow(:, :, L));
        
        if L > 1
            pyramidGuessOpticalFlow(:, :, L - 1) = 2 * (pyramidGuessOpticalFlow(:, :, L) + levelOpticalFlow(:, :, L));
        end
        
    end
    
    opticalFlow = levelOpticalFlow(:, :, 1) + pyramidGuessOpticalFlow(:, :, 1);
    
end

