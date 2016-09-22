function [targetModel, backgroundModel] = ratioHistogramModel(image, targetRoi, windowProfileFcnHandle, backgroundProfileFcnHandle, ...
    histogramBins, bandwidth, scalingFactor, idxMapFcnHandle, histogramFcnHandle)

    image = double(image);

    % Get target ROI part from the whole image
    targetImage = image(targetRoi(2) : targetRoi(2) + targetRoi(4), targetRoi(1) : targetRoi(1) + targetRoi(3), :);

    % Compute permissible verical and horizontal radious of the target
    % (must be odd)
    targetModel.verticalRadious = ceil(size(targetImage, 1) / 2) - 1;
    targetModel.horizontalRadious = ceil(size(targetImage, 2) / 2) - 1;
    
    % Compute consistentely-sized kernel matrix 
    [x,y] = meshgrid(-1 : 1/targetModel.horizontalRadious : 1, -1 : 1/targetModel.verticalRadious : 1);
    targetKernel = windowProfileFcnHandle(sqrt(x.^2 + y.^2).^2);
    
    % Adjust image size to kernel size if necessary (may be different due
    % to rounding issues)
    if size(targetKernel,1) ~= size(targetImage,1)
       
        targetImage = targetImage(1:size(targetImage,1) - 1, :, :);
        
    end
    
    if size(targetKernel,2) ~= size(targetImage,2)
       
        targetImage = targetImage(:, 1:size(targetImage,2) - 1, :);
        
    end
    
    % Get pixel value range from given image class
    range = getrangefromclass(targetImage);
    
    % Compute bin index map and weighted histogram of the target ROI image
    targetModel.binIdxMap = idxMapFcnHandle(double(targetImage), histogramBins,  range(1), range(2));
    targetModel.histogram = histogramFcnHandle(double(targetImage), targetKernel, targetModel.binIdxMap, histogramBins);
    targetModel.histogramBins = histogramBins;
    
    % Compute center of the target ROI (in the coordinate system of input image) 
    targetModelCenter(1) = targetRoi(2) + round(targetRoi(4) /  2);
    targetModelCenter(2) = targetRoi(1) + round(targetRoi(3) /  2);
    
    % Get demanded background ROI - size defined by bandwidth value, may
    % outreach input image
    backgroundRoi = [targetModelCenter(1) - round(targetModel.verticalRadious * bandwidth), ...
        targetModelCenter(2) - round(targetModel.horizontalRadious * bandwidth), ...
        2 * round(targetModel.verticalRadious * bandwidth) + 1, ...
        2 * round(targetModel.horizontalRadious * bandwidth) + 1];
    
    % Compute verical and horizontal radious of the background
    % (must be odd)
    backgroundModel.verticalRadious = ceil(backgroundRoi(3) / 2) - 1;
    backgroundModel.horizontalRadious = ceil(backgroundRoi(4) / 2) - 1;
    
    % Compute consistentely-sized kernel matrix  
    [x,y] = meshgrid(-bandwidth : bandwidth/backgroundModel.horizontalRadious : bandwidth, -bandwidth : bandwidth/backgroundModel.verticalRadious : bandwidth);
    backgroundKernel = backgroundProfileFcnHandle(sqrt(x.^2 + y.^2).^2, scalingFactor);
    
    % Compute how background ROI outreaches input image in each direction -
    % [ymin, ymax, xmin, xmax]
    discardAreaSize = [-min(backgroundRoi(1) - 1, 0), min(size(image,1) - (backgroundRoi(1) + backgroundRoi(3)), 0), ...
        -min(backgroundRoi(2) - 1, 0), min(size(image,2) - (backgroundRoi(2) + backgroundRoi(4)), 0)];
    
    % Get permissible background ROI image 
    backgroundImage = image(backgroundRoi(1) + discardAreaSize(1) : backgroundRoi(1) + backgroundRoi(3) + discardAreaSize(2), ...
        backgroundRoi(2) + discardAreaSize(3) : backgroundRoi(2) + backgroundRoi(4) + discardAreaSize(4), :);
    
    % Reject area of the background kernel that corresponds to outside of input image ROI part 
    backgroundKernel = backgroundKernel(1 + discardAreaSize(1) : size(backgroundKernel,1) + discardAreaSize(2), ...
        1 + discardAreaSize(3) : size(backgroundKernel,2) + discardAreaSize(4));
    
    % Adjust image size to kernel size if necessary (may be different due
    % to rounding issues)
    if size(backgroundKernel,1) ~= size(backgroundImage,1)
       
        backgroundImage = backgroundImage(1:size(backgroundImage,1) - 1, :, :);
        
    end
    
    if size(backgroundKernel,2) ~= size(backgroundImage,2)
       
        backgroundImage = backgroundImage(:, 1:size(backgroundImage,2) - 1, :);
        
    end
    
    % Compute bin index map and weighted histogram of the backgroud ROI image
    backgroundModel.binIdxMap = idxMapFcnHandle(double(backgroundImage), histogramBins,  range(1), range(2));
    backgroundModel.histogram = histogramFcnHandle(double(backgroundImage), backgroundKernel, backgroundModel.binIdxMap, histogramBins);
    backgroundModel.histogramBins = histogramBins;
    
    % Find minimal non-zero value in background's histogram
    minimalNonZeroBin = min(backgroundModel.histogram(backgroundModel.histogram > 0));
    
    % Compute bin weights - weight of the bin is inversely proportional to
    % its significance in the whole histogram
    binWeights = ones(size(backgroundModel.histogram));
    nonZeroIdcs = backgroundModel.histogram > 0;
    binWeights(nonZeroIdcs) = minimalNonZeroBin./backgroundModel.histogram(nonZeroIdcs);
    
    % Adjust bins values of the target histogram by weights - bins, that
    % are more significant in the background histogram are less significant
    % in the target histogram
    targetModel.histogram = binWeights .* targetModel.histogram;
    
end