function kernel = uniformKernel(x, y)

    kernel = ones(size(x)) / ((max(max(x)) - min(min(x)) + 1) * (max(max(y)) - min(min(y)) + 1));

end

