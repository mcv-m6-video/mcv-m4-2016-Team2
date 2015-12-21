cfg = Config();

[testAImages, testBImages, idImages] = LoadTestATestBResults(cfg);
testAPrecision = []; testARecall = []; testAF = [];
testBPrecision = []; testBRecall = []; testBF = [];

for idx_delay = 1:50
    cfg.delay = idx_delay
   
    [groundTruth, idImageGT] = LoadGroundTruth(cfg, idImages);

    display('Test A.....');

    [~, TestA_evaluationSequence] = evaluation(testAImages, groundTruth);
    testAPrecision = [testAPrecision; TestA_evaluationSequence.precision];
    testARecall = [testARecall; TestA_evaluationSequence.recall];
    testAF = [testAF; TestA_evaluationSequence.F];
    
    
    display('Test B.....');
    [~, TestB_evaluationSequence] = evaluation(testBImages, groundTruth);
    testBPrecision = [testBPrecision; TestB_evaluationSequence.precision];
    testBRecall = [testBRecall; TestB_evaluationSequence.recall];
    testBF = [testBF; TestB_evaluationSequence.F];

end

plotResults_OP6('Test_A', [testAPrecision,testARecall, testAF], cfg)
plotResults_OP6('Test_B', [testBPrecision,testBRecall, testBF], cfg)