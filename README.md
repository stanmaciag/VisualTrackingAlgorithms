# VisualTrackingAlgorithms

This repository contains algorithms and tracking engines developed as part of my master thesis - Automatic module for tracking of moving object in mobile robotics.

None of the functions require any Matlab's toolboxes (besides test scripts, which depend on Computer Vision toolbox for easy video reading, caputring and playing).

Performance-critical functions were implemented both as Matlab naitive functions and C mex functions. Under Linux systems mex files can be compiled easily from the level of
Matlab console, using `system('make')`.

## List of Matlab functions and modules

- Lucas-Kanade tracking engine (trackingModule/LucasKanadeTracker.m)
  - apply homography transformation to set of points with given homography matrix (../blob/master/LucasKanadeEngine/applyHomography.m)
  - estimate affine transformation between two sets of points using The Gold Standard Algorithm (LucasKanadeEngine/computeAffine)
  - estimate homography transformation between two sets of points using The Normalized Direct Linear Transformation algorithm (LucasKanadeEngine/computeHomography)
  - find good features to track on the given image using Tomasi-Kanade feature extractor (LucasKanadeEngine/findGoodFeatures)
  - fit homography transformation between two sets of points using RANSAC algorithm (LucasKanadeEngine/fitHomography)
  - estimate optical flow for given set of points and two consequent frames of the video sequence using classic (forward-additive) version of the Lucas-Kanade algorithm (LucasKanadeEngine/forwardAdditiveLK)
  - compute Gaussian kernel for given coordinates (LucasKanadeEngine/gaussianKernel)
  - estimate optical flow for given set of points and two consequent frames of the video sequence using high performance (inverse-compostional) version of the Lucas-Kanade algorithm (LucasKanadeEngine/inverseCompositionalLK)
  - track points between given frames using Lucas-Kanade algorithm (LucasKanadeEngine/lucasKanadeAlgorithm)
  - track points between given frames in the scale-space using pyramidal version of the Lucas-Kanade algorithm (LucasKanadeEngine.pyramidalLucasKanade)
  - compute uniform kernel for the given coordinates (LucasKanadeEngine/uniformKernel)
  - interpolate values of subpixels for the given image using bilinear interpolation (LucasKanadeEngine/matlab/bilinearInterpolate and LucasKanadeEngine/mex/bilinearInterpolate)
  - compute image gradient for the given set of pixels (LucasKanadeEngine/matlab/imageGradient and LucasKanadeEngine/mex/imageGradient)
  - compute scale-space representation (image pyramid) of the image (LucasKanadeEngine/matlab/imagePyramid and LucasKanadeEngine/mex/imagePyramid)
  - compute image gradient for the given set of subpixels (LucasKanadeEngine/matlab/interpolatedGradient and LucasKanadeEngine/mex/interpolatedGradient)
  - find proximity map for the given coordinates of points (LucasKanadeEngine/matlab/proximityMap and LucasKanadeEngine/mex/proximityMap)
- MeanShift/CAMShift tracking engine (trackingModule.MeanShiftTracker and trackingModule.CAMShiftTracker)
  - compute profile function of scaling desitiy kernel (MeanShiftEngine/backgroundScalingProfile)
  - track target region of interest between frames using CAMShift algorithm (MeanShiftEngine/CAMShift)
  - compute derivative of the profile function for Epanechnikov kernel for the given coordinates (MeanShiftEngine/dEpanechnikovProfile)
  - compute derivative of the profile function for Gaussian kernel for the given coordinates (MeanShiftEngine/dNormalProfile)
  - compute the profile function for Epanechnikov kernel for the given coordinates (MeanShiftEngine/epanechnikovProfile)
  - compute color-space model (weighted histogram) for the given region of interest (MeanShiftEngine/histogramModel)
  - track target region of interest between frames using MeanShift algorithm (MeanShiftEngine/MeanShift)
  - compute the profile function for Gaussian kernel for the given coordinates (MeanShiftEngine/normalProfile)
  - compute color-space model (weighted histogram) for the given region of interest with background cancelling (MeanShiftEngine/ratioHistogramModel)
  - compute map of bin indicies of the histogram for the given image (MeanShiftEngine/matlab/binIdxMap and MeanShiftEngine/mex/binIdxMap)
  - compute normalized weigthed histogram for the given image (MeanShiftEngine/matlab/normalizedWeightedHistogram and MeanShiftEngine/mex/normalizedWeightedHistogram)
  - compute bin weights for the MeanShift algorithm (MeanShiftEngine/matlab/pixelWeights and MeanShiftEngine/mex/pixelWeights)
  - compute weigthed histogram for the given image (MeanShiftEngine/matlab/weightedHistogram and MeanShiftEngine/mex/weightedHistogram)
