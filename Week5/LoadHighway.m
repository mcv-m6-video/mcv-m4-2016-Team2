function traffic = LoadHighway(cfg)

Ttrain = LoadImages(cfg.highway.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
Ttest = LoadImages(cfg.highway.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
TgtTest = LoadImages(cfg.highway.gtPath, cfg.traffic.testFrames, 'gt', 'png');
TgtTrain = LoadImages(cfg.highway.gtPath, cfg.traffic.trainFrames, 'gt', 'png');
TseqName = 'traffic';
TnumTrainingFrames = length(cfg.highway.trainFrames);


traffic.train = cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
traffic.test = cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
traffic.gt = [TgtTrain, TgtTest];
traffic.seqName = TseqName;
traffic.numTrainingFrames = TnumTrainingFrames;