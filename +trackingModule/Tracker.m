classdef Tracker < handle
    
    properties (SetAccess = protected, GetAccess = protected)
        
        % Last tracked object's position
        position
        
        % Last tracked object's orientation
        orientation
        
        % Last tracked object's dimensions
        dimensions
        
        % Tracking status
        status
        
        % Object similarity 
        similarity
        
    end
    
    methods (Abstract)

        % Select object of interest as content of given region of interest
        % and compute its model
        focus(obj, frame, roiRect)
        
        % Track object on new frame
        track(obj, frame)
        
        % Update object model with information delivered by last frame
        update(obj)
        
    end
   
    methods
        
        function currentPosition = getPosition(obj)
           
            currentPosition = obj.position;
            
        end
        
        function currentOrientation = getOrientation(obj)
           
            currentOrientation = obj.orientation;
            
        end
        
        function currentDimensions = getDimensions(obj)
           
            currentDimensions = obj.dimensions;
            
        end
        
        function currentStatus = getStatus(obj)
           
            currentStatus = obj.status;
            
        end
        
        function currentSimilarity = getSimilarity(obj)
           
            currentSimilarity = obj.similarity;
            
        end
        
        
    end
    
    
end