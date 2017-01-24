function model = histogramModel(image, windowProfileFcnHandle, histogramBins, binIdxMapFcnHandle, normalizedWeightedHistogramFcnHandle)

    %image = double(image);

    % Get target ROI part from the whole image
    %targetImage = image(targetRoi(2) : targetRoi(2) + targetRoi(4), targetRoi(1) : targetRoi(1) + targetRoi(3), :);

    % Compute permissible verical and horizontal radious of the target
    % (must be odd)
    model.verticalRadious = ceil(size(image,1) / 2) - 1;
    model.horizontalRadious = ceil(size(image,2) / 2) - 1;
    
    % Compute consistentely-sized kernel matrix 
    [x,y] = meshgrid(-1 : 1/model.horizontalRadious : 1, -1 : 1/model.verticalRadious : 1);
    kernel = windowProfileFcnHandle(sqrt(x.^2 + y.^2).^2);
    
    % Adjust image size to kernel size if necessary (may be different due
    % to rounding issues)
    if size(kernel,1) ~= size(image,1)
       
        image = image(1:size(image,1) - 1, :, :);
        
    end
    
    if size(kernel,2) ~= size(image,2)
       
        image = image(:, 1:size(image,2) - 1, :);
        
    end
    
    % Get pixel value range from given image class
    range = getrangefromclass(image);
    
    % Compute bin index map and weighted histogram of the target ROI image
    model.binIdxMap = binIdxMapFcnHandle(double(image), histogramBins,  range(1), range(2));
    model.histogram = normalizedWeightedHistogramFcnHandle(double(image), kernel, model.binIdxMap, histogramBins);
    model.histogramBins = histogramBins;
    
end