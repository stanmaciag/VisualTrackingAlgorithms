%clear all;
close all;
clc;

%% Initialize camera

if ~exist('camera','var');
    camera = webcam;
end



videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

%% Select ROI

roiCaptured = false;

currentFrame = snapshot(camera);
iptsetpref('ImshowBorder','tight');

frameHandle = figure;
imshow(currentFrame);

set(frameHandle,'WindowButtonDownFcn', @imageClickCallback);
set(frameHandle,'WindowButtonUpFcn', @imageReleaseCallback);
set(frameHandle,'WindowButtonMotionFcn', @imageMovementCallback);
set(frameHandle,'KeyPressFcn', @imageKeyPressCallback);

data = struct('InitPosImg', zeros(2,1), 'EndPosImg', zeros(2,1), 'CapturingPos', false, ...
    'ImgSize', size(currentFrame), 'CurrentPosImg', zeros(2,1), 'CapturingDone', false);
set(frameHandle,'UserData', data);


while(~roiCaptured)
    
    
    currentFrame = snapshot(camera);
    imshow(currentFrame);
    hold on;
    
    if (frameHandle.UserData.CapturingPos)
       
        roiRect = zeros(4,1);
        
        if (frameHandle.UserData.CurrentPosImg(2) >= frameHandle.UserData.InitPosImg(2))
           
            roiRect(1) = frameHandle.UserData.InitPosImg(2);
            
            if (frameHandle.UserData.InitPosImg(2) == frameHandle.UserData.CurrentPosImg(2))
            
                roiRect(3) = 1;
                
            else
                
                roiRect(3) = frameHandle.UserData.CurrentPosImg(2) - frameHandle.UserData.InitPosImg(2);
            
            end
            
        else
        
            roiRect(1) = frameHandle.UserData.CurrentPosImg(2);
            roiRect(3) = frameHandle.UserData.InitPosImg(2) - frameHandle.UserData.CurrentPosImg(2);
            
        end
        
       if (frameHandle.UserData.CurrentPosImg(1) >= frameHandle.UserData.InitPosImg(1))
           
            roiRect(2) = frameHandle.UserData.InitPosImg(1);
            
            if (frameHandle.UserData.InitPosImg(1) == frameHandle.UserData.CurrentPosImg(1))
            
                roiRect(4) = 1;
                
            else
                
                roiRect(4) = frameHandle.UserData.CurrentPosImg(1) - frameHandle.UserData.InitPosImg(1);
            
            end
            
        else
        
            roiRect(2) = frameHandle.UserData.CurrentPosImg(1);
            roiRect(4) = frameHandle.UserData.InitPosImg(1) - frameHandle.UserData.CurrentPosImg(1);
            
        end
        
        
        rectangle('Position', roiRect, 'EdgeColor', 'Red');
        
    end
    
    if (frameHandle.UserData.CapturingDone)
           
        roiCaptured = true;
        rectangle('Position', roiRect, 'EdgeColor', 'Red');

    end
    
end

%% Compute object model

tracker = trackingModule.LucasKanadeTracker;

tracker.setParameter('MaxTrackingAffineDistortion',4);
tracker.setParameter('MinFeatureDistance',3);
tracker.setParameter('DestFeatures',40);
tracker.setParameter('UpdateThreshold', 0.8);
tracker.setParameter('EigRetainThreshold',0.1);

tracker.focus(currentFrame, roiRect);


%%

while tracker.getStatus
    
    
    currentFrame = snapshot(camera);
    
    tic;
    
    tracker.track(currentFrame);
    
    dimensions = tracker.getDimensions;
    orientation = tracker.getOrientation;
    currentPosition = tracker.getPosition;
    
    rotMatrix = [cos(orientation) -sin(orientation); sin(orientation) cos(orientation)];
    
    p1 = [dimensions(1) / 2; dimensions(2) / 2];
    p2 = [dimensions(1) / 2; -dimensions(2) / 2];
    p3 = [-dimensions(1) / 2; -dimensions(2) / 2];
    p4 = [-dimensions(1) / 2; dimensions(2) / 2];
    
    p1 = rotMatrix*p1;
    p2 = rotMatrix*p2;
    p3 = rotMatrix*p3;
    p4 = rotMatrix*p4;
    
    p1 = round([p1(1) + currentPosition(1); p1(2) + currentPosition(2)]);
    p2 = round([p2(1) + currentPosition(1); p2(2) + currentPosition(2)]);
    p3 = round([p3(1) + currentPosition(1); p3(2) + currentPosition(2)]);
    p4 = round([p4(1) + currentPosition(1); p4(2) + currentPosition(2)]);
    
    p = tracker.getBoundingPolygon;
    
    currentTime = toc;
    
    currentFrame = insertShape(currentFrame, 'Polygon', [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)], 'Color', 'red');
    
    currentFrame = insertText(currentFrame, [10, 30], [num2str(tracker.getSimilarity * 100), '%']); 
    currentFrame = insertMarker(currentFrame, tracker.getTrackedFeatures, '+', 'Color', 'blue');
    %currentFrame = insertShape(currentFrame, 'Polygon', [p(1), p(2), p(1), p(2), p(1), p(2), p(1), p(2)], 'Color', 'green');
    
    
    currentFrame = insertText(currentFrame, [10, 10], [num2str(1/currentTime), ' fps']);
    %imshow(currentFrame);

    step(videoPlayer, currentFrame);
    
end
