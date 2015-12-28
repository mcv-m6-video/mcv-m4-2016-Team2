function [ highway, fall, traffic ] = LoadDatabases( cfg )
%LOADDATABASES Summary of this function goes here
%   Detailed explanation goes here

highway.train = LoadImages(cfg.highway.inputPath, cfg.highway.trainFrames, 'in', 'jpg');
highway.test = LoadImages(cfg.highway.inputPath, cfg.highway.testFrames, 'in', 'jpg');
highway.gt = LoadImages(cfg.highway.gtPath, cfg.highway.testFrames, 'gt', 'png');
highway.seqName = 'highway';
highway.numTrainingFrames = length(cfg.highway.trainFrames);
highway.pathVideo = [cfg.pathToHighway 'video.avi'];

fall.train = LoadImages(cfg.fall.inputPath, cfg.fall.trainFrames, 'in', 'jpg');
fall.test = LoadImages(cfg.fall.inputPath, cfg.fall.testFrames, 'in', 'jpg');
fall.gt = LoadImages(cfg.fall.gtPath, cfg.fall.testFrames, 'gt', 'png');
fall.seqName = 'fall';
fall.numTrainingFrames = length(cfg.fall.trainFrames);
fall.pathVideo = [cfg.pathToFall 'video.avi'];

traffic.train = LoadImages(cfg.traffic.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
traffic.test = LoadImages(cfg.traffic.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
traffic.gt = LoadImages(cfg.traffic.gtPath, cfg.traffic.testFrames, 'gt', 'png');
traffic.seqName = 'traffic';
traffic.numTrainingFrames = length(cfg.traffic.trainFrames);
traffic.pathVideo = [cfg.pathToTraffic 'video.avi'];

if cfg.grayscale
    highway.train = cellfun(@(c) double(rgb2gray(c)), highway.train, 'UniformOutput', false);
    highway.test = cellfun(@(c) double(rgb2gray(c)), highway.test, 'UniformOutput', false);
    
    fall.train = cellfun(@(c) double(rgb2gray(c)), fall.train, 'UniformOutput', false);
    fall.test = cellfun(@(c) double(rgb2gray(c)), fall.test, 'UniformOutput', false);
    
    traffic.train = cellfun(@(c) double(rgb2gray(c)), traffic.train, 'UniformOutput', false);
    traffic.test = cellfun(@(c) double(rgb2gray(c)), traffic.test, 'UniformOutput', false);
end

