classdef CAMShiftTracker < trackingModule.Tracker

    properties (Constant)
        
        % Default values of tracker parameters
        defaultModelBins = [16, 8, 8];
        defaultBandwidthCompRegion = 3;
        defaultMaxIterations = 10;
        defaultStopThreshold = 1;
        defaultBackgroundScalingFactor = 0.5;
        defaultBandwidthBackgroundModel = 3;
        
    end
    
    properties (Access = private)
        
        modelBins;
        bandwidthCompRegion;
        maxIterations;
        stopThreshold;
        backgroundScalingFactor;
        bandwidthBackgroundModel;
        
         % Current frame passed to tracker
        currentFrame;

        % Tracked object histogram model
        trackedModel;
        % Bounding rectangle of tracked object
        boundingPolygon;
        
    end
    
    methods (Access = private)
       
        % Convert new frame to HSV image and single type if neccessary and 
        % set is as current frame
        function obj = pushFrame(obj, newFrame)
           
            newFrame = rgb2hsv(newFrame);
            
            if ~isequal(class(newFrame),'single')

                newFrame = im2single(newFrame);
                
            end
            
            obj.currentFrame = newFrame;
            
        end
        
    end
    
    methods
        
        % Set tracker parameters
        function obj = setParameter(obj, varargin)
        
            % Input parameters validation   
            parameterParser = inputParser;

            % Auxiliary validating functions
            isPositiveInteger = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x == floor(x) && x > 0;
            isPositiveNumeric = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;

            % Define allowed parameters and their constraints
            addParameter(parameterParser, 'ModelBins', obj.modelBins, @(x) assert(isnumeric(x) && size(x,1) == 1 && ...
                size(x,2) == 3 && sum(isfinite(x)) == 3 && sum(x == floor(x)) == 3 && sum(x > 0) == 3, ...
                'Model bins quantity must be 1x3 vector containing positive integers'));
            addParameter(parameterParser, 'BandwidthCompRegion', obj.bandwidthCompRegion, @(x) assert(isPositiveNumeric(x), ...
                'Computation region bandwidth value must be positive numeric'));
            addParameter(parameterParser, 'MaxIterations', obj.maxIterations, @(x) assert(isPositiveInteger(x), ...
                'Maximum iterations number must be positive integer'));
            addParameter(parameterParser, 'StopThreshold', obj.stopThreshold, @(x) assert(isPositiveNumeric(x), ...
                'Stop threshold value must be positive numeric'));
            addParameter(parameterParser, 'BackgroundScalingFactor', obj.backgroundScalingFactor, @(x) assert(isPositiveNumeric(x), ...
                'Background scaling factor must be positive numeric'));
            addParameter(parameterParser, 'BandwidthBackgroundModel', obj.bandwidthBackgroundModel, @(x) assert(isPositiveNumeric(x), ...
                'Background model bandwidth value must be positive numeric'));
  
            % Parse given parameters
            parse(parameterParser, varargin{:});

            % Update parameters values 
            obj.modelBins = parameterParser.Results.ModelBins;
            obj.bandwidthCompRegion = parameterParser.Results.BandwidthCompRegion;
            obj.maxIterations = parameterParser.Results.MaxIterations;
            obj.stopThreshold = parameterParser.Results.StopThreshold;
            obj.backgroundScalingFactor = parameterParser.Results.BackgroundScalingFactor;
            obj.bandwidthBackgroundModel = parameterParser.Results.BandwidthBackgroundModel;
            
        end
       
        % Construct object with default parameters (alternatively modifed
        % by passed parameters)
        function obj = CAMShiftTracker(varargin)
           
             % Initialize object state
            obj = obj@trackingModule.Tracker;
            
            obj.modelBins = obj.defaultModelBins;
            obj.bandwidthCompRegion = obj.defaultBandwidthCompRegion;
            obj.maxIterations = obj.defaultMaxIterations;
            obj.stopThreshold = obj.defaultStopThreshold;
            obj.backgroundScalingFactor = obj.defaultBackgroundScalingFactor;
            obj.bandwidthBackgroundModel = obj.defaultBandwidthBackgroundModel;
            
            setParameter(obj, varargin{:});

        end
        
        % Select area that contains tracked object and determine its model
        % (weighted histogram)
        function obj = focus(obj, frame, roiRect)
            
            % Prepare new frame
            obj.pushFrame(frame);
            
            % Initialize object state
            obj.boundingPolygon = zeros(4, 2);
            obj.position = [0, 0];
            obj.orientation = 0;
            obj.dimensions = [0, 0];
            
            % Fail if rectangle describing ROI outreaches given frame
            if roiRect(1) < 1 || roiRect(1) + roiRect(3) > size(frame,2) || roiRect(2) < 1 || roiRect(2) + roiRect(4) > size(frame,1)
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Extract ROI from current frame
            roi = obj.currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3), :);
            
            targetModel = histogramModel(currentFrameHSV, roiRect, @epanechnikovProfile, bins);
            
        end
        
        % Track object between frames
        function obj = track(obj, frame)
            
        end
        
        % Update object's model
        function obj = update(obj)
            
        end
        
    end
    
end

