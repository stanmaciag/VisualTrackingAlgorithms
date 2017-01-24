function transformedPoints = applyHomography(points, homographyMatrix)

    % Convert to homogenous coordinates
    points(:,3) = 1;
    points = points';
    
    % Apply homography
    transformedPoints = homographyMatrix * points;
    
    % Convert from homogenous coordinates
    transformedPoints(1,:) = transformedPoints(1,:) ./ transformedPoints(3,:);
    transformedPoints(2,:) = transformedPoints(2,:) ./ transformedPoints(3,:);
    transformedPoints = transformedPoints(1:2,:)';
    
end

