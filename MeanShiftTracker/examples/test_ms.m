%clear all;
close all;
%clc;

%%
videoFileReader = vision.VideoFileReader('tilted_face.avi');
currentFrame = step(videoFileReader);
currentFrameHSV = rgb2hsv(currentFrame);

bins = [16, 12, 12];
windowBandwidth = 1;
maxIterations = 10;
threshold = 1;
gamma = 0.2;
windowDeltaSize = 0.1;

idxMapFcnHandle = @binIdxMap;
histogramFcnHandle = @normalizedWeightedHistogram_mex;
pixelWeightsFcnHandle = @pixelWeights_mex;

%%

h = imshow(currentFrame);
%roiRect = round(getrect);
roiRect = [258, 61, 142, 159];
hold on;
roi = currentFrameHSV(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3), :);


%%

%clear targetModel;
targetModel = histogramModel(currentFrameHSV, roiRect, @epanechnikovProfile, bins, idxMapFcnHandle, histogramFcnHandle);
targetPosition = [round(roiRect(2) + roiRect(4)/2), round(roiRect(1) + roiRect(3)/2)];

%%

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

while ~isDone(videoFileReader)
    
    framesCount = framesCount + 1;
   
    currentFrame = step(videoFileReader);
    currentFrameHSV = rgb2hsv(currentFrame);
    
    tic;
    
    windowDelta = windowDeltaSize * windowBandwidth;
    newWindowBandwidth = [windowBandwidth, windowBandwidth + windowDelta, windowBandwidth - windowDelta];

    [currentPosition1, similarityCoeff1, candidateModel1] = meanShift(currentFrameHSV, targetPosition, ...
        targetModel, newWindowBandwidth(1), @epanechnikovProfile, @dEpanechnikovProfile, maxIterations, threshold, ...
        idxMapFcnHandle, histogramFcnHandle, pixelWeightsFcnHandle);
    [currentPosition2, similarityCoeff2, candidateModel2] = meanShift(currentFrameHSV, targetPosition, ...
        targetModel, newWindowBandwidth(2), @epanechnikovProfile, @dEpanechnikovProfile, maxIterations, threshold, ...
        idxMapFcnHandle, histogramFcnHandle, pixelWeightsFcnHandle);
    [currentPosition3, similarityCoeff3, candidateModel3] = meanShift(currentFrameHSV, targetPosition, ...
        targetModel, newWindowBandwidth(3), @epanechnikovProfile, @dEpanechnikovProfile, maxIterations, threshold, ...
        idxMapFcnHandle, histogramFcnHandle, pixelWeightsFcnHandle);
    
    [maxSimilarityCoeff, maxIdx] = max([similarityCoeff1, similarityCoeff2, similarityCoeff3]);
    currentPosition = [currentPosition1; currentPosition2; currentPosition3];
    
    windowBandwidth = gamma * newWindowBandwidth(maxIdx) + (1 - gamma) * windowBandwidth;
    targetPosition = currentPosition(maxIdx, :);

    currentTime = toc;
    
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
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
    
    %boundingRect = [targetPosition(2) - roiRect(3)/2 , targetPosition(1) - roiRect(4)/2, roiRect(3), roiRect(4)];
    boundingRect = [targetPosition(2) - roiRect(3)/2  * windowBandwidth , targetPosition(1) - roiRect(4)/2  * windowBandwidth, ...
        roiRect(3) * windowBandwidth, roiRect(4) * windowBandwidth]; 
    
    %videoFrame = insertShape(currentFrame, 'Polygon', [p1(1), p1(2), p2(1), p2(2), p3(1), p3(2), p4(1), p4(2)], 'Color', 'red');
    currentFrame = insertShape(currentFrame, 'Rectangle', boundingRect, 'Color', 'red');
    step(videoPlayer, currentFrame);
    
    
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime