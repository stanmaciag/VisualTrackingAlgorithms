clear all;
close all;
clc;

%%

videoFileReader = vision.VideoFileReader('tilted_face.avi');
currentFrame = rgb2gray(step(videoFileReader));

%%

h = imshow(currentFrame);
%roiRect = round(getrect);
roiRect = [258, 61, 142, 159];
hold on;
rectangle('Position',roiRect);

roi = currentFrame(roiRect(1):roiRect(1) + roiRect(3), roiRect(2):roiRect(2) + roiRect(4));

%%

features = findGoodFeatures(roi, 2, 2, 0.2, 5);
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

while ~isDone(videoFileReader)
    
    framesCount = framesCount + 1;
    
    previousFrame = currentFrame;
    currentFrame = rgb2gray(step(videoFileReader));

    tic;
    
    %flow = forwardAdditiveLK(previousFrame, currentFrame, features, windowRadiousY, windowRadiousX, 5, 0.5, @gaussianKernel, initialOpticalFlow);
    flow = pyramidalLucasKanade(previousFrame, currentFrame, features, windowRadiousY, windowRadiousX, 5, 0.5, 3, @forwardAdditiveLK, @gaussianKernel);
    %flow = inverseCompostionalLK(previousFrame, currentFrame, features, windowRadiousY, windowRadiousX, 5, 0.5, @gaussianKernel, initialOpticalFlow);
    %flow = pyramidalLucasKanade(previousFrame, currentFrame, features, windowRadiousY, windowRadiousX, 5, 0.5, 3, @inverseCompostionalLK, @gaussianKernel);
    features = features + flow;
    
    currentTime = toc;
    
    minTime = min(currentTime, minTime);
    maxTime = max(currentTime, maxTime);
    
    averageTimeAcc = averageTimeAcc + currentTime;
    
    videoFrame = insertMarker(currentFrame, features, '+', 'Color', 'red');
    step(videoPlayer, videoFrame);
    
end

averageTime = averageTimeAcc / framesCount
minTime
maxTime