
%
load('resultsWeek2.mat');
%
testImages = w2_highway.test;
cfg = Config();
gtPath = cfg.highway.gtPath;
testFrames = cfg.highway.testFrames;
testGT  = LoadImages(gtPath, testFrames, 'gt', 'png');
for ii=1:length(testImages)
    mask = testGT{ii};
    mask = mask==255;
    [evaluation] = FWeightedMeasurePerFrame(testImages{ii}/255, mask)
pause(0.01)
end
