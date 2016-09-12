function kernel = gaussianKernel(x, y)
    
    xMean = mean(mean(x));
    yMean = mean(mean(y));
    xMax = max(max(x));
    yMax = max(max(y));
    kernel = 1/(2 * pi) * exp(-(((x - xMean)/xMax).^2 + ((y - yMean)/yMax).^2)/2);

end

