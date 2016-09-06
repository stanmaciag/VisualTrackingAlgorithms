function goodFeatures = findGoodFeatures(image, windowRadiousY, windowRadiousX, maxEigRetainThreshold, minThresholdDistance)
%FINDGOODFEATURES Extract good features to track from given image
% GOODFEATURES = FINDGOODFEATURES(IMAGE) 
% References
% ----------
% 1. Tomasi, C. & Kanade, T. Detection and Tracking of Point Features
% School of Computer Science Carnegie Mellon University, 1991
% 2. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature 
% tracker - Description of the algorithm Intel Corporation - Microprocessor
% Research Labs, 2000

    
    % Convert image to double type (avoid numerical error)
    image = double(image);
    
    % Convert window size variables to double type (required by Coder's
    % type assertion)
    windowRadiousY = double(windowRadiousY);
    windowRadiousX = double(windowRadiousX);
    
    % Compute image spatial gradients
    [gradientX, gradientY] = gradient(image);
    
    % Extend image and image gradients with zero-value pixels, border size is defined
    % by search window size - allows to compute Hessian matrix for every
    % actual pixel on the image
    borderY = zeros(size(image,1), windowRadiousX);
    borderX = zeros(windowRadiousY, size(image,2) + 2 * windowRadiousX);
    
    image = [borderX; borderY, image, borderY; borderX];
    gradientY = [borderX; borderY, gradientY, borderY; borderX];
    gradientX = [borderX; borderY, gradientX, borderY; borderX];
    
    minEigenval = zeros(size(image));
    
    for j = 1 + windowRadiousY : size(image, 1) - windowRadiousY
       
        for i = 1 + windowRadiousX : size(image, 2) - windowRadiousX
    
            
            gradientYWindow = gradientY(j - windowRadiousY : j + windowRadiousY, i - windowRadiousX : i + windowRadiousX);
            gradientXWindow = gradientX(j - windowRadiousY : j + windowRadiousY, i - windowRadiousX : i + windowRadiousX);
            gradientYWindow = gradientYWindow(:);
            gradientXWindow = gradientXWindow(:);

            % Compute Hessian (normalized)
            gradientMomentXX = sum(gradientXWindow.^2);
            gradientMomentXY = sum(gradientXWindow .* gradientYWindow);
            gradientMomentYY = sum(gradientYWindow.^2);
            hessian = [gradientMomentXX gradientMomentXY; gradientMomentXY gradientMomentYY];
            currentEigenvals = eig(hessian);
            
            minEigenval(j,i) = real(min(currentEigenvals));
            
            
        end
        
    end

    
    maxMinEigenval = max(max(minEigenval));
    
    isGoodFeature = zeros(size(image));
    
    for j = 1 + windowRadiousY : size(image, 1) - windowRadiousY
        
        for i = 1 + windowRadiousX : size(image, 2) - windowRadiousX
            
            if minEigenval(j,i) > maxEigRetainThreshold * maxMinEigenval
               
                isGoodFeature(j,i) = true;
                
            end
            
        end
        
    end
    
    [goodFeaturesY, goodFeaturesX] = find(isGoodFeature);
    
    neighbors = zeros(8,1);
    
    for n =  1 : size(goodFeaturesY, 1)

        neighbors(1) = minEigenval(goodFeaturesY(n) - 1, goodFeaturesX(n) - 1);
        neighbors(2) = minEigenval(goodFeaturesY(n) - 1, goodFeaturesX(n));
        neighbors(3) = minEigenval(goodFeaturesY(n) - 1, goodFeaturesX(n) + 1);
        neighbors(4) = minEigenval(goodFeaturesY(n), goodFeaturesX(n) - 1);
        neighbors(5) = minEigenval(goodFeaturesY(n), goodFeaturesX(n) + 1);
        neighbors(6) = minEigenval(goodFeaturesY(n) + 1, goodFeaturesX(n) - 1);
        neighbors(7) = minEigenval(goodFeaturesY(n) + 1, goodFeaturesX(n));
        neighbors(8) = minEigenval(goodFeaturesY(n) + 1, goodFeaturesX(n) + 1);

        if minEigenval(goodFeaturesY(n), goodFeaturesX(n)) <= max(max(neighbors))

            isGoodFeature(goodFeaturesY(n),goodFeaturesX(n)) = false;  

        end
                
                
    end

    [goodFeaturesY, goodFeaturesX] = find(isGoodFeature);
    
    neighborsTooCloseCount =  zeros(size(goodFeaturesY, 1), 1);
    neighborsTooCloseIdx = zeros(size(neighborsTooCloseCount, 1), 4 * minThresholdDistance * minThresholdDistance - 1);
       
    for n =  1 : size(goodFeaturesY, 1)

        for m =  1 : size(goodFeaturesY, 1)

            if n ~= m && abs(goodFeaturesY(m) - goodFeaturesY(n)) < minThresholdDistance && ...
                    abs(goodFeaturesX(m) - goodFeaturesX(n)) < minThresholdDistance

                neighborsTooCloseCount(n) = neighborsTooCloseCount(n) + 1;
                neighborsTooCloseIdx(n, neighborsTooCloseCount(n)) = m;

            end

        end
        
    end
    
    
    
    [maxTooClose, maxTooCloseIdx] = max(neighborsTooCloseCount);
    neighborsTooCloseIdx = neighborsTooCloseIdx(:, 1:maxTooClose);
    
    while maxTooClose > 0
    
        neighborsTooCloseCount(maxTooCloseIdx) = 0;
        isGoodFeature(goodFeaturesY(maxTooCloseIdx),goodFeaturesX(maxTooCloseIdx)) = false;

        for n = 1:size(neighborsTooCloseIdx,1)

            for m = 1:maxTooClose

                if neighborsTooCloseIdx(n,m) == maxTooCloseIdx

                    neighborsTooCloseCount(n) = neighborsTooCloseCount(n) - 1;
                    neighborsTooCloseIdx(n,:) = [neighborsTooCloseIdx(n, [1:m-1, m + 1:end]) 0];

                end

            end

        end

        [maxTooClose, maxTooCloseIdx] = max(neighborsTooCloseCount);
        neighborsTooCloseIdx = neighborsTooCloseIdx(:, 1:maxTooClose);
    
    end
    
    isGoodFeature = isGoodFeature(1 + windowRadiousY : size(image, 1) - windowRadiousY, ...
        1 + windowRadiousX : size(image, 2) - windowRadiousX);
    [goodFeaturesY, goodFeaturesX] = find(isGoodFeature);
    
    goodFeatures = [goodFeaturesY, goodFeaturesX];
    
end

