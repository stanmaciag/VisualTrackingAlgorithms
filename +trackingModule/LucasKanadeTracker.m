classdef LucasKanadeTracker < trackingModule.VisualTracker
    
    properties (Constant)
        
        % Default values of tracker parameters
        defaultTrackWindowRadiousX = 5;
        defaultTrackWindowRadiousY = 5;
        defaultStopThreshold = 0.1;
        defaultMaxIterations = 3;
        defaultPyramidDepth = 3;
        defaultMinHessianDet = 1e-6;
        defaultExtractWindowRadiousX = 1;
        defaultExtractWindowRadiousY = 1;
        defaultEigRetainThreshold = 0.1;
        defaultMinFeatureDistance = 3;
        defaultMaxTrackingAffineDistortion = 5;
        defaultMinFeatures = 8;
        defaultDestFeatures = 100;
        defaultUpdateThreshold = 0.8;
        defaultAutoUpdate = true;
        defaultUseMEX = true;

    end

    properties (Access = private)
       
        % Tracking window horizontal radious for Lucas-Kanade algorithm
        trackWindowRadiousX;
        % Tracking window vertical radious for Lucas-Kanade algorithm
        trackWindowRadiousY;
        % Optical flow change stop threshold for Lucas-Kanade algorithm
        stopThreshold;
        % Number of maximum iterations of Lucas-Kanade algorithm
        maxIterations;
        % Number of pyramid levels (without base level) for pyramidal Lucas-Kanade algorithm
        pyramidDepth;
        % Minimal value of Hessian determinant that allows successful
        % tracking (allows to determine the inversion of Hessian)
        minHessianDet;
        % Feature search window horizontal radious
        extractWindowRadiousX;
        % Feature search window vertical radious
        extractWindowRadiousY;
        % Maximal found eigenvalue percentage that pre-qualify feature as
        % good feature to track
        eigRetainThreshold;
        % Minimal allowed distance between extracted features
        minFeatureDistance;
        % Maximum allowed distance between measured feature location and
        % corresponding location that fits current object affine transformation
        % which qualifies feature as inliner (belonging to object)
        maxTrackingAffineDistortion;
        % Minimal features quantity that allows performing tracking task
        minFeatures;
        % Destined features quantity
        destFeatures;
        % Current to destined tracked features quantity ratio that triggers
        % model update (finding new features and appending them to the tracked features set) 
        updateThreshold;
        % Automatic update flag (if true update will be performed when
        % features ratio reaches threshold level)
        autoUpdate;
        useMEX;
        
        % Current and previous frame passed to tracker
        currentFrame;
        previousFrame;
        
        % Tracked features set
        targetFeatures;
        % Miminal features eigenvalues
        featuresEigenvals;
        % Bounding polygon of tracked object
        boundingPolygon;
        
        %Function handles (for functions that are implemented both as
        %Matlab native and MEX
        bilinearInterpolateFcnHandle;
        imageGradientFcnHandle;
        imagePyramidFcnHandle;
        interpolatedGradientFcnHandle;
        proximityMapFcnHandle;

    end
    
    methods (Access = private)
       
        % Convert new frame to gray image and single type if neccessary and 
        % set is as current frame
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
        
        function obj = setFcnHandles(obj)
            
           
            if obj.useMEX
            
                % Check if compiled MEX functions are present, set function handles
                % properly
                if isempty(dir('+LucasKanadeEngine/+mex/bilinearInterpolate.mex*'))

                    obj.bilinearInterpolateFcnHandle = @LucasKanadeEngine.matlab.bilinearInterpolate;
                    warning('LucasKanadeEngine:fileNotFound', 'MEX function bilinearInterpolate not found, using native version');

                else

                    obj.bilinearInterpolateFcnHandle = @LucasKanadeEngine.mex.bilinearInterpolate;

                end

                if isempty(dir('+LucasKanadeEngine/+mex/imageGradient.mex*'))

                    obj.imageGradientFcnHandle = @LucasKanadeEngine.matlab.imageGradient;
                    warning('LucasKanadeEngine:fileNotFound', 'MEX function imageGradient not found, using native version');

                else

                    obj.imageGradientFcnHandle = @LucasKanadeEngine.mex.imageGradient;

                end
                
                if isempty(dir('+LucasKanadeEngine/+mex/imagePyramid.mex*'))

                    obj.imagePyramidFcnHandle = @LucasKanadeEngine.matlab.imagePyramid;
                    warning('LucasKanadeEngine:fileNotFound', 'MEX function imagePyramid not found, using native version');

                else

                    obj.imagePyramidFcnHandle = @LucasKanadeEngine.mex.imagePyramid;

                end
                
                if isempty(dir('+LucasKanadeEngine/+mex/interpolatedGradient.mex*'))

                    obj.interpolatedGradientFcnHandle = @LucasKanadeEngine.matlab.interpolatedGradient;
                    warning('LucasKanadeEngine:fileNotFound', 'MEX function interpolatedGradient not found, using native version');

                else

                    obj.interpolatedGradientFcnHandle = @LucasKanadeEngine.mex.interpolatedGradient;

                end
                
                if isempty(dir('+LucasKanadeEngine/+mex/proximityMap.mex*'))

                    obj.proximityMapFcnHandle = @LucasKanadeEngine.matlab.proximityMap;
                    warning('LucasKanadeEngine:fileNotFound', 'MEX function proximityMap not found, using native version');

                else

                    obj.proximityMapFcnHandle = @LucasKanadeEngine.mex.proximityMap;

                end
            
            else
                
                obj.bilinearInterpolateFcnHandle = @LucasKanadeEngine.matlab.bilinearInterpolate;
                obj.imageGradientFcnHandle = @LucasKanadeEngine.matlab.imageGradient;  
                obj.imagePyramidFcnHandle = @LucasKanadeEngine.matlab.imagePyramid;
                obj.interpolatedGradientFcnHandle = @LucasKanadeEngine.matlab.interpolatedGradient;
                obj.proximityMapFcnHandle = @LucasKanadeEngine.matlab.proximityMap;
                
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
            addParameter(parameterParser, 'TrackWindowRadiousX', obj.trackWindowRadiousX, @(x) assert(isPositiveInteger(x), ...
                'Tracking window radious must be positive integer'));
            addParameter(parameterParser, 'TrackWindowRadiousY', obj.trackWindowRadiousY, @(x) assert(isPositiveInteger(x), ...
                'Tracking window radious must be positive integer'));
            addParameter(parameterParser, 'StopThreshold', obj.stopThreshold, @(x) assert(isPositiveNumeric(x), ...
                'Stop threshold value must be positive numeric'));
            addParameter(parameterParser, 'MaxIterations', obj.maxIterations, @(x) assert(isPositiveInteger(x), ...
                'Maximum iterations number must be positive integer'));
            addParameter(parameterParser, 'PyramidDepth', obj.pyramidDepth, @(x) assert(isPositiveInteger(x), ...
                'Pyramid depth must be positive integer'));
            addParameter(parameterParser, 'MinHessianDet', obj.minHessianDet, @(x) assert(isPositiveNumeric(x), ...
                'Minimal feature Hessian determinant value must be positive numeric'));
            addParameter(parameterParser, 'ExtractWindowRadiousX', obj.extractWindowRadiousX, @(x) assert(isPositiveInteger(x), ...
                'Extraction window radious must be positive integer'));
            addParameter(parameterParser, 'ExtractWindowRadiousY', obj.extractWindowRadiousY, @(x) assert(isPositiveInteger(x), ...
                'Extraction window radious must be positive integer'));
            addParameter(parameterParser, 'EigRetainThreshold', obj.eigRetainThreshold, @(x) assert(isPositiveNumeric(x) && x <= 1, ...
                'Feature extraction eigenvalue retain threshold must be positive numeric less or equal to 1'));
            addParameter(parameterParser, 'MinFeatureDistance', obj.minFeatureDistance, @(x) assert(isPositiveNumeric(x), ...
                'Minimal feature extraction distance must be positive numeric'));
            addParameter(parameterParser, 'MaxTrackingAffineDistortion', obj.maxTrackingAffineDistortion, @(x) assert(isPositiveNumeric(x), ...
                'Maximal allowed tracking affine distortion must be positive numeric'));
            addParameter(parameterParser, 'MinFeatures', obj.minFeatures, @(x) assert(isPositiveInteger(x) && x >= 4, ...
                'Minimal tracked features quantity must be positive integer greater or equal to 4'));
            addParameter(parameterParser, 'DestFeatures', obj.destFeatures, @(x) assert(isPositiveInteger(x) && x >= 4, ...
                'Destined tracked features quantity must be positive integer greater or equal to 4'));
            addParameter(parameterParser, 'UpdateThreshold', obj.updateThreshold, @(x) assert(isPositiveNumeric(x) && x <= 1, ...
                'Model update threshold must be positive numeric less or equal to 1'));
            addParameter(parameterParser, 'AutoUpdate', obj.autoUpdate, @(x) assert(islogical(x), ...
                'Model auto-update flag must be logical value'));
            addParameter(parameterParser, 'UseMEX', obj.useMEX, @(x) assert(islogical(x), ...
                'MEX functions usage flag must be logical value'));
                        
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
            obj.eigRetainThreshold = parameterParser.Results.EigRetainThreshold;
            obj.minFeatureDistance = parameterParser.Results.MinFeatureDistance;
            obj.minFeatures = parameterParser.Results.MinFeatures;
            obj.destFeatures = parameterParser.Results.DestFeatures;
            obj.maxTrackingAffineDistortion = parameterParser.Results.MaxTrackingAffineDistortion;
            obj.updateThreshold = parameterParser.Results.UpdateThreshold;
            obj.autoUpdate = parameterParser.Results.AutoUpdate;
            obj.useMEX = obj.defaultUseMEX;
            
            if obj.useMEX ~= parameterParser.Results.UseMEX
               
                obj.useMEX = parameterParser.Results.UseMEX;
                obj.setFcnHandles;
                
            end
            
        end
       
        % Construct object with default parameters (alternatively modifed
        % by passed parameters)
        function obj = LucasKanadeTracker(varargin)
           
            % Initialize object state
            obj = obj@trackingModule.VisualTracker;
            obj.boundingPolygon = zeros(4, 2);
            
            % Initialize tracking parameters
            obj.trackWindowRadiousX = obj.defaultTrackWindowRadiousX;
            obj.trackWindowRadiousY = obj.defaultTrackWindowRadiousY;
            obj.stopThreshold = obj.defaultStopThreshold;
            obj.maxIterations = obj.defaultMaxIterations;
            obj.pyramidDepth = obj.defaultPyramidDepth;
            obj.minHessianDet = obj.defaultMinHessianDet;
            obj.extractWindowRadiousX = obj.defaultExtractWindowRadiousX;
            obj.extractWindowRadiousY = obj.defaultExtractWindowRadiousY;
            obj.eigRetainThreshold = obj.defaultEigRetainThreshold;
            obj.minFeatureDistance = obj.defaultMinFeatureDistance;
            obj.maxTrackingAffineDistortion = obj.defaultMaxTrackingAffineDistortion;
            obj.minFeatures = obj.defaultMinFeatures;
            obj.destFeatures = obj.defaultDestFeatures;
            obj.updateThreshold = obj.defaultUpdateThreshold;
            obj.autoUpdate = obj.defaultAutoUpdate;
            
            % Modify parameters
            setParameter(obj, varargin{:});
            
            obj.setFcnHandles;

        end
        
        % Select area that contains tracked object and determine its model
        % (sets of features and their eigenvalues)
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
            roi = obj.currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3));
            % Find good features to track in selected ROI
            [obj.targetFeatures, obj.featuresEigenvals] = LucasKanadeEngine.findGoodFeatures(roi, obj.extractWindowRadiousY, ...
                obj.extractWindowRadiousY, obj.eigRetainThreshold, obj.minFeatureDistance, [], obj.imageGradientFcnHandle, ...
                obj.proximityMapFcnHandle);
            
            % If found features quantity is greater than destined features
            % quantity select the strongest (with the greates minimal
            % eigenvalue)
            if (size(obj.targetFeatures, 1) > obj.destFeatures)
               
                % Sort features descendingly by their minimal eigenvalues
                [obj.featuresEigenvals, sortIdx] = sort(obj.featuresEigenvals, 'descend');
                obj.targetFeatures = obj.targetFeatures(sortIdx, :);
                % Retain destined quantity of features
                obj.targetFeatures = obj.targetFeatures(1:obj.destFeatures,:);
                obj.featuresEigenvals = obj.featuresEigenvals(1:obj.destFeatures,:);
                
            end
            
            % Covert features coordinate from local (ROI's) to
            % global (frame's)
            obj.targetFeatures(:,1) = obj.targetFeatures(:,1) + roiRect(1) - 1;
            obj.targetFeatures(:,2) = obj.targetFeatures(:,2) + roiRect(2) - 1;
            
            % Fail if features quantity is less than minimal
            if size(obj.targetFeatures, 1) < obj.minFeatures
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            else
                
                obj.status = true;
                % Measure similarity as current to destined features quantity ratio
                obj.similarity = size(obj.targetFeatures,1) / obj.destFeatures;
                
            end
            
            % Obtain bounding polygon of target object as ROI boundaries
            obj.boundingPolygon = [roiRect(1), roiRect(2); ...
                roiRect(1) + roiRect(3), roiRect(2); ...
                roiRect(1) + roiRect(3), roiRect(2) + roiRect(4); ...
                roiRect(1), roiRect(2) + roiRect(4)];
            
            % Compute current object's position and dimensions accordingly
            % to bounding polygon
            obj.position = [roiRect(1) + roiRect(3) / 2, roiRect(2) + roiRect(4) / 2];
            obj.dimensions = [roiRect(3), roiRect(4)];
            
        end
        
        % Track object between frames
        function obj = track(obj, frame)
           
            
            % Fail if tracked features quantity is less than minimal
            % (especially if no features were selected)
            if size(obj.targetFeatures, 1) < obj.minFeatures
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Prepare new frame
            obj.pushFrame(frame);
            
            % Estimate optical flow of tracked features
            [flow, trackingSuccessful] = LucasKanadeEngine.pyramidalLucasKanade(obj.previousFrame, obj.currentFrame, ...
                obj.targetFeatures, obj.trackWindowRadiousY, obj.trackWindowRadiousX, ...
                obj.maxIterations, obj.stopThreshold, obj.pyramidDepth, obj.minHessianDet, ...
                @LucasKanadeEngine.inverseCompostionalLK, @LucasKanadeEngine.gaussianKernel, obj.imagePyramidFcnHandle, obj.interpolatedGradientFcnHandle, ... 
                obj.bilinearInterpolateFcnHandle);

            
            % Retain only successfully tracked features (not degenerated
            % and not out of image bounds)
            obj.targetFeatures = obj.targetFeatures(trackingSuccessful, :);
            obj.featuresEigenvals = obj.featuresEigenvals(trackingSuccessful, :);
            flow = flow(trackingSuccessful, :);

            % Fail if tracked features quantity is less than minimal
            if size(obj.targetFeatures, 1) < obj.minFeatures
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Estimate current position as previos translated by optical
            % flow
            previousFeatures = obj.targetFeatures;
            obj.targetFeatures = obj.targetFeatures + flow;
            
            % Compute affine transformation matrix between current and previous features 
            [affineMatrix, inlinersIdx, distance]  = LucasKanadeEngine.fitHomography(previousFeatures, obj.targetFeatures, ...
                obj.maxTrackingAffineDistortion, @LucasKanadeEngine.computeAffine);
 
            % Fail if quantity of current features that are fitting stated
            % affine transformation is less than minimal
            if nnz(inlinersIdx) < obj.minFeatures
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Retain only features that fits stated affine transformation
            % (with certain given tolerance)
            obj.targetFeatures = obj.targetFeatures(inlinersIdx,:);
            obj.featuresEigenvals = obj.featuresEigenvals(inlinersIdx, :);
           
            % Compute current model similarity according to percentile
            % distance between actual position of tracked features and 
            % their position that fits affine model ideally and current
            % to destined features quantity ratio 
            obj.similarity = (1 - (sum(distance(inlinersIdx) / obj.maxTrackingAffineDistortion) ...
                / size(obj.targetFeatures,1))) * size(obj.targetFeatures,1) / obj.destFeatures;
            
            % Transform bounding polygon
            obj.boundingPolygon = LucasKanadeEngine.applyHomography(obj.boundingPolygon, affineMatrix);
            
            % Retain features that lie inside bounding polygon (make
            % sure that they belong to tracked object)
            inRoi = inpolygon(obj.targetFeatures(:,1), obj.targetFeatures(:,2), obj.boundingPolygon(:,1), obj.boundingPolygon(:,2));
            obj.targetFeatures = obj.targetFeatures(inRoi,:);
            obj.featuresEigenvals = obj.featuresEigenvals(inRoi,:);
            
            % Fail if quantity of current features that inside object
            % bounding polygon is less that minimal
            if nnz(inlinersIdx) < obj.minFeatures
                
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Transform current position
            obj.position = LucasKanadeEngine.applyHomography(obj.position, affineMatrix);
            
            % Decompose affine matrix
            [U,D,V] = svd(affineMatrix(1:2,1:2));

            % Compute rotation matrix
            R = U*V';
            
            % Compute accumulated object's orientation
            obj.orientation = obj.orientation + atan2(R(2,1),R(1,1));
            
            % Compute current object's scale
            scale = (D(1,1) + D(2,2)) / 2;
            
            % Resize object's dimension by current scale
            obj.dimensions(1) = obj.dimensions(1) * scale;
            obj.dimensions(2) = obj.dimensions(2) * scale;
            
            if  sum(isnan(obj.position)) > 0 || isnan(obj.orientation) || sum(isnan(obj.dimensions))
               
                obj.status = false;
                obj.similarity = 0;
                return;
                
            end
            
            % Update object model if auto-updating is enabled and current to 
            % destined features quantity ratio is less or equal to threshold
            if obj.autoUpdate && size(obj.targetFeatures, 1) / obj.destFeatures <= obj.updateThreshold
            
                obj.update;
                
            end
            
        end

        % Update object's model
        function obj = update(obj)
        
            % Compute quanitiy of features that are needed to achive
            % destined features set size
            supplementSize = obj.destFeatures - size(obj.targetFeatures,1);
            
            % Finish if no features need to be appended
            if supplementSize == 0
               
                return;
                
            end
            
            % Designate bounding rectangle for tracked object as rectangle
            % parallely aligned to image coordinate system and containing bounding polygon
            minX = max(1, floor(min(obj.boundingPolygon(:,1))));
            minY = max(1, floor(min(obj.boundingPolygon(:,2))));
            maxX = min(size(obj.currentFrame, 2), ceil(max(obj.boundingPolygon(:,1))));
            maxY = min(size(obj.currentFrame, 1), ceil(max(obj.boundingPolygon(:,2))));
            
            % Determine ROI bounding rectangle
            roiRect = [minX, minY, maxX - minX, maxY - minY];
            
            % Round current tracked positions
            initialFeatures = round(obj.targetFeatures);
            
            % Select features that lies inside bounding rectangle
            initialFeatures = initialFeatures(initialFeatures(:,1) >= minX & ...
                initialFeatures(:,2) >= minY & initialFeatures(:,1) <= maxX & ...
                initialFeatures(:,2) <= maxY, :);
            
            % Convert features coordinates from global (on image) to local
            % (in bounding rectangle)
            initialFeatures(:,1) = initialFeatures(:,1) - roiRect(1) + 1;
            initialFeatures(:,2) = initialFeatures(:,2) - roiRect(2) + 1;
            
            % Extract ROI on image
            roi = obj.currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3));
            
            % Find good features in ROI, that additionally fulfill
            % minimal proximity constraints with currently tracked features
            [newFeatures, newEigenvals] = LucasKanadeEngine.findGoodFeatures(roi, obj.extractWindowRadiousY, ...
                obj.extractWindowRadiousY, obj.eigRetainThreshold, obj.minFeatureDistance, initialFeatures, ...
                obj.imageGradientFcnHandle, obj.proximityMapFcnHandle);
            
            % If any new features found
            if size(newFeatures(:,1)) > 0
            
                % Convert new features coordinates to global
                newFeatures(:,1) = newFeatures(:,1) + roiRect(1) - 1;
                newFeatures(:,2) = newFeatures(:,2) + roiRect(2) - 1;

                % Select features that lie inside bounding polygon (make
                % sure that they belong to tracked object)
                inRoi = inpolygon(newFeatures(:,1), newFeatures(:,2), obj.boundingPolygon(:,1), obj.boundingPolygon(:,2));
                newFeatures = newFeatures(inRoi,:);
                newEigenvals = newEigenvals(inRoi,:);

                
                % If more features than neccessary found select the strongest (with the greates minimal
                % eigenvalue)
                if size(newFeatures,1) > supplementSize
                    
                    % Sort features descendingly by their minimal eigenvalues
                    [newEigenvals, sortIdx] = sort(newEigenvals, 'descend');
                    newFeatures = newFeatures(sortIdx, :);
                    % Retain neccassary quantity of features
                    newFeatures = newFeatures(1:supplementSize,:);
                    newEigenvals = newEigenvals(1:supplementSize,:);

                end

                % Append new features to tracked features set
                obj.targetFeatures = [obj.targetFeatures; newFeatures];
                obj.featuresEigenvals = [obj.featuresEigenvals; newEigenvals];

                % Fail if tracked features quantity is less than minimal
                if (size(obj.targetFeatures, 1) < obj.minFeatures)

                    obj.status = false;
                    obj.similarity = 0;
                    return;

                else

                    obj.status = true;
                    
                end
            
            end
            
        end
        
        % Get currently tracked features positions and minimal eigenvalues
        function [features, eigenvals] = getTargetFeatures(obj)
           
            features = obj.targetFeatures;
            eigenvals = obj.featuresEigenvals;
            
        end
        
        % Get current bounding polygon of tracked object
        function boundingPolygon = getBoundingPolygon(obj)
           
            boundingPolygon = obj.boundingPolygon;
            
        end
        
    end
    
end

