function setParameter(obj, varargin)

    % Input parameters validation   
    parameterParser = inputParser;

    windowWidthErrorStr = 'Window width must be positive, scalar and integer';
    windowHeightErrorStr = 'Window height must be positive, scalar and integer';
    stopThresholdErrorStr = 'Stop condition threshold value must be positive, scalar and numeric';
    maxIterationsErrorStr = 'Max iterations number must be positive, scalar and integer.';
    filterSizeErrorStr = 'Filter size must be positive and integer, scalar or 2-element vector';
    gaussianSigmaErrorStr = 'Sigma parameter of Gaussian filter must be positive, scalar and numeric';

    % Parameter not changed flag
    paramNotChanged = {'!NOT_CHANGED'};
    
    % Auxiliary validating functions
    isPositiveInteger = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x == floor(x) && x > 0;
    isPositiveNumeric = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;

    % Define allowed parameters and their constraints
    addParameter(parameterParser, 'WindowWidth', paramNotChanged, @(x) assert(isPositiveInteger(x), windowWidthErrorStr));
    addParameter(parameterParser, 'WindowHeight', paramNotChanged, @(x) assert(isPositiveInteger(x), windowHeightErrorStr));
    addParameter(parameterParser, 'StopThreshold', paramNotChanged, @(x) assert(isPositiveNumeric(x), stopThresholdErrorStr));
    addParameter(parameterParser, 'MaxIterations', paramNotChanged, @(x) assert(isPositiveInteger(x), maxIterationsErrorStr));
    addParameter(parameterParser, 'VerboseLevel', paramNotChanged, @(x) any(validatestring(x, obj.verboseLevels)));
    addParameter(parameterParser, 'OutputLevel', paramNotChanged, @(x) any(validatestring(x, obj.outputLevels)));
    addParameter(parameterParser, 'ImageFilter', paramNotChanged, @(x) any(validatestring(x, obj.imageFilters)));
    addParameter(parameterParser, 'FilterSize', paramNotChanged, @(x) assert(isnumeric(x)  && ...
        ((size(x,1) == 1  && size(x,2) == 2) || (size(x,1) == 2 && size(x,2) == 2)) && ... 
        x(1) > 0 && x(2) > 0 && x(1) == floor(x(1)) && x(2) == floor(x(2)) && isfinite(x(1)) ...
        && isfinite(x(2)), filterSizeErrorStr));
    addParameter(parameterParser, 'GaussianSigma', paramNotChanged, @(x) assert(isPositiveNumeric(x), gaussianSigmaErrorStr));
    addParameter(parameterParser, 'GradientType', paramNotChanged, @(x) any(validatestring(x, obj.gradientTypes)));

    % Parse given parameters
    parse(parameterParser, varargin{:});

    % Read parameters values and update if changed
    
    if ~isequal(parameterParser.Results.WindowWidth, paramNotChanged)
        
        obj.windowWidth = parameterParser.Results.WindowWidth;
        
        % Ensure that window width is odd
        if mod(obj.windowWidth,2) == 0

            obj.windowWidth = obj.windowWidth - 1;
            if obj.showWarnings
                warning('LKOpticalFlowEstimator:windowSize', 'Window width has to be odd, changing to %d', obj.windowWidth);
            end

        end
        
        obj.windowRadiousX = floor(obj.windowWidth / 2);
        
    end
    
    if ~isequal(parameterParser.Results.WindowHeight, paramNotChanged)
        
        obj.windowHeight = parameterParser.Results.WindowHeight;
        
        % Ensure that window height is odd
        if mod(obj.windowHeight,2) == 0

            obj.windowHeight = obj.windowHeight - 1;
            if obj.showWarnings
                warning('LKOpticalFlowEstimator:windowSize', 'Window height has to be odd, changing to %d', obj.windowHeight);
            end

        end
        
        obj.windowRadiousY = floor(obj.windowHeight / 2);
        
    end
    
    if ~isequal(parameterParser.Results.StopThreshold, paramNotChanged)
    
        obj.stopThreshold = parameterParser.Results.StopThreshold;
    
    end
    
    if ~isequal(parameterParser.Results.MaxIterations, paramNotChanged)
        
        obj.maxIterations = parameterParser.Results.MaxIterations;
    end
    
    if ~isequal(parameterParser.Results.VerboseLevel, paramNotChanged)
        
        obj.verboseLevel = parameterParser.Results.VerboseLevel;
        
        if isequal(obj.verboseLevel, 'all')

            obj.showWarnings = true;
            obj.showMessages = true;

        elseif isequal(obj.verboseLevel, 'warnings')

            obj.showWarnings = true;
            obj.showMessages = false;

        else

            obj.showWarnings = false;
            obj.showMessages = false;

        end
        
    end
    
    if ~isequal(parameterParser.Results.OutputLevel, paramNotChanged)
        
        obj.outputLevel = parameterParser.Results.OutputLevel;
        
        if isequal(obj.outputLevel, 'detailed')

            obj.detailedOutput = true;

        else

            obj.detailedOutput = false;

        end
        
    end
    
    if ~isequal(parameterParser.Results.ImageFilter, paramNotChanged)
        
        obj.imageFilter = parameterParser.Results.ImageFilter;
    
    end
    
    if ~isequal(parameterParser.Results.FilterSize, paramNotChanged)
    
        obj.filterSize = parameterParser.Results.FilterSize;
    
    end
    
    if ~isequal(parameterParser.Results.GaussianSigma, paramNotChanged)
        
        obj.gaussianSigma = parameterParser.Results.GaussianSigma;
        
    end
    
    if ~isequal(parameterParser.Results.GradientType, paramNotChanged)
        
        obj.gradientType = parameterParser.Results.GradientType;
    end
    
end