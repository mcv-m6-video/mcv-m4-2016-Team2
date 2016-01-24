function traffic = LoadTraffic(cfg)

Ttrain = LoadImages(cfg.traffic.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
Ttest = LoadImages(cfg.traffic.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
TgtTest = LoadImages(cfg.traffic.gtPath, cfg.traffic.testFrames, 'gt', 'png');
TgtTrain = LoadImages(cfg.traffic.gtPath, cfg.traffic.trainFrames, 'gt', 'png');
TseqName = 'traffic';
TnumTrainingFrames = length(cfg.traffic.trainFrames);


traffic.train = cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
traffic.test = cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
traffic.gt = [TgtTrain, TgtTest];
traffic.seqName = TseqName;
traffic.numTrainingFrames = TnumTrainingFrames;
