% computeWeightedHistogram.m Help file for WEIGHTEDHISTOGRAM MEX file
%
%COMPUTEWEIGHTEDHISTOGRAM Computes histogram of image weighted by given kernel
% [H, B] = COMPUTEWEIGHTEDHISTOGRAM(I, K, b, minR, maxR) Computes b-bins
% histogram H of given image I and weights kernel K. Bins number b can be either
% scalar (same number of bins for each channel) or vector that specifies number
% of bins for each channel separately. In the first case H is b^n, in 
% the second b(1)*b(2)*...b(n) long vector, where n is the number of image I
% channels (3rd dimension). Parameters minR and maxR should be set as minimal 
% and maximal possible pixel's values (intesity range). Output matrix B is bin
% indices map for I.
%
% Notes
% -----
% 1. Output's indicies codes subsequent histogram's bins. Bin of n-th index
% contains normalized and weighted probability of occurance of pixel p whose
% intensities [p(1), p(2), ..., p(m)] are comprising certain ranges
% r(p(1)), r(p(2)), ..., r(p(m)) in every channel m, defined as follows:
% n = r(p(1)) + r(p(2)) * b(1) + r(p(3)) * b(1) * b(2) + ... r(p(m)) * b(1)
% * b(2) * ... * b(m - 1)
% Range of i-th index represents intensity limited by:
% [round((maxR - minR) / b) * (i - 1), round((maxR - minR) / b(m)) * i)
% E.g. pixel from 8-bit RGB image p = [45, 250, 120] in 16-bin (each channel)
% histogram will be included to n-th bin, where n:
% b = 16, minR = 0, maxR = 255
% r(p(1)) = 3, r(p(2)) = 16, r(p(3)) = 8
% n = 3 + 16 * 16 + 8 * 16^2 = 2307
% 2. I must be 2 or 3 dimensional matrix. K must be 2 dimensional
% matrix, which size must be consistent with size of I.