function mseValue = costMSE(image1, image2)

difference = (image1-image2).^2;
mseValue = sum(difference(:))/(size(difference, 1)*size(difference, 2));