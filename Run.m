cfg = Config();

[groundTruth] = LoadGroundTruth(cfg);

[testAImages, testBImages] = LoadTestATestBResults(cfg);

[testABoundingBox] = ExtractBoundingBox(testAImages);