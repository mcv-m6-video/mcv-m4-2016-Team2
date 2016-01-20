function pepnValue = pepn(compensatedImage, image)

[m, n] = size(image);
difference = compensatedImage ~= image;
numErrPixels = sum(difference(:));
pepnValue = (numErrPixels/(m*n))*100;
