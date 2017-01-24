function H = computeAffine(previousPoints, currentPoints)
% The Gold Standard Algorithm for estimating an affine homography
% Hartley, R. & Zisserman, A. Multiple View Geometry in Computer Vision
% p.130
% Solem, J. E., Programming Computer Vision with Python - Tools and algorithms for
% analyzing images 
% p.56

    previousPoinsMean = mean(previousPoints);
    previousPointsMaxStd = max(std(previousPoints));
    
    C1 = [1/previousPointsMaxStd, 0, -previousPoinsMean(1)/previousPointsMaxStd;
        0, 1/previousPointsMaxStd, -previousPoinsMean(2)/previousPointsMaxStd;
        0, 0, 1];
    
    previousPoints(:,3) = 1;
    previousPoints = C1 * previousPoints';
    
    %previousPoints(:,1) = previousPoints(:,1) - previousPoinsMean(1);
    %previousPoints(:,2) = previousPoints(:,2) - previousPoinsMean(2);
    
    currentPointsMean = mean(currentPoints);
    C2 = [1/previousPointsMaxStd, 0, -currentPointsMean(1)/previousPointsMaxStd;
        0, 1/previousPointsMaxStd, -currentPointsMean(2)/previousPointsMaxStd;
        0, 0, 1];
    %currentPoints(:,1) = currentPoints(:,1) - currentPointsMean(1);
    %currentPoints(:,2) = currentPoints(:,2) - currentPointsMean(2);
    currentPoints(:,3) = 1;
    currentPoints = C2 * currentPoints';
    
    A = [previousPoints(1,:)', previousPoints(2,:)', currentPoints(1,:)', currentPoints(2,:)'];
    
    % Obatain SVD of matrix A
    [~, ~, V] = svd(A);
    
    V1V2 = [V(:,1), V(:,2)];
    
    B = V1V2(1:2,1:2);
    C = V1V2(3:4,1:2);
    
    %H2x2 = C * pinv(B);
    
    %T = [H2x2, H2x2 * [previousPoinsMean(1); previousPoinsMean(2)] - [currentPointsMean(1); currentPointsMean(2)]; ...
    %    zeros(2,2), ones(2,1)];
    
    H = [C * pinv(B), zeros(2,1); 0, 0, 1];
    
    H = C2 \ H * C1;
    
end

