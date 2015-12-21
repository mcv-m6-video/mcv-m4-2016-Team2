function labeledImg = classifyGaussian(image, mean, variance, alpha)
% segment the foreground
% background == 0 / foreground == 255

labeledImg = zeros(size(mean));
labeledImg(abs(image-mean) >= alpha*(variance + 2)) = 255;

end
