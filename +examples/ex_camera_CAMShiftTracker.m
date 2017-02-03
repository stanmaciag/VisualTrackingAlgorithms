% This script depends on the Computer Vision System Toolbox and
% the Webcam Support Package (it may be found at:
% https://www.mathworks.com/help/supportpkg/usbwebcams/ug/installing-the-webcams-support-package.html)

%% Clear workspace and initialize the variables

clear;
close all;
clc;

%% Initialize the camera

if ~exist('camera','var');
    camera = webcam;
end

%% Show the input video stream and select ROI

% Successful selection flag
roiCaptured = false;

% Get the first frame
currentFrame = snapshot(camera);

% Disable the border on shown figure
iptsetpref('ImshowBorder','tight');

% Initialize the video player
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

% Show the first frame
frameHandle = figure;
imshow(currentFrame);

% Set handles for handling figure control
set(frameHandle,'WindowButtonDownFcn', @examples.imageFigureControl.imageClickCallback);
set(frameHandle,'WindowButtonUpFcn', @examples.imageFigureControl.imageReleaseCallback);
set(frameHandle,'WindowButtonMotionFcn', @examples.imageFigureControl.imageMovementCallback);
set(frameHandle,'KeyPressFcn', @examples.imageFigureControl.imageKeyPressCallback);

% Initialize the structure storing the cursor position info
data = struct('InitPosImg', zeros(2,1), 'EndPosImg', zeros(2,1), 'CapturingPos', false, ...
    'ImgSize', size(currentFrame), 'CurrentPosImg', zeros(2,1), 'CapturingDone', false);
set(frameHandle,'UserData', data);

% Repeat until ROI is caputered properly
while(~roiCaptured)
    
    % Capture the next frame
    currentFrame = snapshot(camera);

    % Show the next frame
    imshow(currentFrame);
    hold on;

    % If currently capturing the ROI (mouse button is pressed)
    if (frameHandle.UserData.CapturingPos)

        % Initialize the current ROI rectangle
        roiRect = zeros(4,1);

        % Capature the ROI definition
        
        % Case - user is moving cursor to the rigth
        if (frameHandle.UserData.CurrentPosImg(2) >= frameHandle.UserData.InitPosImg(2))

            % Set the ROI initial horizontal coordinate to the initial
            % position of the cursor
            roiRect(1) = frameHandle.UserData.InitPosImg(2);

            % Case - the cursor is at the same spot like at the beginning
            if (frameHandle.UserData.InitPosImg(2) == frameHandle.UserData.CurrentPosImg(2))

                % Set the horizontal size of the ROI to 1px
                roiRect(3) = 1;

            % Case - the cursor is not at the same spot like at the
            % beginning
            else

                % Set the size of the ROI to the cursor's displacement
                roiRect(3) = frameHandle.UserData.CurrentPosImg(2) - frameHandle.UserData.InitPosImg(2);

            end

        % Case - user is moving cursor to the left
        else

            % Set the ROI initial horizontal coordinate to the current
            % position of the cursor
            roiRect(1) = frameHandle.UserData.CurrentPosImg(2);
            
            % Set the horizontal size of the ROI to the cursor's displacement
            roiRect(3) = frameHandle.UserData.InitPosImg(2) - frameHandle.UserData.CurrentPosImg(2);

        end

        % Case - user is moving cursor downwards
        if (frameHandle.UserData.CurrentPosImg(1) >= frameHandle.UserData.InitPosImg(1))

            % Set the ROI initial vertical coordinate to the initial
            % position of the cursor
            roiRect(2) = frameHandle.UserData.InitPosImg(1);

            % Case - the cursor is at the same spot like at the beginning
            if (frameHandle.UserData.InitPosImg(1) == frameHandle.UserData.CurrentPosImg(1))

                % Set the vertical size of the ROI to 1px
                roiRect(4) = 1;

            % Case - the cursor is not at the same spot like at the
            % beginning
            else

                % Set the size of the ROI to the cursor's displacement
                roiRect(4) = frameHandle.UserData.CurrentPosImg(1) - frameHandle.UserData.InitPosImg(1);

            end

        % Case - user is moving cursor upwards
        else

            % Set the ROI initial horizontal coordinate to the current
            % position of the cursor
            roiRect(2) = frameHandle.UserData.CurrentPosImg(1);
            
            % Set the vertical size of the ROI to the cursor's displacement
            roiRect(4) = frameHandle.UserData.InitPosImg(1) - frameHandle.UserData.CurrentPosImg(1);

        end
        
        % Show currently defined ROI
        rectangle('Position', roiRect, 'EdgeColor', 'Red');

    end

    % If the ROI selection is done (the mouse button was released)
    if (frameHandle.UserData.CapturingDone)

        % Set the flag
        roiCaptured = true;
        
        % Draw selected ROI
        rectangle('Position', roiRect, 'EdgeColor', 'Red');

    end
    
end

%% Initialize the tracker and set the parameters

% This example is using the CAMShift tracker. You may want to replace it by
% Lucas-Kande or MeanShift tracker - just modify this section accordingly
% to the other examples.

% If the mex functions are not present the warning will be prompted, it may
% be avoided by setting UseMEX parameter to false
tracker = trackingModule.CAMShiftTracker('UseMEX', true);

% Demo of the tunning possibilities - below every parameter is changed.
% Setting the parameters is not obligartory (default values are present)

% Number of histogram bins per each HSV channel
tracker.setParameter('ModelBins',[16, 8, 8]);
% Computation region bandwidth
tracker.setParameter('BandwidthCompRegion', 2);
% Maximum number of optimization iterations
tracker.setParameter('MaxIterations', 5);
% Stop criteria - threshold displacement
tracker.setParameter('StopThreshold', 1);
% When using ratio histogram (BackgroundCancel parameter is set to true) - value
% of background scaling coefficient
tracker.setParameter('BackgroundScalingFactor', 0.1);
% When using ratio histogram (BackgroundCancel parameter is set to true) -
% bandwidth for background model
tracker.setParameter('BandwidthBackgroundModel', 2);
% Minimal valid size of the tracked object expressed as ratio out of its
% initial size
tracker.setParameter('MinSizeRatio', 0.01);
% Automatic model update enabled
tracker.setParameter('AutoUpdate', false);
% Background canceling (with background proportional model) enabled
tracker.setParameter('BackgroundCancel', false);

%% Focus tracker on the ROI and compute the model
tracker.focus(currentFrame, roiRect);

%% Track object in the ROI (if previous try successful)
while tracker.getStatus
    
    % Capture the next frame
    currentFrame = snapshot(camera);
    
    % Start time measurement
    tic;
    
    % Track object
    tracker.track(currentFrame);
    
    % Get the estimation of object's position, orientation and size
    position = tracker.getPosition;
    orientation = tracker.getOrientation;
    dimensions = tracker.getDimensions;

    % Compute rotation matrix
    rotMatrix = [cos(orientation) -sin(orientation); sin(orientation) cos(orientation)];
    
    % Define the bounding box
    boundingRect(1,:) = [dimensions(1) / 2; dimensions(2) / 2];
    boundingRect(2,:) = [dimensions(1) / 2; -dimensions(2) / 2];
    boundingRect(3,:) = [-dimensions(1) / 2; -dimensions(2) / 2];
    boundingRect(4,:) = [-dimensions(1) / 2; dimensions(2) / 2];
    
    % Rotate the bounding box
    boundingRect(1,:) = rotMatrix*boundingRect(1,:)';
    boundingRect(2,:) = rotMatrix*boundingRect(2,:)';
    boundingRect(3,:) = rotMatrix*boundingRect(3,:)';
    boundingRect(4,:) = rotMatrix*boundingRect(4,:)';
    
    % Translate the bounding box
    boundingRect(1,:) = round([boundingRect(1,1) + position(1); boundingRect(1,2) + position(2)]);
    boundingRect(2,:) = round([boundingRect(2,1) + position(1); boundingRect(2,2) + position(2)]);
    boundingRect(3,:) = round([boundingRect(3,1) + position(1); boundingRect(3,2) + position(2)]);
    boundingRect(4,:) = round([boundingRect(4,1) + position(1); boundingRect(4,2) + position(2)]);
    
    % Finish the time measurement, get the execution time
    currentTime = toc;
    
    % Visualize tracking - put the bounding box into current frame
    currentFrame = insertShape(currentFrame, 'Polygon', [boundingRect(1,1), boundingRect(1,2), ...
        boundingRect(2,1), boundingRect(2,2), boundingRect(3,1), boundingRect(3,2), ...
        boundingRect(4,1), boundingRect(4,2)], 'Color', 'red');
    % Display the current framerate and the similiarity coefficient value
    currentFrame = insertText(currentFrame, [10, 10], [num2str(1/currentTime), ' fps']); 
    currentFrame = insertText(currentFrame, [10, 30], [num2str(tracker.getSimilarity * 100), '%']); 
    
    % Show the current frame
    step(videoPlayer, currentFrame);
    
end
