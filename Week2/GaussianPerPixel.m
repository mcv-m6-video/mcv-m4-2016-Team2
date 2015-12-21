function [ gaussian ] = GaussianPerPixel( images )
%GAUSSIANPERPIXEL Summary of this function goes here
%   Detailed explanation goes here

imageStack = cat(3, images{1:end});

gaussian.mean = mean(imageStack, 3);
gaussian.variance = var(double(imageStack), 0, 3);
gaussian.stdDev = sqrt(gaussian.variance);

end

