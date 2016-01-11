function [ gaussian ] = GaussianPerPixel( images, cfg )
%GAUSSIANPERPIXEL Summary of this function goes here
%   Detailed explanation goes here

imageStack = cat(3, images{1:end});

%     if cfg.grayscale
        gaussian.mean = mean(imageStack, 3);
        gaussian.variance = var(double(imageStack), 0, 3);
        gaussian.stdDev = sqrt(gaussian.variance);

%     elseif cfg.yuv
%         y   = imageStack(:,:,1:3:end);
%         u   = imageStack(:,:,2:3:end);
%         v   = imageStack(:,:,3:3:end);
%     
%         uv = cat(3, u, v);
%         gaussian.mean(:,:,1) = mean(y, 3);
%         gaussian.mean(:,:,2) = mean(uv, 3)
% %         gaussian.mean(:,:,2) = mean(u, 3);
% %         gaussian.mean(:,:,3) = mean(v, 3);
% 
%         gaussian.variance(:,:,1) = var(double(y), 0, 3);
%         gaussian.variance(:,:,2) = var(double(uv), 0, 3);
% %         gaussian.variance(:,:,2) = var(double(u), 0, 3);
% %         gaussian.variance(:,:,3) = var(double(v), 0, 3);
% 
%         gaussian.stdDev = sqrt(gaussian.variance);
% 
% 
%     end
end

