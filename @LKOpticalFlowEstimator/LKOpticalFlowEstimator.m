classdef LKOpticalFlowEstimator < handle
    
    properties (Constant)
        
        defaultWindowWidth = 5;
        defaultWindowHeight = 5;
        defaultStopThreshold = 0.1;
        defaultMaxIterations = 3;
        verboseLevels = {'all', 'warnings', 'silent'};
        defaultVerboseLevel = {'silent'};
        outputLevels = {'simple', 'detailed'};
        defaultOutputLevel = {'simple'};
        imageFilters = {'none', 'gaussian', 'median'};
        defaultImageFilter = {'gaussian'};
        defaultFilterSize = [5 5];
        defaultGaussianSigma = 1;
        gradientTypes = {'central', 'intermediate'};
        defaultGradientType = {'central'};
        
    end
    
    properties
       
        windowWidth;
        windowHeight;
        stopThreshold;
        maxIterations;
        verboseLevel;
        outputLevel;
        imageFilter;
        filterSize;
        gaussianSigma;
        gradientType;
        
        windowRadiousX;
        windowRadiousY;
        showWarnings;
        showMessages;
        detailedOutput;
        
    end
    
    methods
       
        setParameter(obj, varargin);
        
        function OFEstimator = LKOpticalFlowEstimator(varargin)
           
            OFEstimator.windowWidth = OFEstimator.defaultWindowWidth;
            OFEstimator.windowHeight = OFEstimator.defaultWindowHeight;
            OFEstimator.stopThreshold = OFEstimator.defaultStopThreshold;
            OFEstimator.maxIterations = OFEstimator.defaultMaxIterations;
            OFEstimator.verboseLevel = OFEstimator.defaultVerboseLevel;
            OFEstimator.outputLevel = OFEstimator.defaultOutputLevel;
            OFEstimator.imageFilter = OFEstimator.defaultImageFilter;
            OFEstimator.filterSize = OFEstimator.defaultFilterSize;
            OFEstimator.gaussianSigma = OFEstimator.defaultGaussianSigma;
            OFEstimator.gradientType = OFEstimator.defaultGradientType;
            
            OFEstimator.windowRadiousX = floor(OFEstimator.windowWidth / 2);
            OFEstimator.windowRadiousY = floor(OFEstimator.windowHeight / 2);
            OFEstimator.showWarnings = false;
            OFEstimator.showMessages = false;
            OFEstimator.detailedOutput = false;
            
            setParameter(OFEstimator, varargin{:});

        end

        % Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying Framework
        % Tomasi, C. & Kanade, T. Detection and Tracking of Point Features
        opticalFlow = estimateOpticalFlow(obj, pointsXY, previousFrame, currentFrame);
        
        goodFeatures = findGoodFeaturesToTrack(obj, frame);
        
        
    end
    
end