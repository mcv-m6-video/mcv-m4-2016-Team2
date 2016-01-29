function target = LoadTarget(cfg)

Ttrain = cellfun(@(x) imresize((x), 0.5), ...
    LoadImages(cfg.target.inputPath, cfg.target.trainFrames, '', 'png'), ...
    'UniformOutput', false);
Ttest = cellfun(@(x) imresize((x), 0.5), ...
    LoadImages(cfg.target.inputPath, cfg.target.testFrames, '', 'png'), ...
     'UniformOutput', false);
% TgtTest = LoadImages(cfg.highway.gtPath, cfg.traffic.testFrames, 'gt', 'png');
% TgtTrain = LoadImages(cfg.highway.gtPath, cfg.traffic.trainFrames, 'gt', 'png');
TseqName = 'highway';
TnumTrainingFrames = length(cfg.target.trainFrames);


target.train = Ttrain; %cellfun(@(c) double(rgb2gray(c)), Ttrain, 'UniformOutput', false);
target.test = Ttest; %cellfun(@(c) double(rgb2gray(c)), Ttest, 'UniformOutput', false);
% target.gt = [HgtTrain, HgtTest];
target.seqName = TseqName;
target.numTrainingFrames = TnumTrainingFrames;