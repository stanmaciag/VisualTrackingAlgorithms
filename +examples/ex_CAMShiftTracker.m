%% CAMShift tracker example
% This script demonstrates the CAMShift tracker. For this purpose it
% uses built-in video from the Computer Vision Toolbox, that is also being
% used for testing Matlab's implementation of the CAMShift tracker (see 
% https://www.mathworks.com/help/vision/examples/face-detection-and-tracking-using-camshift.html
% for more details).
% After initialization the first frame of the video is shown and the
% script awaits selection of the ROI (defined as boudning rectangle).
% Afterwads, all the available tracker parameters are tuned and the ROI is 
% being tracked until the end of the video sequence. Finally, timing stats
% are displayed. 
% 
% Run this script from the root level of the repositiory.
%
% External requirements:
% - Computer Vision Toolbox
% - Image Processing Toolbox

%% Clear workspace and initialize the variables

clear;
close all;
clc;

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

%% Load the video, initialize player

% Use built-in video by default
videoFileReader = vision.VideoFileReader('visionface.avi');
currentFrame = videoFileReader.step;

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)] + 30]);

%% Show the first frame and get the ROI

h = imshow(currentFrame);

% Wait for the user's input
roiRect = round(getrect);

%% Initialize the tracker and set the parameters

% If the mex functions are not present the warning will be prompted, it may
% be avoided by setting UseMEX parameter to false
tracker = trackingModule.CAMShiftTracker('UseMEX', true);

% Demo of the tunning possibilities - below every parameter is changed.
% Setting the parameters is not obligartory (default values are present)

% Number of histogram bins per each HSV channel
tracker.setParameter('ModelBins',[32, 8, 8]);
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
while ~videoFileReader.isDone && tracker.getStatus
   
    % Increment the frames count
    framesCount = framesCount + 1;
    
    % Get the next frame from the sequence
    currentFrame = videoFileReader.step;
    
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
    videoPlayer.step(currentFrame);
    
end

%% Finish 
% Compute the average execution time
averageTime = averageTimeAcc / framesCount;

% Display info about execution time
disp(['Average execution time: ' num2str(averageTime) 's']);
disp(['Average framerate: ' num2str(1 / averageTime) 'fps']);
disp(['Minimal execution time: ' num2str(minTime) 's']);
disp(['Maximal execution time: ' num2str(maxTime) 's']);