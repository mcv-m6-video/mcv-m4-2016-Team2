cfg = Config();
 
GTPath = cfg.kitti.gtPath;
[groundTruth, gtNames] = LoadFlowResults(GTPath);

TestPath = cfg.kitti.results;
[testImages, ~] = LoadFlowResults(TestPath, gtNames);

for i = 1: length(testImages)
    display('Computing MSE.....');
    [Lk{i}.MSEResults, Lk{i}.PEPNResults, E{i}] = MSEImages(testImages{i}, groundTruth{i});
    Lk{i}.compensatedImageLK = ForwardMotionCompensation(kitti{i}.reference, testImages{i});
end

% PEPNResults = PEPN(testImages, groundTruth)

%plotResults('TestB', TestB_evaluationSequence, TestB_evaluationFrame, cfg)
% [testABoundingBox] = ExtractBoundingBox(testAImages);


%% Task 7
% % Plot the optical flow
% 
% for index = 1:length(testImages)
%     
%     % Read real image
%     [real_img, map] = imread([cfg.images_flow gtNames{index}]);
%     
%     % Plot Optical Flow results
%     plotOpticalFlow(real_img, map, testImages{index});
% end

% figure;
% subplot(2, 1, 1); imshow(Lk{2}.compensatedImageLK/255);
% subplot(2, 1, 2);  imshowpair(Lk{2}.compensatedImageLK, kitti{2}.current)
