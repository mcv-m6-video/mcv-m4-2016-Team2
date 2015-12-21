function [ gaussian ] = GaussianPerPixel( images )
%GAUSSIANPERPIXEL Summary of this function goes here
%   Detailed explanation goes here

imageStack = cat(3, images);

gaussian.mean = mean(imageStack, 3);
gaussian.variance = variance(imageStack, 3);


end

