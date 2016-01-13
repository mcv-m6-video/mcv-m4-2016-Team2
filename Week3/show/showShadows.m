% Cambiar 
sequence = traffic;
% FIN cambiar

masks = sequence.nonAdaptiveImfill.bestResult;

masksNoShadows  = sequence.noShadows.results;

testGT = sequence.gt;

test = sequence.test;

% mean    = sequence.gaussian.mean;
% std     = sequence.gaussian.stdDev;
% variance = sequence.gaussian.variance;
% test    = sequence.test;
% testRGB = LoadImages(inputPath, testFrames, 'in', 'jpg');
% trainRGB = LoadImages(inputPath, trainFrames, 'in', 'jpg');
% testGT  = LoadImages(gtPath, testFrames, 'gt', 'png');
% res     = sequence.adaptive.bestResult;
% alpha   = sequence.adaptive.bestAlpha;
% rho     = sequence.adaptive.bestRho;

figure;
for ii = 1:length(test)
    ii
    maskOutputImage = logical(masks{ii});
    maskOutputImageNoShadow = logical(masksNoShadows{ii});
    gt = testGT{ii};
    inputImage = test{ii};
    difference = abs(maskOutputImageNoShadow - maskOutputImage);

    %differenceImage = abs(inputImage-mean);
    % input image RGB
    %subplot(2, 3, 1); imshow(inputImageRGB); freezeColors
    % output image GT
    %subplot(2, 4, 2); imshow(inputImageRGB.*repmat(gt, [1 1 3])); freezeColors
    % input image
    subplot(2, 2, 1); imshow(inputImage/255, []); %colormap cool; freezeColors;
    % mask 
    subplot(2, 2, 2); imshow((inputImage/255).*maskOutputImage, []); %colormap cool; freezeColors;
    %mask without Shadows
    subplot(2, 2, 3); imshow((inputImage/255).*maskOutputImageNoShadow, []);
    % difference mask image
    subplot(2, 2, 4); imshow((inputImage/255).*difference, []);
    colormap jet
    
    pause()
end
