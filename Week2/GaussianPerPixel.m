function [ gaussian ] = GaussianPerPixel( images, cfg )
%GAUSSIANPERPIXEL Summary of this function goes here
%   Detailed explanation goes here

imageStack = cat(3, images{1:end});

if cfg.grayscale
    gaussian.mean = mean(imageStack, 3);
    gaussian.variance = var(double(imageStack), 0, 3);
    gaussian.stdDev = sqrt(gaussian.variance);
else
    red     = imageStack(:,:,1:3:end);
    green   = imageStack(:,:,2:3:end);
    blue    = imageStack(:,:,3:3:end);
    
    gaussian.mean(:,:,1) = mean(red, 3);
    gaussian.mean(:,:,2) = mean(green, 3);
    gaussian.mean(:,:,3) = mean(blue, 3);
    
    gaussian.variance(:,:,1) = var(double(red), 0, 3);
    gaussian.variance(:,:,2) = var(double(green), 0, 3);
    gaussian.variance(:,:,3) = var(double(blue), 0, 3);
    
    gaussian.stdDev = sqrt(gaussian.variance);
    
    
end
end

