function homographyMatrix = computeHomography(previousPoints, currentPoints)
% The Normalized Direct Linear Transformation algorithm
% Hartley, R. & Zisserman, A. Multiple View Geometry in Computer Vision
% p.91
    
    % Calculate scaling factor for the previous points set
    previousScale = sqrt(2) / ((1 / size(previousPoints,1)) * sum(sqrt((previousPoints(:,1) - ...
        mean(previousPoints(:,1))).^2 + (previousPoints(:,2) - mean(previousPoints(:,1))).^2)));

    % Compute similiratiy transformation matrix for the previous points set 
    previousSimilarityMatrix = [previousScale, 0, -previousScale * mean(previousPoints(:,1)); ...
        0, previousScale, -previousScale * mean(previousPoints(:,2)); ...
        0, 0, 1];
    
    % Convert previous points coordinates to homogenous
    previousPoints(:, 3) = 1;
    
    % Normalize previous points coordinates
    previousPoints = previousSimilarityMatrix * previousPoints';

    % Calculate scaling factor for the current points set
    currentScale = sqrt(2) / ((1 / size(currentPoints,1)) * sum(sqrt((currentPoints(:,1) ...
        - mean(currentPoints(:,1))).^2 + (currentPoints(:,2) - mean(currentPoints(:,2))).^2)));

    % Compute similiratiy transformation matrix for the current points set 
    currentSimilarityMatrix = [currentScale, 0, -currentScale * mean(currentPoints(:,1)); ...
        0, currentScale, -currentScale * mean(currentPoints(:,2)); ...
        0, 0, 1];
    
    % Convert previous points coordinates to homogenous
    currentPoints(:, 3) = 1;
    
    % Normalize previous points coordinates
    currentPoints = currentSimilarityMatrix * currentPoints';

    
    A = zeros(2 * size(previousPoints, 2), 9);
    
    A_row1 = [zeros(size(previousPoints,2),3), -previousPoints(1,:)', ...
        -previousPoints(2,:)', -ones(size(previousPoints,2), 1), ...
        currentPoints(2,:)' .* previousPoints(1,:)', ...
        currentPoints(2,:)' .* previousPoints(2,:)', ...
        currentPoints(2,:)'];
        
    
    A_row2 = [previousPoints(1,:)', previousPoints(2,:)', ones(size(previousPoints,2), 1), ...
        zeros(size(previousPoints,2),3), -currentPoints(1,:)' .* previousPoints(1,:)', ...
        -currentPoints(1,:)' .* previousPoints(2,:)', -currentPoints(1,:)'];
    
    A(1:2:end,:) = A_row1;
    A(2:2:end,:) = A_row2;
        
    % Obatain SVD of matrix A
    [~, ~, V] = svd(A);
   
    % Matrix H is determined by last column of V
    homographyMatrixNormalized = [V(1,9), V(2,9), V(3,9); V(4,9), V(5,9), V(6,9); V(7,9), V(8,9), V(9,9)];
    
    homographyMatrix = currentSimilarityMatrix \ homographyMatrixNormalized * previousSimilarityMatrix;
    
end

