classdef MeanShiftTracker < trackingModule.VisualTracker

    properties (Constant)
        
        % Default values of tracker parameters
        defaultModelBins = [16, 8, 8];
        defaultBandwidthWindow = 1;
        defaultMaxIterations = 10;
        defaultStopThreshold = 1;
        defaultAdaptSizeCoeff = 0.2;
        defaultAdaptSpeedCoeff = 0.5;
        defaultMinSizeRatio = 0.1;   
        defaultBackgroundScalingFactor = 1;
        defaultBandwidthBackgroundModel = 2;
        defaultAutoUpdate = true;
        defaultBackgroundCancel = false;
        
    end
    
    properties (Access = private)
        
        modelBins;
        bandwidthWindow;
        maxIterations;
        stopThreshold;
        adaptSizeCoeff;
        adaptSpeedCoeff;
        minSizeRatio;
        backgroundScalingFactor;
        bandwidthBackgroundModel;
        autoUpdate;
        backgroundCancel;
        
         % Current frame passed to tracker
        currentFrame;

        % Tracked object histogram model
        targetModel;
        candidateModel;
        % Bounding rectangle of tracked object
        initialDimensions;
        initialModel;
        
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
            addParameter(parameterParser, 'BandwidthWindow', obj.bandwidthWindow, @(x) assert(isPositiveNumeric(x), ...
                'Computation region bandwidth value must be positive numeric'));
            addParameter(parameterParser, 'MaxIterations', obj.maxIterations, @(x) assert(isPositiveInteger(x), ...
                'Maximum iterations number must be positive integer'));
            addParameter(parameterParser, 'StopThreshold', obj.stopThreshold, @(x) assert(isPositiveNumeric(x), ...
                'Stop threshold value must be positive numeric'));
            addParameter(parameterParser, 'AdaptSizeCoeff', obj.adaptSizeCoeff, @(x) assert(isPositiveNumeric(x), ...
                'Window adaptation size coefficient must be positive numeric'));
            addParameter(parameterParser, 'AdaptSpeedCoeff', obj.adaptSpeedCoeff, @(x) assert(isPositiveNumeric(x), ...
                'Window adaptation speed coefficient must be positive numeric'));
            addParameter(parameterParser, 'MinSizeRatio', obj.minSizeRatio, @(x) assert(isPositiveNumeric(x), ...
                'Minimal size ratio must be positive numeric'));
            addParameter(parameterParser, 'BackgroundScalingFactor', obj.backgroundScalingFactor, @(x) assert(isPositiveNumeric(x), ...
                'Background scaling factor must be positive numeric'));
            addParameter(parameterParser, 'BandwidthBackgroundModel', obj.bandwidthBackgroundModel, @(x) assert(isPositiveNumeric(x), ...
                'Background model bandwidth value must be positive numeric'));
            addParameter(parameterParser, 'AutoUpdate', obj.autoUpdate, @(x) assert(islogical(x), ...
                'Model auto-update flag must be logical value'));
            addParameter(parameterParser, 'BackgroundCancel', obj.backgroundCancel, @(x) assert(islogical(x), ...
                'Background subtraction in target model flag must be logical value'));
            
            
            
            % Parse given parameters
            parse(parameterParser, varargin{:});

            % Update parameters values 
            obj.modelBins = parameterParser.Results.ModelBins;
            obj.bandwidthWindow = parameterParser.Results.BandwidthWindow;
            obj.maxIterations = parameterParser.Results.MaxIterations;
            obj.stopThreshold = parameterParser.Results.StopThreshold;
            obj.adaptSizeCoeff = parameterParser.Results.AdaptSizeCoeff;
            obj.adaptSpeedCoeff = parameterParser.Results.AdaptSpeedCoeff;
            obj.minSizeRatio = parameterParser.Results.MinSizeRatio;
            obj.backgroundScalingFactor = parameterParser.Results.BackgroundScalingFactor;
            obj.bandwidthBackgroundModel = parameterParser.Results.BandwidthBackgroundModel;
            obj.autoUpdate = parameterParser.Results.AutoUpdate;
            obj.backgroundCancel = parameterParser.Results.BackgroundCancel;
            
        end
       
        % Construct object with default parameters (alternatively modifed
        % by passed parameters)
        function obj = MeanShiftTracker(varargin)
           
             % Initialize object state
            obj = obj@trackingModule.VisualTracker;
            
            obj.modelBins = obj.defaultModelBins;
            obj.bandwidthWindow = obj.defaultBandwidthWindow;
            obj.maxIterations = obj.defaultMaxIterations;
            obj.stopThreshold = obj.defaultStopThreshold;
            obj.adaptSizeCoeff = obj.defaultAdaptSizeCoeff;
            obj.adaptSpeedCoeff = obj.defaultAdaptSpeedCoeff;
            obj.minSizeRatio = obj.defaultMinSizeRatio;
            obj.backgroundScalingFactor = obj.defaultBackgroundScalingFactor;
            obj.bandwidthBackgroundModel = obj.defaultBandwidthBackgroundModel;
            obj.autoUpdate = obj.defaultAutoUpdate;
            obj.backgroundCancel = obj.defaultBackgroundCancel;
            
            setParameter(obj, varargin{:});

        end
        
        % Select area that contains tracked object and determine its model
        % (weighted histogram)
        function obj = focus(obj, frame, roiRect)
            
            % Prepare new frame
            obj.pushFrame(frame);
            
            % Initialize object state
            %obj.boundingPolygon = zeros(4, 2);
            obj.position = [0, 0];
            obj.orientation = 0;
            obj.dimensions = [0, 0];
            
            % Fail if rectangle describing ROI outreaches given frame
            if roiRect(1) < 1 || roiRect(1) + roiRect(3) > size(frame,2) || roiRect(2) < 1 || roiRect(2) + roiRect(4) > size(frame,1)
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            if (obj.backgroundCancel)
                
                obj.targetModel = ratioHistogramModel(obj.currentFrame, roiRect, @epanechnikovProfile, ...
                    @backgorundScalingProfile, obj.modelBins, obj.bandwidthBackgroundModel, obj.backgroundScalingFactor);
                
            else
                
                roi = obj.currentFrame(roiRect(2) : roiRect(2) + roiRect(4), roiRect(1) : roiRect(1) + roiRect(3), :);
                obj.targetModel = histogramModel(roi, @epanechnikovProfile, obj.modelBins);
                
            end
 
            obj.initialModel = obj.targetModel;
            
            obj.position = [round(roiRect(1) + roiRect(3)/2), round(roiRect(2) + roiRect(4)/2)];
            obj.dimensions = [roiRect(4), roiRect(3)];
            obj.initialDimensions = obj.dimensions;
            obj.status = true;
            obj.similarity = 1;
            
        end
        
        % Track object between frames
        function obj = track(obj, frame)
            
            % Prepare new frame
            obj.pushFrame(frame);
            
            %previousMaxDimension = max(obj.targetModel.horizontalRadious, obj.targetModel.verticalRadious);
            
            windowDelta = obj.adaptSizeCoeff * obj.bandwidthWindow;
            newWindowBandwidth = [obj.bandwidthWindow, obj.bandwidthWindow + windowDelta, obj.bandwidthWindow - windowDelta];

            newPosition = zeros(3,2);
            newSimilarity = zeros(3,1);

            [newPosition(1,:), newSimilarity(1), candidateModel1] = meanShift(obj.currentFrame, obj.position, ...
                obj.targetModel, newWindowBandwidth(1), @epanechnikovProfile, @dEpanechnikovProfile, ...
                obj.maxIterations, obj.stopThreshold);
            [newPosition(2,:), newSimilarity(2), candidateModel2] = meanShift(obj.currentFrame, obj.position, ...
                obj.targetModel, newWindowBandwidth(2), @epanechnikovProfile, @dEpanechnikovProfile, ...
                obj.maxIterations, obj.stopThreshold);
            [newPosition(3,:), newSimilarity(3), candidateModel3] = meanShift(obj.currentFrame, obj.position, ...
                obj.targetModel, newWindowBandwidth(3), @epanechnikovProfile, @dEpanechnikovProfile, ...
                obj.maxIterations, obj.stopThreshold);

            [~, maxIdx] = max(newSimilarity);

            obj.bandwidthWindow = obj.adaptSpeedCoeff * newWindowBandwidth(maxIdx) + (1 - obj.adaptSpeedCoeff) * obj.bandwidthWindow;
            
            obj.position = newPosition(maxIdx, :);
           
            newCandidateModel = [candidateModel1, candidateModel2, candidateModel3];
            
            obj.candidateModel = newCandidateModel(maxIdx);
            
            %obj.candidateModel = candidateModel1;
            
            obj.dimensions = [(2 * obj.candidateModel.horizontalRadious + 1) * obj.bandwidthWindow, ...
                (2 * obj.candidateModel.verticalRadious + 1) * obj.bandwidthWindow];
            
            currentSizeRatio = obj.dimensions ./ obj.initialDimensions;
            
            if  currentSizeRatio(1) < obj.minSizeRatio || currentSizeRatio(2) < obj.minSizeRatio
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            obj.similarity = sum(sqrt(obj.candidateModel.histogram .* obj.initialModel.histogram));
            
            if (obj.autoUpdate)
            
               % obj.update;
            
            end
                
        end
        
        % Update object's model
        function obj = update(obj)
            
            minX = max(1, floor(obj.position(1) - obj.targetModel.horizontalRadious));
            maxX = min(size(obj.currentFrame,2), ceil(obj.position(1) + obj.targetModel.horizontalRadious));
            minY = max(1, floor(obj.position(2) - obj.targetModel.verticalRadious));
            maxY = min(size(obj.currentFrame,1), ceil(obj.position(2) + obj.targetModel.verticalRadious));
            
             % Determine ROI bounding rectangle
            roiRect = [minX, minY, maxX - minX, maxY - minY];

            roi = obj.currentFrame(roiRect(2) : roiRect(2) + roiRect(4), roiRect(1) : roiRect(1) + roiRect(3), :);
            newModel = histogramModel(roi, @epanechnikovProfile, obj.modelBins);

            obj.targetModel.histogram = obj.targetModel.histogram + newModel.histogram;
            
            normalizationConstant = sum(obj.targetModel.histogram);
            
            obj.targetModel.histogram = obj.targetModel.histogram / normalizationConstant;
            
        end
        
    end
    
end

