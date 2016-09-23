function [goodFeatures, minEigenvals] = findGoodFeatures(image, windowRadiousY, windowRadiousX, ...
    maxEigRetainThreshold, minThresholdDistance, initialFeatures)
%FINDGOODFEATURES Extract good features to track from given image
% GOODFEATURES = FINDGOODFEATURES(IMAGE) 
% References
% ----------
% 1. Tomasi, C. & Kanade, T. Detection and Tracking of Point Features
% School of Computer Science Carnegie Mellon University, 1991
% 2. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
% tracker - Description of the algorithm Intel Corporation - Microprocessor
% Research Labs, 2000
    
    % Find extract windows for given image
    [windowCenterX, windowCenterY] = meshgrid(windowRadiousX + 2 : size(image,2) - windowRadiousX - 1, windowRadiousY + 2:size(image,1) - windowRadiousY - 1);
    [windowPixelsX, windowPixelsY] = meshgrid(-windowRadiousX : windowRadiousX, -windowRadiousY : windowRadiousY);
    windowPixelsX = repmat(windowPixelsX, 1, 1, (size(image,1) - 2 * windowRadiousY - 2) * (size(image,2) - 2 * windowRadiousX - 2));
    windowPixelsY = repmat(windowPixelsY, 1, 1, (size(image,1) - 2 * windowRadiousY - 2) * (size(image,2) - 2 * windowRadiousX - 2));
    initialDsplX = permute(windowCenterX(:), [3, 2, 1]);
    initialDsplX = repmat(initialDsplX, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    initialDsplY = permute(windowCenterY(:), [3, 2, 1]);
    initialDsplY = repmat(initialDsplY, 2 * windowRadiousY + 1, 2 * windowRadiousX + 1, 1);
    
    windowPixelsX = windowPixelsX + initialDsplX;
    windowPixelsY = windowPixelsY + initialDsplY;
    
    % Compute spatial gradients for each window
    [gradientXWindow, gradientYWindow] = imageGradient_mex(image, windowPixelsY, windowPixelsX);
    
    % Compute Hessian matrix
    gradientMomentXX = sum(sum(gradientXWindow .* gradientXWindow));
    gradientMomentXY = sum(sum(gradientXWindow .* gradientYWindow));
    gradientMomentYY = sum(sum(gradientYWindow .* gradientYWindow));
    hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
    
    % Compute eigenvalues of Hessian
    hessianDet = (hessian(1,1,:) .* hessian(2,2,:) - hessian(1,2,:) .* hessian(2,1,:));
    hessianTr = hessian(1,1,:) + hessian(2,2,:);
    minEigenval = hessianTr/2 - sqrt(hessianTr.^2 / 4 - hessianDet);
    minEigenval = permute(minEigenval, [3, 2, 1]);
    minEigenval = reshape(minEigenval, size(windowCenterX));
    
    % Clear unused variables
    clear windowPixelsX windowPixelsY initialDsplX initialDsplY gradientMomentXX ...
        gradientMomentXY gradientMomentYY hessian hessianDet hessianTr;
    
    % Find maximum value of minimal eigenvalues of Hessian in the given
    % image
    maxMinEigenval = max(max(minEigenval));
    
    % Retain windows, which minimal eigenvalue is above certain given
    % percentage of global maxium minimal eigenvalue
    isGoodFeature = imag(minEigenval) == 0 & minEigenval > maxEigRetainThreshold * maxMinEigenval;
    
    % Reject features on image egdes
    isGoodFeature(1,:) = false;
    isGoodFeature(:,1) = false;
    isGoodFeature(end,:) = false;
    isGoodFeature(:,end) = false;
    
    [rows, ~] = size(isGoodFeature);
    
    % Find good features indices
    [goodFeaturesI,goodFeaturesJ]  = find(isGoodFeature);
    
    % Get eigenvalues of surrounding neihbors for each prospective good
    % feature
    eigNeighbor_x1y0 = minEigenval(goodFeaturesI + 1 + (goodFeaturesJ - 1) * rows);
    eigNeighbor_x1y1 = minEigenval(goodFeaturesI + 1 + (goodFeaturesJ - 1 + 1) * rows);
    eigNeighbor_x0y1 = minEigenval(goodFeaturesI + (goodFeaturesJ - 1 + 1) * rows);
    eigNeighbor_xn1y1 = minEigenval(goodFeaturesI - 1 + (goodFeaturesJ - 1 + 1) * rows);
    eigNeighbor_xn1y0 = minEigenval(goodFeaturesI - 1 + (goodFeaturesJ - 1) * rows);
    eigNeighbor_xn1yn1 = minEigenval(goodFeaturesI - 1 + (goodFeaturesJ - 1 - 1) * rows);
    eigNeighbor_x0yn1 = minEigenval(goodFeaturesI + (goodFeaturesJ - 1 - 1) * rows);
    eigNeighbor_x1yn1 = minEigenval(goodFeaturesI + 1 + (goodFeaturesJ - 1 - 1) * rows);
    
    % Suppress good features, which minimal eigenvals are not locally
    % maximal
    goodFeaturesIdx = find(isGoodFeature);
    isGoodFeature(goodFeaturesIdx) = minEigenval(goodFeaturesIdx) > eigNeighbor_x1y0 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_x1y1 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_x0y1 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_xn1y1 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_xn1y0 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_xn1yn1 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_x0yn1 & ...
        minEigenval(goodFeaturesIdx) > eigNeighbor_x1yn1;

    initialMap = false(size(isGoodFeature));
    
    if (nargin > 5)
        
        initialFeatures = initialFeatures(initialFeatures(:,1) >= windowRadiousX + 2 & ...
                initialFeatures(:,2) >= windowRadiousY + 2 & initialFeatures(:,1) <= size(image,2) - windowRadiousX - 1 & ...
                initialFeatures(:,2) <= size(image,1) - windowRadiousY - 1, :);
            
        initialFeatures(:,1) = initialFeatures(:,1) - (windowRadiousX + 2) + 1;
        initialFeatures(:,2) = initialFeatures(:,2) - (windowRadiousY + 2) + 1;
        initialMap(initialFeatures(:,2) + rows * (initialFeatures(:,1) - 1)) = true;
        
    end
    
    % Compute proximity map
    map = proximityMap_mex(isGoodFeature | initialMap, minThresholdDistance);
    featureProximity = map(isGoodFeature);
    maximumProxmitiy = max(featureProximity);
    
    % While distances between all features are not above given threshold
    while nnz(isGoodFeature) > 0 && maximumProxmitiy > 1
        
        % Reject features that cause most proximity conflicts
        maxIdx = featureProximity == maximumProxmitiy;
        isGoodFeature(goodFeaturesIdx(maxIdx)) = false;
        
        % Compute proximity map
        map = proximityMap_mex(isGoodFeature | initialMap, minThresholdDistance);
        goodFeaturesIdx = find(isGoodFeature);
        featureProximity = map(goodFeaturesIdx);
        maximumProxmitiy = max(featureProximity);

    end
 
    goodFeaturesIdx  = find(isGoodFeature);
    
    % Get final good features locations and their minimal eigenvals
    goodFeatures = [windowCenterX(goodFeaturesIdx) - windowRadiousX - 1, windowCenterY(goodFeaturesIdx)  - windowRadiousY - 1];
    minEigenvals = minEigenval(goodFeaturesIdx);
    
end

