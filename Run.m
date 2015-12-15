cfg = Config();

[testAImages, testBImages, idImages] = LoadTestATestBResults(cfg);
[groundTruth] = LoadGroundTruth(cfg, idImages);

display('Test A.....');
[TestA_evaluationFrame, TestA_evaluationSequence] = evaluation(testAImages, groundTruth);

display('Test B.....');
[TestB_evaluationFrame, TestB_evaluationSequence] = evaluation(testBImages, groundTruth);

plotResults('TestA', TestA_evaluationSequence, TestA_evaluationFrame, cfg)
plotResults('TestB', TestB_evaluationSequence, TestB_evaluationFrame, cfg)
% [testABoundingBox] = ExtractBoundingBox(testAImages);