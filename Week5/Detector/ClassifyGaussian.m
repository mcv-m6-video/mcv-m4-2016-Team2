function labeledImg = ClassifyGaussian(image, mean, stdDev, alpha)
% segment the foreground
% background == 0 / foreground == 255
% if ~isa(image, 'double')
%     image = im2double(image);
% end
labeledImg = zeros(size(mean));
labeledImg(abs(image-mean) >= alpha*(stdDev + 2)) = 255;
labeledImg = logical(labeledImg);
