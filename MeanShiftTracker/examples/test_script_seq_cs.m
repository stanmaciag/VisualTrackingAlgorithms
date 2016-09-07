%clear all;
close all;
%clc;

%%

%video = VideoReader('tilted_face.avi');
%currentFrame = rgb2gray(readFrame(video));
%imresize(currentFrame, [320 480]);

videoFileReader = vision.VideoFileReader('tilted_face.avi');
currentFrame = step(videoFileReader);
currentFrameHSV = rgb2hsv(currentFrame);

bins = [16; 16; 16];
searchWindowBandwidth = 1.5;
computationRegionBandwidth = 2;
maxIterations = 10;
threshold = 1;

idxMapFcnHandle = @binIdxMap;
histogramFcnHandle = @mexWeightedHistogram;

%%

%h = imshow(currentFrame);
%roiRect = round(getrect);
roiRect = [258, 61, 142, 159];
%hold on;
%currentFrame = im2uint8(currentFrame);
%roi = currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3), :);
roi = currentFrameHSV(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3), :);

%%

clear targetModel;
targetModel = histogramModel(roi, @epanechnikovKernelProfile, bins, idxMapFcnHandle, histogramFcnHandle);
targetPosition = [round(roiRect(2) + roiRect(4)/2), round(roiRect(1) + roiRect(3)/2)];

%%

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

currentPosition = targetPosition;

while ~isDone(videoFileReader)
    
    framesCount = framesCount + 1;
    %tic;
    currentFrame = step(videoFileReader);
    currentFrameHSV = rgb2hsv(currentFrame);
    
    tic;
    [currentPosition, targetModel] = CAMShift(currentFrameHSV, targetModel, currentPosition, maxIterations, threshold, idxMapFcnHandle);

    %targetPosition = currentPosition;

    currentTime = toc;
    
   
    %x1 = round(targetPosition(2) - roiRect(3)/2);
    %y1 = round(targetPosition(1) - roiRect(4)/2);
    %x2 = round(targetPosition(2) + roiRect(3)/2);
    %y2 = round(targetPosition(1) - roiRect(4)/2);
    %x3 = round(targetPosition(2) + roiRect(3)/2);
    %y3 = round(targetPosition(1) + roiRect(4)/2);
    %x4 = round(targetPosition(2) - roiRect(3)/2);
    %y4 = round(targetPosition(1) + roiRect(4)/2);
    %rotMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    %p1 = [roiRect(3)/2; roiRect(4)/2];
    %p2 = [roiRect(3)/2; -roiRect(4)/2];
    %p3 = [-roiRect(3)/2; -roiRect(4)/2];
    %p4 = [-roiRect(3)/2; roiRect(4)/2];
    
    %p1 = rotMatrix*p1;
    %p2 = rotMatrix*p2;
    %p3 = rotMatrix*p3;
    %p4 = rotMatrix*p4;
    
    %p1 = round([p1(1) + targetPosition(2); p1(2) + targetPosition(1)]);
    %p2 = round([p2(1) + targetPosition(2); p2(2) + targetPosition(1)]);
    %p3 = round([p3(1) + targetPosition(2); p3(2) + targetPosition(1)]);
    %p4 = round([p4(1) + targetPosition(2); p4(2) + targetPosition(1)]);
    
    boundingRect = [currentPosition(2) - targetModel.horizontalRadious , currentPosition(1) - targetModel.verticalRadious, ...
        2 * targetModel.horizontalRadious + 1, 2 * targetModel.verticalRadious + 1];
    %boundingRect = [targetPosition(2) - roiRect(3)/2  * windowBandwidth , targetPosition(1) - roiRect(4)/2  * windowBandwidth, ...
    %    roiRect(3) * windowBandwidth, roiRect(4) * windowBandwidth]; 
    
    %videoFrame = insertShape(currentFrame, 'Polygon', [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)], 'Color', 'red');
    videoFrame = insertShape(currentFrame, 'Rectangle', boundingRect, 'Color', 'red');
    step(videoPlayer, videoFrame);
    
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime