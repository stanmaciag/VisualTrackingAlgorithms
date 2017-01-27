# VisualTrackingAlgorithms

This repository contains algorithms and tracking engines developed as part of my master thesis - Automatic module for tracking of moving object in mobile robotics.

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

## References

1. Allen, J. G.; Xu, R. Y. D. & Jin, J. S. Object tracking using CamShift algorithm and multiple quantized feature spaces Proceedings of the Pan-Sydney area workshop on visual information processing, 2006, 36, 3 - 7
2. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying Framework International Journal of Computer Vision, 2004, 56, 221-255
3. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature tracker - Description of the algorithm Intel Corporation - Microprocessor Research Labs, 2000
4. Bradski, G. R. Real time face and object tracking as a component of a perceptual user interface Fourth IEEE Workshop Applications of Computer Vision (WACV), IEEE, 1998, 214 - 219
5. Comaniciu, D.; Ramesh, V. & Meer, P. Kernel-based object tracking IEEE Transactions on Pattern Analysis and Machine Intelligence, 2003, 25, 564 - 577
6. Comaniciu, D.; Ramesh, V. & Meer, P. Real-time tracking of non-rigid objects using mean shift Proceedings. IEEE Conference on Computer Vision and Pattern Recognition, 2000, 2, 142 - 149
7. Hartley, R. & Zisserman, A. Multiple View Geometry in Computer Vision Cambridge University Press, 2004
8. Lucas, B. D. & Kanade, T. An iterative image registration technique with an application to stereo vision 7th International Joint Conference on Artificial intelligence (IJCAI), Morgan Kaufmann Publishers, 1981, 2, 674 - 679
9. Shi, J. & Tomasi, C. Good features to track Computer Society Conference on Computer Vision and Pattern Recognition (CVPR), IEEE, 1994, 593 - 600
10. Tomasi, C. & Kanade, T. Detection and Tracking of Point Features School of Computer Science Carnegie Mellon University, 1991 

