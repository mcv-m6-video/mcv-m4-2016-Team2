function traffic = LoadTraffic(cfg)

Ttrain = LoadImages(cfg.traffic.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
Ttest = LoadImages(cfg.traffic.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
Tgt = LoadImages(cfg.traffic.gtPath, cfg.traffic.testFrames, 'gt', 'png');
TseqName = 'traffic';
TnumTrainingFrames = length(cfg.traffic.trainFrames);
TpathVideo = [cfg.pathToTraffic 'video.avi'];

traffic.train = cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
traffic.test = cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
traffic.gt = Tgt;
traffic.seqName = TseqName;
traffic.numTrainingFrames = TnumTrainingFrames;
traffic.pathVideo = TpathVideo ;