classdef LucasKanadeTracker < trackingModule.Tracker
    
    properties (Constant)
        
        defaultTrackWindowRadiousX = 5;
        defaultTrackWindowRadiousY = 5;
        defaultStopThreshold = 0.5;
        defaultMaxIterations = 3;
        defaultPyramidDepth = 3;
        defaultMinHessianDet = 1e-6;
        defaultExtractWindowRadiousX = 1;
        defaultExtractWindowRadiousY = 1;
        defaultEigRetainCoeff = 0.1;
        defaultMinFeatureDistance = 3;
        defaultMaxTrackingAffineDistortion = 5;
        defaultMinFeaturesCount = 8;
        defaultMaxFeaturesCount = 100;
        defaultUpdateThreshold = 40;
        defaultAutoUpdate = true;

    end

    properties (Access = private)
       
        trackWindowRadiousX;
        trackWindowRadiousY;
        stopThreshold;
        maxIterations;
        pyramidDepth;
        minHessianDet;
        extractWindowRadiousX;
        extractWindowRadiousY;
        eigRetainCoeff;
        minFeatureDistance;
        maxTrackingAffineDistortion;
        minFeaturesCount;
        maxFeaturesCount;
        updateThreshold;
        autoUpdate;
        
        currentFrame;
        previousFrame;
        
        trackedFeatures;
        featuresEigenvals;
        boundingPolygon;
        initialTrackedFeatures;
        
    end
    
    methods (Access = private)
       
        function obj = pushFrame(obj, newFrame)
           
            if ~ismatrix(newFrame)
               
                newFrame = rgb2gray(newFrame);
                
            end
            
            if ~isequal(class(newFrame),'single')

                newFrame = im2single(newFrame);
                
            end
            
            obj.previousFrame = obj.currentFrame;
            obj.currentFrame = newFrame;
            
        end
        
    end

    
    methods
       
        function obj = setParameter(obj, varargin)
        
            % Input parameters validation   
            parameterParser = inputParser;

            % Auxiliary validating functions
            isPositiveInteger = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x == floor(x) && x > 0;
            isPositiveNumeric = @(x) isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;

            % Define allowed parameters and their constraints
            addParameter(parameterParser, 'TrackWindowRadiousX', obj.trackWindowRadiousX, @(x) assert(isPositiveInteger(x) && mod(x) == 1, ...
                'Tracking window radious must be positive odd integer'));
            addParameter(parameterParser, 'TrackWindowRadiousY', obj.trackWindowRadiousY, @(x) assert(isPositiveInteger(x) && mod(x) == 1, ...
                'Tracking window radious must be positive odd integer'));
            addParameter(parameterParser, 'StopThreshold', obj.stopThreshold, @(x) assert(isPositiveNumeric(x), ...
                'Stop threshold value must be positive numeric'));
            addParameter(parameterParser, 'MaxIterations', obj.maxIterations, @(x) assert(isPositiveInteger(x), ...
                'Maximum iterations number must be positive integer'));
            addParameter(parameterParser, 'PyramidDepth', obj.pyramidDepth, @(x) assert(isPositiveInteger(x), ...
                'Pyramid depth must be positive integer'));
            addParameter(parameterParser, 'MinHessianDet', obj.minHessianDet, @(x) assert(isPositiveNumeric(x), ...
                'Minimal feature Hessian determinant value must be positive numeric'));
            addParameter(parameterParser, 'ExtractWindowRadiousX', obj.extractWindowRadiousX, @(x) assert(isPositiveInteger(x) && mod(x) == 1, ...
                'Extraction window radious must be positive odd integer'));
            addParameter(parameterParser, 'ExtractWindowRadiousY', obj.extractWindowRadiousY, @(x) assert(isPositiveInteger(x) && mod(x) == 1, ...
                'Extraction window radious must be positive odd integer'));
            addParameter(parameterParser, 'EigRetainCoeff', obj.eigRetainCoeff, @(x) assert(isPositiveNumeric(x) && x < 1, ...
                'Feature extraction eigenvalue retain coefficient must be positive numeric less or equal to 1'));
            addParameter(parameterParser, 'MinFeatureDistance', obj.minFeatureDistance, @(x) assert(isPositiveNumeric(x), ...
                'Minimal feature extraction distance must be positive numeric'));
            addParameter(parameterParser, 'MaxTrackingAffineDistortion', obj.maxTrackingAffineDistortion, @(x) assert(isPositiveNumeric(x), ...
                'Maximal allowed tracking affine distortion must be positive numeric'));
            addParameter(parameterParser, 'MinFeaturesCount', obj.minFeaturesCount, @(x) assert(isPositiveInteger(x) && x >= 4, ...
                'Minimal tracked features count must be positive integer greater or equal to 4'));
            addParameter(parameterParser, 'MaxFeaturesCount', obj.maxFeaturesCount, @(x) assert(isPositiveInteger(x) && x >= 4, ...
                'Maximal tracked features count must be positive integer greater or equal to 4'));
            addParameter(parameterParser, 'UpdateThreshold', obj.updateThreshold, @(x) assert(isPositiveInteger(x) && x >= 4, ...
                'Model update threshold must be positive integer greater or equal to 4'));
            addParameter(parameterParser, 'AutoUpdate', obj.autoUpdate, @(x) assert(islogical(x), ...
                'Model auto-update flag must be logical value'));
                        
            % Parse given parameters
            parse(parameterParser, varargin{:});

            % Update parameters values           
            obj.trackWindowRadiousX = parameterParser.Results.TrackWindowRadiousX;
            obj.trackWindowRadiousY = parameterParser.Results.TrackWindowRadiousY;
            obj.stopThreshold = parameterParser.Results.StopThreshold;
            obj.maxIterations = parameterParser.Results.MaxIterations;
            obj.pyramidDepth = parameterParser.Results.PyramidDepth;
            obj.minHessianDet = parameterParser.Results.MinHessianDet;
            obj.extractWindowRadiousX = parameterParser.Results.ExtractWindowRadiousX;
            obj.extractWindowRadiousY = parameterParser.Results.ExtractWindowRadiousY;
            obj.eigRetainCoeff = parameterParser.Results.EigRetainCoeff;
            obj.minFeatureDistance = parameterParser.Results.MinFeatureDistance;
            obj.minFeaturesCount = parameterParser.Results.MinFeaturesCount;
            obj.maxFeaturesCount = parameterParser.Results.MaxFeaturesCount;
            obj.maxTrackingAffineDistortion = parameterParser.Results.MaxTrackingAffineDistortion;
            obj.updateThreshold = parameterParser.Results.UpdateThreshold;
            obj.autoUpdate = parameterParser.Results.AutoUpdate;
            
        end
            
        function obj = LucasKanadeTracker(varargin)
           
            obj.trackWindowRadiousX = obj.defaultTrackWindowRadiousX;
            obj.trackWindowRadiousY = obj.defaultTrackWindowRadiousY;
            obj.stopThreshold = obj.defaultStopThreshold;
            obj.maxIterations = obj.defaultMaxIterations;
            obj.pyramidDepth = obj.defaultPyramidDepth;
            obj.minHessianDet = obj.defaultMinHessianDet;
            obj.extractWindowRadiousX = obj.defaultExtractWindowRadiousX;
            obj.extractWindowRadiousY = obj.defaultExtractWindowRadiousY;
            obj.eigRetainCoeff = obj.defaultEigRetainCoeff;
            obj.minFeatureDistance = obj.defaultMinFeatureDistance;
            obj.maxTrackingAffineDistortion = obj.defaultMaxTrackingAffineDistortion;
            obj.minFeaturesCount = obj.defaultMinFeaturesCount;
            obj.maxFeaturesCount = obj.defaultMaxFeaturesCount;
            obj.updateThreshold = obj.defaultUpdateThreshold;
            obj.autoUpdate = obj.defaultAutoUpdate;
            obj.status = false;
            
            setParameter(obj, varargin{:});

        end
        
        function obj = focus(obj, frame, roiRect)
            
            obj.pushFrame(frame);
            obj.boundingPolygon = zeros(4, 2);
            obj.position = [0, 0];
            obj.orientation = 0;
            obj.dimensions = [0, 0];
            
            if roiRect(1) < 1 || roiRect(1) + roiRect(3) > size(frame,2) || roiRect(2) < 1 || roiRect(2) + roiRect(4) > size(frame,1)
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            roi = obj.currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3));
            [obj.trackedFeatures, obj.featuresEigenvals] = findGoodFeatures(roi, obj.extractWindowRadiousY, ...
                obj.extractWindowRadiousY, obj.eigRetainCoeff, obj.minFeatureDistance);
            
            if (size(obj.trackedFeatures, 1) > obj.maxFeaturesCount)
               
                
                [obj.featuresEigenvals, sortIdx] = sort(obj.featuresEigenvals, 'descend');
                obj.trackedFeatures = obj.trackedFeatures(sortIdx, :);
                obj.trackedFeatures = obj.trackedFeatures(1:obj.maxFeaturesCount,:);
                
            end
            
            obj.trackedFeatures(:,1) = obj.trackedFeatures(:,1) + roiRect(1);
            obj.trackedFeatures(:,2) = obj.trackedFeatures(:,2) + roiRect(2);
            
            obj.initialTrackedFeatures = obj.trackedFeatures;
            
            if size(obj.trackedFeatures, 1) < obj.minFeaturesCount
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            else
                
                obj.status = true;
                obj.similarity = 1;
                
            end
            
            obj.boundingPolygon = [roiRect(1), roiRect(2); ...
                roiRect(1) + roiRect(3), roiRect(2); ...
                roiRect(1) + roiRect(3), roiRect(2) + roiRect(4); ...
                roiRect(1), roiRect(2) + roiRect(4)];
            
            obj.position = [roiRect(1) + roiRect(3) / 2, roiRect(2) + roiRect(4) / 2];
            obj.dimensions = [roiRect(3), roiRect(4)];
            
        end
        
        function obj = track(obj, frame)
           
            obj.pushFrame(frame);
            
            %try
            
            [flow, trackingSuccessful] = pyramidalLucasKanade(obj.previousFrame, obj.currentFrame, ...
                obj.trackedFeatures, obj.trackWindowRadiousY, obj.trackWindowRadiousY, ...
                obj.maxIterations, obj.stopThreshold, obj.pyramidDepth, obj.minHessianDet, ...
                @inverseCompostionalLK, @gaussianKernel);
            
            %catch ex
               
            %    ex
                
            %end
            
            obj.trackedFeatures = obj.trackedFeatures(trackingSuccessful, :);
            obj.featuresEigenvals = obj.featuresEigenvals(trackingSuccessful, :);
            flow = flow(trackingSuccessful, :);
            previousFeatures = obj.trackedFeatures;
            obj.trackedFeatures = obj.trackedFeatures + flow;
            
            if size(obj.trackedFeatures, 1) < obj.minFeaturesCount
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            [affineMatrix, inlinersIdx, distance]  = fitHomography(previousFeatures, obj.trackedFeatures, obj.maxTrackingAffineDistortion, @computeAffine);
 
            if nnz(inlinersIdx) < obj.minFeaturesCount
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            obj.similarity = 1 - (sum(distance / obj.maxTrackingAffineDistortion)/ size(obj.trackedFeatures,1)) / (size(inlinersIdx,1) / size(obj.trackedFeatures,1));
            
            obj.trackedFeatures = obj.trackedFeatures(inlinersIdx,:);
            obj.featuresEigenvals = obj.featuresEigenvals(inlinersIdx, :);
            
            obj.boundingPolygon = applyHomography(obj.boundingPolygon, affineMatrix);
            
            %if min(obj.boundingPolygon(:,1)) < 1 || max(obj.boundingPolygon(:,1)) > size(obj.currentFrame,2) || ...
            %        min(obj.boundingPolygon(:,2)) < 1 || max(obj.boundingPolygon(:,2)) > size(obj.currentFrame,1)
               
            %    obj.status = false;s
            %    obj.similarity = 0;
            %    return;
                
            %end
            
            obj.position = applyHomography(obj.position, affineMatrix);
            
            [U,D,V] = svd(affineMatrix(1:2,1:2));

            R = U*V';
            
            obj.orientation = obj.orientation + atan2(R(2,1),R(1,1));
            
            scale = (D(1,1) + D(2,2)) / 2;
            
            obj.dimensions(1) = obj.dimensions(1) * scale;
            obj.dimensions(2) = obj.dimensions(2) * scale;
            
            if size(obj.trackedFeatures, 1) <= obj.updateThreshold && obj.autoUpdate
            
                obj.update;
                
            end

            
        end

        
        function obj = update(obj)
        
            minX = max(1, min(obj.boundingPolygon(:,1)));
            minY = max(1, min(obj.boundingPolygon(:,2)));
            maxX = min(size(obj.currentFrame, 2), max(obj.boundingPolygon(:,1)));
            maxY = min(size(obj.currentFrame, 1), max(obj.boundingPolygon(:,2)));
            
            roiRect = round([minX, minY, maxX - minX, maxY - minY]);
            
            roi = obj.currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3));
            [newFeatures, newEigenvals] = findGoodFeatures(roi, obj.extractWindowRadiousY, ...
                obj.extractWindowRadiousY, obj.eigRetainCoeff, obj.minFeatureDistance);
            
            newFeatures(:,1) = newFeatures(:,1) + roiRect(1);
            newFeatures(:,2) = newFeatures(:,2) + roiRect(2);
            
            inRoi = inpolygon(newFeatures(:,1), newFeatures(:,2), obj.boundingPolygon(:,1), obj.boundingPolygon(:,2));
            newFeatures = newFeatures(inRoi,:);
            newEigenvals = newEigenvals(inRoi,:);
            
            obj.trackedFeatures = newFeatures;
            
            obj.initialTrackedFeatures = obj.trackedFeatures;
            obj.featuresEigenvals = newEigenvals;
            %obj.trackedFeatures = [obj.trackedFeatures; newFeatures];
            %obj.featuresEigenvals = [obj.featuresEigenvals; newEigenvals];
            
            if (size(obj.trackedFeatures, 1) < obj.minFeaturesCount)
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            else
                
                if (size(obj.trackedFeatures, 1) > obj.maxFeaturesCount)
               
                
                    [obj.featuresEigenvals, sortIdx] = sort(obj.featuresEigenvals, 'descend');
                    obj.trackedFeatures = obj.trackedFeatures(sortIdx, :);
                    obj.trackedFeatures = obj.trackedFeatures(1:obj.maxFeaturesCount, :);
                
                end
                
                obj.status = true;
                obj.similarity = 1;
                
            end
            
        end
        
        function features = getTrackedFeatures(obj)
           
            features = obj.trackedFeatures;
            
        end
        
        function boundingPolygon = getBoundingPolygon(obj)
           
            boundingPolygon = obj.boundingPolygon;
            
        end
        
    end
    
end

