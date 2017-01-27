
%clear all;
close all;
%clc;

%%

videoFileReader = vision.VideoFileReader('visionface.avi');
currentFrame = step(videoFileReader);
%currentFrameGray = rgb2gray(step(videoFileReader));
%currentFrame = currentFrame(:, 1:520);

%%

h = imshow(currentFrame);
roiRect = round(getrect);
%roiRect = [258, 61, 142, 159];
%roiRect = [270, 100, 30, 30];
hold on;
rectangle('Position',roiRect);

%%

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

tracker = trackingModule.LucasKanadeTracker('UseMEX',true);

tracker.setParameter('MaxTrackingAffineDistortion',4);
tracker.setParameter('MinFeatureDistance',1);
tracker.setParameter('EigRetainThreshold',0.1);
tracker.setParameter('DestFeatures',40);
tracker.setParameter('UpdateThreshold',0.8);

%tracker = trackingModule.CAMShiftTracker('UseMEX',true);
%tracker.setParameter('AutoUpdate',false);

tracker.focus(currentFrame, roiRect);

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

while ~isDone(videoFileReader)
    
    framesCount = framesCount + 1;
    
    currentFrame = step(videoFileReader);
    %currentFrame = currentFrame(:, 1:520);
    %currentFrameGray = rgb2gray(currentFrame);
    
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
    
    currentTime = toc;
    
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
    currentFrame = insertShape(currentFrame, 'Polygon', [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)], 'Color', 'red');
    currentFrame = insertText(currentFrame, [10, 10], [num2str(1/currentTime), ' fps']); 
    currentFrame = insertText(currentFrame, [10, 30], [num2str(tracker.getSimilarity * 100), '%']); 
    %currentFrame = insertMarker(currentFrame, tracker.getTrackedFeatures, '+', 'Color', 'red');
    %currentFrame = insertMarker(currentFrame, currentPosition, '+', 'Color', 'red');
    step(videoPlayer, currentFrame);
    
    %disp([tracker.getSimilarity, size(tracker.getTrackedFeatures,1)]);
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime