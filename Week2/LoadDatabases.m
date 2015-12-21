function [ highway, fall, traffic ] = LoadDatabases( cfg )
%LOADDATABASES Summary of this function goes here
%   Detailed explanation goes here

highway.train = LoadImages(cfg.highway.inputPath, cfg.highway.trainFrames, 'in', 'jpg');
highway.test = LoadImages(cfg.highway.inputPath, cfg.highway.testFrames, 'in', 'jpg');
highway.gt = LoadImages(cfg.highway.gtPath, cfg.highway.testFrames, 'gt', 'png');

fall.train = LoadImages(cfg.fall.inputPath, cfg.fall.trainFrames, 'in', 'jpg');
fall.test = LoadImages(cfg.fall.inputPath, cfg.fall.testFrames, 'in', 'jpg');
fall.gt = LoadImages(cfg.fall.gtPath, cfg.fall.testFrames, 'gt', 'png');

traffic.train = LoadImages(cfg.traffic.inputPath, cfg.traffic.trainFrames, 'in', 'jpg');
traffic.test = LoadImages(cfg.traffic.inputPath, cfg.traffic.testFrames, 'in', 'jpg');
traffic.gt = LoadImages(cfg.traffic.gtPath, cfg.traffic.testFrames, 'gt', 'png');

end

