# VisualTrackingAlgorithms

## Introduction

This repository contains algorithms and tracking engines developed as part of my master's thesis - *Automatic Module for Tracking of Moving Object in Mobile Robotics*. The thesis itself could be found at its [repository](https://github.com/maciag/AutomaticTrackingModuleThesis). As it is written in Polish language, some of its key aspects are summarized below.

The purpose of the thesis was to:

+ describe the theory of visual object tracking
+ describe interrelated issues from the field of image processing 
+ identify and describe methods that are currently in use in mobile robotics
+ design and implement tracking module for mobile robotics

Although very interesting, neither the theory of object tracking nor the theory of image processing will be covered here. If you are looking for a reliable source of knowledge from that field, you may find [thesis references](https://github.com/maciag/AutomaticTrackingModuleThesis/blob/master/README.md) useful. It also includes the references to papers describing an individual tracking methods. The extensive description of the algorithms implemented in this repository is available in the selected papers [listed  below](#references).

## Visual tracking algorithms in the mobile robotics

Generally speaking, the problem of tracking is the problem of estimation its evolving state, which is defined in this case as a set of state variables describing the motion of the object. The observation of the state is considered to be uncertain and the type of motion is unknown. This reservations are doubly significant in the case of mobile robotics, where the apparent motion of the object, registered by the vision sensor, is in fact a superposition of the actual object's motion and the motion of robot itself. Additionally, some piece of information about the object's motion is lost, due to projection from 3 dimensional space to image plane. The task of tracking is also straitened by relatively low processing power of an on-board computational units and occurrence of the following phenomena:

+ presence of noise on the registered images
+ partial or total occlusion of the object
+ dynamic changes of observed scene's illumination

In general, two approaches to the visual tracking in the context of mobile robotics can be distinguished:

+ Methods that perform optimization task for finding the most probable occurrence of certain object's representation on the subsequent frames
+ Methods that estimates the future state of the object using the Bayesian interface, accordingly to the assumed state-space model of its behavior and some kind of state measurement

The first group of methods is very diversified, but its three leading algorithms can be indicated - the Lucas-Kanade algorithm, the MeanShift method and the CAMShift method. The Lucas-Kanade algorithm resolves the problem of optical flow estimation (in its most popular application). The MeanShift and the CAMShift algorithms are methods for finding the local maxima of the probability density function. Because of their prospective performance, this three method were selected as engine algorithms for tracking modules developed as part of the thesis.

In the second group the most important methods are Kalman filer and particle filter. Their biggest drawback is the need for implementation of state measurement utility. In case of visual tracking the state describes the trajectory of the object, which means that measurement has to be able to find current position of the object on the current frame, therefor it needs to recognize the object. Without any specific assumptions, the problem of object recognition is computationally expensive, so it should be avoided if possible. For that reason methods from the second group are not well-suited as core tracker engines and they were not applied in the thesis. Nevertheless, it appears that their conjunction with the methods from the first group could make the tracking engine much more robust, so they represent interesting perspective of further development.

## Tracking modules

The tracking module is interpreted here as a complete software unit providing the following functionalities:

+ input data is provided as the region of interest (bounding rectangle) that contains the tracked object
+ the module estimates the position of the tracked object and it is able to perform that task in the long time period
+ the module also returns the size and the orientation (rotation around the axis perpendicular to the image plane) of the tracked object
+ tracking certinty metrics is provided
+ in the case of failure the tracking task is terminated

The main algorithm workflow is shown in the figure below:

![Main algorithm workflow](https://cdn.rawgit.com/maciag/6b607bf23aeaf2eb05a440a5813c40bf/raw/893a7da1ba2f52b275f091210a2a383cbffc9baf/tracking_module.svg)

It consists of three main steps:

1. Focus - initial stage, input data in the form of selected ROI are processed to the object's model and its initial position
2. Track - basic stage, input data in the form of previous object's position, its model and the following frame are used for estimating object's following position, orientation and size, also returns the similarity coefficient (that describes the similarity between initial and current object's model) and the status of tracking task
3. Update - optional stage, adapts the object's model based on its previous form and information introduced by the following frame

The second stage (and the third stage, optionally) are executed iteratively for every captured frame of the video sequence. 

The virtual class [VisualTracker](../master/+trackingModule/VisualTracker.m) provides an interface for the implementation of the workflow above.


## Running the code

### MEX files

Some of the core functions were implemented both as Matlab native functions and MEX functions, using the C language. Although improving the performance of well-vectorized Matlab native code is rather challenging, some parts of tracking algorithms are very hard to vectorize (which means that vectorization requires a significant overhead), whereas they can be accomplished very easily using loop structures. In such a case MEX functions are convenient and efficient solution. 

To compile MEX functions under Unix/Linux system just call `make` command from the root level of the repository in the system terminal (or `system('make')` in Matlab's console). You may need to modify makefile and change the path to the GCC compiler (if it differs from the default). Note that MEX compiler currently supports only the version 4.7 (not newer), so make sure that you have it installed. More details about compiling the MEX files could be found in [Matlab's documentation](https://www.mathworks.com/help/matlab/ref/mex.html).

The engines are able to select variant of functions in use. By default they use MEX functions if they are present, passing parameter `UseMEX` with value `false` to the tracker's constructor or to `setParameter()` method will force to use Matlab native variant.

### Requirements

Matlab R2016a (9.0) was used to develop Matlab's packages from this repository, compatibility with any older version is not guaranteed. In particular any version below R2008a (7.6) will not work, because of usage of object oriented concepts (see [Matlab's documentation](https://www.mathworks.com/help/matlab/object-oriented-design-with-matlab.html) for more details). 

Tracking engines depend on Image Processing Toolbox (tested with version 9.4). Example scripts additionally depend on Computer Vision System Toolbox (tested with version 7.1), for easy video loading and playing. [Example with the camera input](../master/+examples/ex_camera_CAMShiftTracker.m) uses [Support Package for USB Webcams](https://www.mathworks.com/help/supportpkg/usbwebcams/index.html). 

## List of repository content

### [Examples package](../master/+examples)

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
1. Baker, S. & Matthews, I. Lucas-Kanade 20 Years On: A Unifying Framework International Journal of Computer Vision, 2004, 56, 221-255
1. Bouguet, J.-Y. Pyramidal implementation of the Lucas Kanade feature tracker - Description of the algorithm Intel Corporation - Microprocessor Research Labs, 2000
1. Bradski, G. R. Real time face and object tracking as a component of a perceptual user interface Fourth IEEE Workshop Applications of Computer Vision (WACV), IEEE, 1998, 214 - 219
1. Comaniciu, D.; Ramesh, V. & Meer, P. Kernel-based object tracking IEEE Transactions on Pattern Analysis and Machine Intelligence, 2003, 25, 564 - 577
1. Comaniciu, D. & Meer, P. Mean shift analysis and applications The Proceedings of the Seventh IEEE International Conference on Computer Vision, IEEE, 1999, 2, 1197 - 1203
1.  Comaniciu, D.; Ramesh, V. & Meer, P. Real-time tracking of non-rigid objects using mean shift Proceedings. IEEE Conference on Computer Vision and Pattern Recognition, 2000, 2, 142 - 149
1. Hartley, R. & Zisserman, A. Multiple View Geometry in Computer Vision Cambridge University Press, 2004
1. Lucas, B. D. & Kanade, T. An iterative image registration technique with an application to stereo vision 7th International Joint Conference on Artificial intelligence (IJCAI), Morgan Kaufmann Publishers, 1981, 2, 674 - 679
1. Shi, J. & Tomasi, C. Good features to track Computer Society Conference on Computer Vision and Pattern Recognition (CVPR), IEEE, 1994, 593 - 600
1. Tomasi, C. & Kanade, T. Detection and Tracking of Point Features School of Computer Science Carnegie Mellon University, 1991 

