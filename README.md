# VisualTrackingAlgorithms

This repository contains algorithms and tracking engines developed as part of my master thesis - Automatic module for tracking of moving object in mobile robotics.

None of the functions require any Matlab's toolboxes (besides test scripts, which depend on Computer Vision toolbox for easy video reading, caputring and playing).

Performance-critical functions were implemented both as Matlab naitive functions and C mex functions. Under Linux systems mex files can be compiled easily from the level of
Matlab console, using `system('make')`.

## List of Matlab functions and modules

- [Lucas-Kanade tracking engine](../master/+trackingModule/LucasKanadeTracker.m)
  - [applyHomography](../master/LucasKanadeEngine/applyHomography.m) - apply homography transformation to the set of points with given homography matrix
  - [computeAffine](../master/LucasKanadeEngine/computeAffine.m) - estimate a affine transformation between two sets of points using The Gold Standard Algorithm 
  - [computeHomography](../master/LucasKanadeEngine/computeHomography.m) - estimate a homography transformation between two sets of points using The Normalized Direct Linear Transformation algorithm
  - [findGoodFeatures](../master/LucasKanadeEngine/findGoodFeatures.m) - find good features to track on the given image using Tomasi-Kanade feature extractor
  - [fitHomography](../master/LucasKanadeEngine/fitHomography.m) - fit a homography transformation between two sets of points using RANSAC algorithm
  - [forwardAdditiveLK](../master/LucasKanadeEngine/forwardAdditiveLK.m) - estimate an optical flow for given set of points and two consequent frames of the video sequence using classic (forward-additive) version of the Lucas-Kanade algorithm
  - [gaussianKernel](../master/LucasKanadeEngine/gaussianKernel.m) - compute Gaussian kernel for the given coordinates
  - [inverseCompositionalLK](../master/LucasKanadeEngine/inverseCompostionalLK.m) - estimate an optical flow for the given set of points and two consequent frames of the video sequence using high performance (inverse-compostional) version of the Lucas-Kanade algorithm
  - [lucasKanadeAlgorithm](../master/LucasKanadeEngine/lucasKanadeAlgorithm.m) - track points between given frames using the Lucas-Kanade algorithm
  - [pyramidalLucasKanade](../master/LucasKanadeEngine/pyramidalLucasKanade.m) - track points between given frames in the scale-space using the pyramidal version of the Lucas-Kanade algorithm
  - [uniformKernel](../master/LucasKanadeEngine/uniformKernel.m) - compute an uniform kernel for the given coordinates
  - [bilinearInterpolate](../master/LucasKanadeEngine/matlab/bilinearInterpolate.m) - interpolate the values of subpixels for the given image using bilinear interpolation 
  - [imageGradient](../master/LucasKanadeEngine/matlab/imageGradient.m) - compute an image gradient for the given set of pixels
  - [imagePyramid](../master/LucasKanadeEngine/matlab/imagePyramid.m) - compute a scale-space representation (image pyramid) of the image
  - [interpolatedGradient](../master/LucasKanadeEngine/matlab/interpolatedGradient.m) - compute an image gradient for the given set of subpixels
  - [proximityMap](../master/LucasKanadeEngine/matlab/proximityMap.m) - find a proximity map for the given coordinates of points
- [MeanShift](../master/+trackingModule/MeanShiftTracker.m) and [CAMShift](../master/+trackingModule/CAMShiftTracker.m) tracking engine
  - [backgroundScalingProfile](../master/MeanShiftEngine/backgorundScalingProfile.m) - compute a profile function of scaling desitiy kernel
  - [CAMShift](../master/MeanShiftEngine/CAMShift.m) - track the target region of interest between frames using the CAMShift algorithm
  - [dEpanechnikovProfile](../master/MeanShiftEngine/dEpanechnikovProfile.m) - compute a derivative of the profile function for Epanechnikov kernel for the given coordinates
  - [dNormalProfile](../master/MeanShiftEngine/dNormalProfile.m) - compute a derivative of the profile function for Gaussian kernel for the given coordinates
  - [epanechnikovProfile](../master/MeanShiftEngine/epanechnikovProfile.m) - compute a profile function for Epanechnikov kernel for the given coordinates
  - [histogramModel](../master/MeanShiftEngine/histogramModel.m) - compute a color-space model (weighted histogram) for the given region of interest
  - [MeanShift](../master/MeanShiftEngine/meanShift.m) - track the target region of interest between frames using the MeanShift algorithm
  - [normalProfile](../master/MeanShiftEngine/normalProfile.m) - compute a profile function for Gaussian kernel for the given coordinates
  - [ratioHistogramModel](../master/MeanShiftEngine/ratioHistogramModel.m) - compute a color-space model (weighted histogram) for the given region of interest with background cancelling 
  - [binIdxMap](../master/MeanShiftEngine/matlab/binIdxMap.m) - compute a map of bin indicies of the histogram for the given image
  - [normalizedWeightedHistogram](../master/MeanShiftEngine/matlab/normalizedWeightedHistogram.m) - compute a normalized weigthed histogram for the given image
  - [pixelWeights](../master/MeanShiftEngine/matlab/pixelWeights.m) - compute a bin weights for the MeanShift algorithm
  - [weightedHistogram](../master/MeanShiftEngine/matlab/weightedHistogram.m) - compute weigthed histogram for the given image
