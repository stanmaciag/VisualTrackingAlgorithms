function proximityMap = proximityMap(positionMap, proximityRadious)

    [pointsI, pointsJ] = find(positionMap);
    proximityMap = zeros(size(positionMap) + 2 * proximityRadious);
    
    [x,y] = meshgrid(-proximityRadious:proximityRadious, -proximityRadious:proximityRadious);
    proximityPatch = sqrt(x.^2 +y.^2) <= proximityRadious;
    
    
    for i = 1:size(pointsI,1)
        
        minI = pointsI(i);
        maxI = pointsI(i) + 2 * proximityRadious;
        minJ = pointsJ(i);
        maxJ = pointsJ(i) + 2 * proximityRadious;
        
        proximityMap(minI : maxI, minJ : maxJ) = proximityMap(minI : maxI, minJ : maxJ) + proximityPatch;
        
    end
    
    proximityMap = proximityMap(proximityRadious + 1 : end-proximityRadious, proximityRadious + 1 : end - proximityRadious);

end

