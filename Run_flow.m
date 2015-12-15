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

