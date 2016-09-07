function model = histogramModel(image, windowProfileFcnHandle, histogramBins, ...
idxMapFcnHandle, histogramFcnHandle)

    model.verticalRadious = ceil(size(image,1) / 2) - 1;
    model.horizontalRadious = ceil(size(image,2) / 2) - 1;
    [x,y] = meshgrid(-1 : 1/model.horizontalRadious : 1, -1 : 1/model.verticalRadious : 1);
    kernel = windowProfileFcnHandle(sqrt(x.^2 + y.^2).^2);
    
    if size(kernel,1) ~= size(image,1)
       
        image = image(1:size(image,1) - 1, :, :);
        
    end
    
    if size(kernel,2) ~= size(image,2)
       
        image = image(:, 1:size(image,2) - 1, :);
        
    end
    
    range = getrangefromclass(image);
    model.binIdxMap = idxMapFcnHandle(double(image), histogramBins,  range(1), range(2));
    model.histogram = histogramFcnHandle(double(image), kernel, model.binIdxMap, histogramBins);
    model.histogramBins = histogramBins;
    
end