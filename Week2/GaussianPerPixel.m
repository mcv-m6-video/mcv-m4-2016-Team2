function [ gaussian ] = GaussianPerPixel( images )
%GAUSSIANPERPIXEL Summary of this function goes here
%   Detailed explanation goes here

gaussian.mean = mean(images, 3);
gaussian.variance = variance(images, 3);


end

