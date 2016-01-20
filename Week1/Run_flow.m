cfg = Config();
 
GTPath = cfg.gt_flow;
[groundTruth, gtNames] = LoadFlowResults(GTPath);

TestPath = cfg.results_flow;
[testImages, ~] = LoadFlowResults(TestPath, gtNames);

for i = 1: length(testImages)
    display('Computing MSE.....');
    [Lk{i}.MSEResults, Lk{i}.PEPNResults] = MSEImages(testImages{i}, groundTruth{i});
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
