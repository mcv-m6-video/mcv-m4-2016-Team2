function highway = LoadHighway(cfg)

Htrain = LoadImages(cfg.highway.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
Htest = LoadImages(cfg.highway.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
HgtTest = LoadImages(cfg.highway.gtPath, cfg.traffic.testFrames, 'gt', 'png');
HgtTrain = LoadImages(cfg.highway.gtPath, cfg.traffic.trainFrames, 'gt', 'png');
HseqName = 'highway';
HnumTrainingFrames = length(cfg.highway.trainFrames);


highway.train = Htrain; %cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
highway.test = Htest; %cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
highway.gt = [HgtTrain, HgtTest];
highway.seqName = HseqName;
highway.numTrainingFrames = HnumTrainingFrames;