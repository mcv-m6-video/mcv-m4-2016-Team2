% Plot results of GMM


% Cambiar 
sequence = fall;
inputPath = cfg.fall.inputPath;
gtPath = cfg.fall.gtPath;
testFrames = cfg.fall.testFrames;
trainFrames = cfg.fall.trainFrames;
% FIN cambiar

% mean    = sequence.gaussian.mean;
% std     = sequence.gaussian.stdDev;
% variance = sequence.gaussian.variance;
test    = sequence.test;
testRGB = LoadImages(inputPath, testFrames, 'in', 'jpg');
trainRGB = LoadImages(inputPath, trainFrames, 'in', 'jpg');
testGT  = LoadImages(gtPath, testFrames, 'gt', 'png');
res     = sequence.GMM.bestResult;
learningRate = sequence.GMM.bestLearningRate
numGaussians = sequence.GMM.bestNumGaus
bestF = sequence.GMM.F

%%
%%%%%%%%%%%%%%%%%%%%%%
% Plot train sequence
% RGB image | grayscale image ; mean image | std image
% figure;
% for jj = 1:length(trainFrames)
%     imageTrain = trainRGB{jj};
%     subplot(1, 2, 1);imshow(imageTrain); freezeColors
%     subplot(1, 2, 2);imshow(rgb2gray(imageTrain), [])
% %     subplot(2, 2, 3); imshow(mean/255, [])
% %     subplot(2, 2, 4); imshow(std/255, []);
%     colormap jet
%     pause
% end

%%
%%%%%%%%%%%%%%%%%%%%%%
% Plot test sequence
% Input RGB image         | input grayscale image | output image;

figure;
for ii = 1:length(test)
    ii
    maskOutputImage = logical(res{ii});
    inputImageRGB = testRGB{ii};
    gt = testGT{ii};
    inputImage = test{ii};
    
    % input image RGB
    subplot(1, 3, 1); imshow(inputImageRGB); freezeColors
    % input image
    subplot(1, 3, 2); imshow(inputImage/255, []); %colormap cool; freezeColors;
    % output image
    subplot(1, 3, 3); imshow((inputImage/255).*maskOutputImage, []); %colormap cool; freezeColors;

    colormap jet
 
    pause()
end
