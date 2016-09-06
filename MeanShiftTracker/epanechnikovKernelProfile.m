function k_e = epanechnikovKernelProfile(x)

    k_e = zeros(size(x), class(x));
    
    inds = x <= 1;
    
    k_e(inds) = 2 * pi ^ (-1) * (1 - x(inds));

end