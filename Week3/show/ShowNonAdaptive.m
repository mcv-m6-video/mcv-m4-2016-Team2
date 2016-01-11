% Plot difference images for non-recursove gaussian


% Cambiar 
sequence = highway;
inputPath = cfg.highway.inputPath;
gtPath = cfg.highway.gtPath;
testFrames = cfg.highway.testFrames;
trainFrames = cfg.highway.trainFrames;
% FIN cambiar

mean    = sequence.gaussian.mean;
std     = sequence.gaussian.stdDev;
test    = sequence.test;
testRGB = LoadImages(inputPath, testFrames, 'in', 'jpg');
trainRGB = LoadImages(inputPath, trainFrames, 'in', 'jpg');
testGT  = LoadImages(gtPath, testFrames, 'gt', 'png');

res     = sequence.nonAdaptive.bestResult;
alpha  = sequence.nonAdaptive.bestAlpha;

%%
%%%%%%%%%%%%%%%%%%%%%%
% Plot train sequence
% RGB image | grayscale image ; mean image | std image
figure;
for jj = 1:length(trainFrames)
    imageTrain = trainRGB{jj};
    subplot(2, 2, 1);imshow(imageTrain); freezeColors
    subplot(2, 2, 2);imshow(rgb2gray(imageTrain), [])
    subplot(2, 2, 3); imshow(mean/255, [])
    subplot(2, 2, 4); imshow(std/255, []);
    colormap jet
    pause
end

%%
%%%%%%%%%%%%%%%%%%%%%%
% Plot test sequence
% Input RGB image         | input grayscale image | output image;
% background image (mean) | variance (std)        | Difference image

figure;
for ii = 1:length(test)
    ii
    maskOutputImage = logical(res{ii});
    inputImageRGB = testRGB{ii};
    gt = testGT{ii};
    inputImage = test{ii};
    differenceImage = abs(inputImage-mean);
    % input image RGB
    subplot(2, 3, 1); imshow(inputImageRGB); freezeColors
    % output image GT
    %subplot(2, 4, 2); imshow(inputImageRGB.*repmat(gt, [1 1 3])); freezeColors
    % input image
    subplot(2, 3, 2); imshow(inputImage/255, []); %colormap cool; freezeColors;
    % output image
    subplot(2, 3, 3); imshow((inputImage/255).*maskOutputImage, []); %colormap cool; freezeColors;
  
    
    % mean image (also background image)
    subplot(2, 3, 4); imshow(mean/255, []);
    % standard deviation image
    subplot(2, 3, 5); imshow((alpha*std)/255, []);
    % difference image
    subplot(2, 3, 6); imshow(differenceImage/255, []); 
    colormap jet
    
    pause()
end
