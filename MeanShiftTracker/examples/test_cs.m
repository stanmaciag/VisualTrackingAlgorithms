clear all;
close all;
clc;

%%

videoFileReader = vision.VideoFileReader('tilted_face.avi');
currentFrame = step(videoFileReader);
currentFrameHSV = rgb2hsv(currentFrame);

bins = [16; 16; 16];
computationRegionBandwidth = 3;
maxIterations = 10;
threshold = 1;
minRadious = 20;
scalingFactor = 4;
modelBandwidth = 4;

idxMapFcnHandle = @binIdxMap;
histogramFcnHandle = @weightedHistogram_mex;

%%

h = imshow(currentFrame);
roiRect = round(getrect);
%roiRect = [258, 61, 142, 159];
%roiRect = [200, 100, 20, 30];
hold on;
rectangle('Position', roiRect, 'EdgeColor', 'red');
hold off;


roi = currentFrameHSV(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3), :);

%%

targetModel = histogramModel(currentFrameHSV, roiRect, @epanechnikovProfile, bins, idxMapFcnHandle, histogramFcnHandle);
%targetModel = ratioHistogramModel(currentFrameHSV, roiRect, @epanechnikovProfile, @backgorundScalingProfile, bins, modelBandwidth, scalingFactor, idxMapFcnHandle, histogramFcnHandle);
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
    %currentFrame = currentFrame(:,1:size(currentFrame,2) - 200, :);
    currentFrameHSV = rgb2hsv(currentFrame);
    
    tic;
    [currentPosition, targetModel, theta, dimensions] = CAMShift(currentFrameHSV, targetModel, currentPosition, computationRegionBandwidth, maxIterations, threshold, minRadious, idxMapFcnHandle);
    
    currentTime = toc;
    
    rotMatrix = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    p1 = [dimensions(2); dimensions(1)];
    p2 = [dimensions(2); -dimensions(1)];
    p3 = [-dimensions(2); -dimensions(1)];
    p4 = [-dimensions(2); dimensions(1)];
    
    p1 = rotMatrix*p1;
    p2 = rotMatrix*p2;
    p3 = rotMatrix*p3;
    p4 = rotMatrix*p4;
    
    p1 = round([p1(1) + currentPosition(2); p1(2) + currentPosition(1)]);
    p2 = round([p2(1) + currentPosition(2); p2(2) + currentPosition(1)]);
    p3 = round([p3(1) + currentPosition(2); p3(2) + currentPosition(1)]);
    p4 = round([p4(1) + currentPosition(2); p4(2) + currentPosition(1)]);
    
    boundingRect = [currentPosition(2) - targetModel.horizontalRadious , currentPosition(1) - targetModel.verticalRadious, ...
        2 * targetModel.horizontalRadious + 1, 2 * targetModel.verticalRadious + 1];
  
    currentFrame = insertShape(currentFrame, 'Polygon', [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)], 'Color', 'red');
    currentFrame = insertShape(currentFrame, 'Rectangle', boundingRect, 'Color', 'blue');
    step(videoPlayer, currentFrame);

    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime