function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here


config.pathToHighway = '../../Data/highway/';%'/imatge/alfaro/work/M4/Data/highway/';
config.pathToTraffic = '../../Data/traffic/';%'/imatge/alfaro/work/M4/Data/traffic/';

trafficFrames = [950  1050 1570];
highwayFrames = [1050 1350 1700];


trainTestSplit = 0.5;

trafficMiddlePoint =    round(trafficFrames(1) + (trafficFrames(2) - trafficFrames(1)) *trainTestSplit);

config.traffic.trainFrames =    trafficFrames(1)   :   trafficMiddlePoint;
config.traffic.testFrames =    trafficMiddlePoint+1   :   trafficFrames(3);

config.traffic.inputPath =  [ config.pathToTraffic 'input/' ];
config.traffic.gtPath =  [ config.pathToTraffic 'groundtruth/' ];


highwayMiddlePoint =    round(highwayFrames(1) + (highwayFrames(2) - highwayFrames(1)) *trainTestSplit);

config.highway.trainFrames =    highwayFrames(1)   :   highwayMiddlePoint;
config.highway.testFrames =    highwayMiddlePoint+1   :   highwayFrames(3);

config.highway.inputPath =  [ config.pathToHighway 'input/' ];
config.highway.gtPath =  [ config.pathToHighway 'groundtruth/' ];
end