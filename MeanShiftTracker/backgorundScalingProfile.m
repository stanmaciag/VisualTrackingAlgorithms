function k_s = backgorundScalingProfile(x, a)

    k_s = zeros(size(x), class(x));
    h = max(max(x));
    
    inds = (x > 1  & x <= h);
    
    k_s(inds) = a * x(inds);

end