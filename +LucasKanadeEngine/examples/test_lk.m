%clear all;
close all;
%clc;

%%

videoFileReader = vision.VideoFileReader('tilted_face.avi');
currentFrame = rgb2gray(step(videoFileReader));
%currentFrame = currentFrame(:, 1:520);

%%

h = imshow(currentFrame);
%roiRect = round(getrect);
roiRect = [258, 61, 142, 159];
%roiRect = [270, 100, 30, 30];
hold on;
rectangle('Position',roiRect);

roi = currentFrame(roiRect(2):roiRect(2) + roiRect(4), roiRect(1):roiRect(1) + roiRect(3));

windowRadiousY = 5;
windowRadiousX = 5;
maxIterations = 3;
stopThreshold = 0.5;
pyramidDepth = 3;
minHessianDet = 1e-6;
%engineFcnHandle = @forwardAdditiveLK;
engineFcnHandle = @inverseCompostionalLK;
weightingKernelFcnHandle = @gaussianKernel;
homographyComputerFcnHandle = @computeAffine;

%%

tic;
features = findGoodFeatures(roi, 1, 1, 0.05, 1);
toc

features(:,1) = features(:,1) + roiRect(1);
features(:,2) = features(:,2) + roiRect(2);

plot(features(:,1), features(:,2), 'r+');

%%

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(currentFrame, 2), size(currentFrame, 1)]+30]);

framesCount = 0;
minTime = Inf;
maxTime = 0;
averageTimeAcc = 0;

p = [roiRect(1), roiRect(2); ...
    roiRect(1) + roiRect(3), roiRect(2); ...
    roiRect(1) + roiRect(3), roiRect(2) + roiRect(4); ...
    roiRect(1), roiRect(2) + roiRect(4)];


previousFeatures = features;
idx = 1:size(previousFeatures);

while ~isDone(videoFileReader)
    
    framesCount = framesCount + 1;
    
    previousFrame = currentFrame;
    currentFrame = rgb2gray(step(videoFileReader));
    %currentFrame = currentFrame(:, 1:520);
    
    tic;
    
    [flow, featuresIdx] = pyramidalLucasKanade(previousFrame, currentFrame, features, windowRadiousY, ...
         windowRadiousX, maxIterations, stopThreshold, pyramidDepth, minHessianDet, engineFcnHandle, weightingKernelFcnHandle);
    
    %flow = lucasKanadeAlgorithm(previousFrame, currentFrame, features, windowRadiousY, ...
    %    windowRadiousX, maxIterations, stopThreshold, weightingKernelFcnHandle, engineFcnHandle);
  
    features = features(featuresIdx, :);
    flow = flow(featuresIdx, :);
    previousFeatures = features;
    features = features + flow;
    
    %tic
    [H, idx]  = fitHomography(previousFeatures, features, 5, homographyComputerFcnHandle);
    %toc

    previousFeatures = previousFeatures(idx,:);
    features = features(idx,:);
    
    
    p2 = applyHomography(p, H);
    p = p2;
    
    
    currentTime = toc;
    
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
    videoFrame = insertMarker(currentFrame, features, '+', 'Color', 'red');
    %videoFrame = insertMarker(videoFrame, features, '+', 'Color', 'red');
    videoFrame = insertShape(videoFrame, 'Polygon', [p2(1,1), p2(1,2), p2(2,1), p2(2,2), p2(3,1), p2(3,2), p2(4,1), p2(4,2)], 'Color', 'blue');
    step(videoPlayer, videoFrame);
    
    %f1(framesCount, :) = flow(1,:);
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime