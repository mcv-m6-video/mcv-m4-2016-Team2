cfg = Config();
 
GTPath = cfg.gt_flow;
[groundTruth, gtNames] = LoadFlowResults(GTPath);

TestPath = cfg.results_flow;
[testImages, ~] = LoadFlowResults(TestPath, gtNames);

display('Computing MSE.....');
MSEResults = MSEImages(testImages, groundTruth)

PEPNResults = PEPN(testImages, groundTruth)

%plotResults('TestB', TestB_evaluationSequence, TestB_evaluationFrame, cfg)
% [testABoundingBox] = ExtractBoundingBox(testAImages);


%% Task 7
% Plot the optical flow

for index = 1:length(testImages)
    
    % Read real image
    [real_img, map] = imread([config.images_flow '/' result_img{index}(8:end)]);
    
    % Plot Optical Flow results
    plotOpticalFlow(real_img, map, result_img{index});
end
