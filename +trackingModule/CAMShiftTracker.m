classdef CAMShiftTracker < trackingModule.VisualTracker

    properties (Constant)
        
        % Default values of tracker parameters
        defaultModelBins = [16, 8, 8];
        defaultBandwidthCompRegion = 2;
        defaultMaxIterations = 10;
        defaultStopThreshold = 1;
        defaultBackgroundScalingFactor = 0.1;
        defaultBandwidthBackgroundModel = 2;
        defaultMinSizeRatio = 0.1;
        defaultAutoUpdate = true;
        defaultBackgroundCancel = false;
        defaultUseMEX = true;
        
    end
    
    properties (Access = private)
        
        modelBins;
        bandwidthCompRegion;
        maxIterations;
        stopThreshold;
        backgroundScalingFactor;
        bandwidthBackgroundModel;
        minSizeRatio;
        autoUpdate;
        backgroundCancel;
        useMEX;
        
         % Current frame passed to tracker
        currentFrame;

        % Tracked object histogram model
        targetModel;
        % Bounding rectangle of tracked object
        initialDimensions;
        initialModel;
        
        %Function handles (for functions that are implemented both as
        %Matlab native and MEX
        binIdxMapFcnHandle;
        normalizedWeightedHistogramFcnHandle;
        
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
        
        
        function obj = setFcnHandles(obj)
            
           
            if obj.useMEX
            
                % Check if compiled MEX functions are present, set function handles
                % properly
                if isempty(dir('+MeanShiftEngine/+mex/binIdxMap.mex*'))

                    obj.binIdxMapFcnHandle = @MeanShiftEngine.matlab.binIdxMap;
                    warning('CAMShiftTracker:fileNotFound', 'MEX function binIdxMap not found, using native version');

                else

                    obj.binIdxMapFcnHandle = @MeanShiftEngine.mex.binIdxMap;

                end

                if isempty(dir('+MeanShiftEngine/+mex/binIdxMap.mex*'))

                    obj.normalizedWeightedHistogramFcnHandle = @MeanShiftEngine.matlab.normalizedWeightedHistogram;
                    warning('CAMShiftTracker:fileNotFound', 'MEX function normalizedWeightedHistogram not found, using native version');

                else

                    obj.normalizedWeightedHistogramFcnHandle = @MeanShiftEngine.mex.normalizedWeightedHistogram;

                end
            
            else
                
                obj.binIdxMapFcnHandle = @MeanShiftEngine.matlab.binIdxMap;
                obj.normalizedWeightedHistogramFcnHandle = @MeanShiftEngine.matlab.normalizedWeightedHistogram;  
                
            end
            
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
            addParameter(parameterParser, 'MinSizeRatio', obj.minSizeRatio, @(x) assert(isPositiveNumeric(x), ...
                'Minimal size ratio must be positive numeric'));
            addParameter(parameterParser, 'AutoUpdate', obj.autoUpdate, @(x) assert(islogical(x), ...
                'Model auto-update flag must be logical value'));
            addParameter(parameterParser, 'BackgroundCancel', obj.backgroundCancel, @(x) assert(islogical(x), ...
                'Background subtraction in target model flag must be logical value'));
            addParameter(parameterParser, 'UseMEX', obj.useMEX, @(x) assert(islogical(x), ...
                'MEX functions usage flag must be logical value'));
            
            % Parse given parameters
            parse(parameterParser, varargin{:});

            % Update parameters values 
            obj.modelBins = parameterParser.Results.ModelBins;
            obj.bandwidthCompRegion = parameterParser.Results.BandwidthCompRegion;
            obj.maxIterations = parameterParser.Results.MaxIterations;
            obj.stopThreshold = parameterParser.Results.StopThreshold;
            obj.backgroundScalingFactor = parameterParser.Results.BackgroundScalingFactor;
            obj.bandwidthBackgroundModel = parameterParser.Results.BandwidthBackgroundModel;
            obj.minSizeRatio = parameterParser.Results.MinSizeRatio;
            obj.autoUpdate = parameterParser.Results.AutoUpdate;
            obj.backgroundCancel = parameterParser.Results.BackgroundCancel;
            
            if obj.useMEX ~= parameterParser.Results.UseMEX
               
                obj.useMEX = parameterParser.Results.UseMEX;
                obj.setFcnHandles;
                
            end

        end
       
        % Construct object with default parameters (alternatively modifed
        % by passed parameters)
        function obj = CAMShiftTracker(varargin)
           
             % Initialize object state
            obj.modelBins = obj.defaultModelBins;
            obj.bandwidthCompRegion = obj.defaultBandwidthCompRegion;
            obj.maxIterations = obj.defaultMaxIterations;
            obj.stopThreshold = obj.defaultStopThreshold;
            obj.backgroundScalingFactor = obj.defaultBackgroundScalingFactor;
            obj.bandwidthBackgroundModel = obj.defaultBandwidthBackgroundModel;
            obj.minSizeRatio = obj.defaultMinSizeRatio;
            obj.autoUpdate = obj.defaultAutoUpdate;
            obj.backgroundCancel = obj.defaultBackgroundCancel;
            obj.useMEX = obj.defaultUseMEX;
            
            setParameter(obj, varargin{:});
            
            obj.setFcnHandles;
            
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
                
                obj.targetModel = MeanShiftEngine.ratioHistogramModel(obj.currentFrame, roiRect, @MeanShiftEngine.epanechnikovProfile, ...
                    @MeanShiftEngine.backgorundScalingProfile, obj.modelBins, obj.bandwidthBackgroundModel, obj.backgroundScalingFactor, ...
                    obj.binIdxMapFcnHandle, obj.normalizedWeightedHistogramFcnHandle);
                
            else
                
                roi = obj.currentFrame(roiRect(2) : roiRect(2) + roiRect(4), roiRect(1) : roiRect(1) + roiRect(3), :);
                obj.targetModel = MeanShiftEngine.histogramModel(roi, @MeanShiftEngine.epanechnikovProfile, obj.modelBins, ...
                    obj.binIdxMapFcnHandle, obj.normalizedWeightedHistogramFcnHandle);
                
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
            
            [obj.position, obj.targetModel, obj.orientation, currentDimensions] = ...
                MeanShiftEngine.CAMShift(obj.currentFrame, obj.targetModel, obj.position, obj.bandwidthCompRegion, ...
                obj.maxIterations, obj.stopThreshold, obj.binIdxMapFcnHandle);
            
            if  sum(isnan(obj.position)) > 0 || isnan(obj.orientation) || sum(isnan(currentDimensions))
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            obj.dimensions = 2 * currentDimensions + 1;
            
            currentSizeRatio = obj.dimensions ./ obj.initialDimensions;
            
            if  currentSizeRatio(1) < obj.minSizeRatio || currentSizeRatio(2) < obj.minSizeRatio
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            obj.similarity = sum(sqrt(obj.targetModel.histogram .* obj.initialModel.histogram));
            
            if (obj.autoUpdate)
            
                obj.update;
            
            end
                
        end
        
        % Update object's model
        % Fast and Robust CAMShift Tracking - David Exner, Erich Bruns, Daniel Kurz, and Anselm Grundhofer
        function obj = update(obj)
            
            minX = max(1, floor(obj.position(1) - obj.targetModel.horizontalRadious));
            maxX = min(size(obj.currentFrame,2), ceil(obj.position(1) + obj.targetModel.horizontalRadious));
            minY = max(1, floor(obj.position(2) - obj.targetModel.verticalRadious));
            maxY = min(size(obj.currentFrame,1), ceil(obj.position(2) + obj.targetModel.verticalRadious));
            
             % Determine ROI bounding rectangle
            roiRect = [minX, minY, maxX - minX, maxY - minY];

            roi = obj.currentFrame(roiRect(2) : roiRect(2) + roiRect(4), roiRect(1) : roiRect(1) + roiRect(3), :);
            newModel = MeanShiftEngine.histogramModel(roi, @eMeanShiftEngine.panechnikovProfile, obj.modelBins, ...
                obj.binIdxMapFcnHandle, obj.normalizedWeightedHistogramFcnHandle);

            obj.targetModel.histogram = obj.targetModel.histogram + newModel.histogram;
            
            normalizationConstant = sum(obj.targetModel.histogram);
            
            obj.targetModel.histogram = obj.targetModel.histogram / normalizationConstant;
            
        end
        
    end
    
end

