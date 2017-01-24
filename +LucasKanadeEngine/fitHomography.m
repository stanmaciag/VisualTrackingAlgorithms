function [homographyMatrix, bestInlinerIdx, distance] = fitHomography(previousPoints, currentPoints, threshold, homographyComputerFcnHandle)
% RANSAC
    %bestHomographyMatrix = zeros(3,3);
    bestInlinerIdx = false(size(previousPoints,1),1);
    bestDistance = zeros(size(previousPoints,1),1);
    N = inf;
    i = 1;
    
    while i < N
    
        idx = randperm(size(previousPoints,1), 4);
        currentHomographyMatrix = homographyComputerFcnHandle(previousPoints(idx,:), currentPoints(idx,:));

        transformedPoints = LucasKanadeEngine.applyHomography(previousPoints,currentHomographyMatrix);
        %inverseTransformedPoints = applyHomography(currentPoints, inv(currentHomographyMatrix));

        %currentDistance = sqrt((transformedPoints(:,1) - currentPoints(:,1)).^2 + (transformedPoints(:,2) - currentPoints(:,2)).^2) + ...
        %    sqrt((previousPoints(:,1) - inverseTransformedPoints(:,1)).^2 + (previousPoints(:,2) - inverseTransformedPoints(:,2)).^2);

        
        currentDistance = sqrt((transformedPoints(:,1) - currentPoints(:,1)).^2 + (transformedPoints(:,2) - currentPoints(:,2)).^2);
        inlinerIdx = currentDistance < threshold;

        if (nnz(inlinerIdx) > nnz(bestInlinerIdx))
           
            %bestHomographyMatrix = currentHomographyMatrix;
            bestInlinerIdx = inlinerIdx;
            bestDistance = currentDistance;
        
        end
        
        error = 1 - nnz(inlinerIdx) / size(inlinerIdx,1);
        N = log(1 - 0.99) / log(1 - (1 - error)^4);
        i = i + 1;
        
    end
    
    if nnz(bestInlinerIdx) >= 4
    
        %H = bestHomographyMatrix;
        homographyMatrix = homographyComputerFcnHandle(previousPoints(bestInlinerIdx,:),currentPoints(bestInlinerIdx,:));
        distance = bestDistance;
        
    else
        
        homographyMatrix = zeros(3,3);
        distance = zeros(size(previousPoints,1),1);
        
    end
    
    
end

