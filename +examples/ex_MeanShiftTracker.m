% This script depends on the computer vision system toolbox

%% Clear workspace and initialize the variables

clear;
close all;
clc;

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

%% Load the video, initialize player

% This script is using built-in video from the computer vision toolbox, which 
% is also used for testing Matlab's implementation of the CAMShift tracker
% (available at
% https://www.mathworks.com/help/vision/examples/face-detection-and-tracking-using-camshift.html)
videoFileReader = vision.VideoFileReader('visionface.avi');
currentFrame = step(videoFileReader);

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)] + 30]);

%% Show the first frame and get the ROI

h = imshow(currentFrame);

% Wait for the user's input
roiRect = round(getrect);

%% Initialize the tracker and set the parameters

% If the mex functions are not present the warning will be prompted, it may
% be avoided by setting UseMEX parameter to false
tracker = trackingModule.MeanShiftTracker('UseMEX', true);

% Demo of the tunning possibilities - below every parameter is changed.
% Setting the parameters is not obligartory (default values are present)

% Number of histogram bins per each HSV channel
tracker.setParameter('ModelBins',[32, 8, 8]);
% Computation region bandwidth
tracker.setParameter('BandwidthWindow', 1);
% Model update size coefficient
tracker.setParameter('AdaptSizeCoeff', 0.1);
% Model update speed coefficient
tracker.setParameter('AdaptSpeedCoeff', 0.1);
% Maximum number of optimization iterations
tracker.setParameter('MaxIterations', 5);
% Stop criteria - threshold displacement
tracker.setParameter('StopThreshold', 1);
% When using ratio histogram (BackgroundCancel parameter is set to true) - value
% of background scaling coefficien
tracker.setParameter('BackgroundScalingFactor', 0.1);
% When using ratio histogram (BackgroundCancel parameter is set to true) -
% bandwidth for background model
tracker.setParameter('BandwidthBackgroundModel', 2);
% Minimal valid size of the tracked object expressed as ratio out of its
% initial size
tracker.setParameter('MinSizeRatio', 0.01);
% Automatic model update enabled
tracker.setParameter('AutoUpdate', true);
% Background canceling (with background proportional model) enabled
tracker.setParameter('BackgroundCancel', false);

%% Focus tracker on the ROI and compute the model
tracker.focus(currentFrame, roiRect);

%% Track object in the ROI (if previous try successful)
while ~isDone(videoFileReader) && tracker.getStatus
   
    % Increment the frames count
    framesCount = framesCount + 1;
    
    % Get the next frame from the sequence
    currentFrame = step(videoFileReader);
    
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
    
    % Update the best and the worst execution time
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    % Accumulate the execution time
    averageTimeAcc = averageTimeAcc + currentTime;
    
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

%% Finish 
% Compute the average execution time
averageTime = averageTimeAcc / framesCount;

% Display info about execution time
disp(['Average execution time: ' num2str(averageTime) 's']);
disp(['Average framerate: ' num2str(1 / averageTime) 'fps']);
disp(['Minimal execution time: ' num2str(minTime) 's']);
disp(['Maximal execution time: ' num2str(maxTime) 's']);