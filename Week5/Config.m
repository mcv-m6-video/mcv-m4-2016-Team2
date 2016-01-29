function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here


config.pathToHighway = '../../Data/highway/';%'/imatge/alfaro/work/M4/Data/highway/';
config.pathToTraffic = '../../Data/trafficStab/';%'/imatge/alfaro/work/M4/Data/traffic/';
config.pathToTarget = '../../Data/target/'
trafficFrames = [950  1050 1570];
highwayFrames = [1050 1350 1700];
targetFrames = [2 202 633];


trainTestSplit = 0.5;

trafficMiddlePoint =    round(trafficFrames(1) + (trafficFrames(2) - trafficFrames(1)) *trainTestSplit);

config.traffic.trainFrames =    trafficFrames(1)   :   trafficMiddlePoint;
config.traffic.testFrames =    trafficMiddlePoint+1   :   trafficFrames(3);

config.traffic.inputPath =  [ config.pathToTraffic 'input/' ];
config.traffic.gtPath =  [ config.pathToTraffic 'groundtruth/' ];
config.traffic.roiPath = [config.pathToTraffic 'ROI.png'];

% Highway
highwayMiddlePoint =    round(highwayFrames(1) + (highwayFrames(2) - highwayFrames(1)) *trainTestSplit);

config.highway.trainFrames =    highwayFrames(1)   :   highwayMiddlePoint;
config.highway.testFrames =    highwayMiddlePoint+1   :   highwayFrames(3);

config.highway.inputPath =  [ config.pathToHighway 'input/' ];
config.highway.gtPath =  [ config.pathToHighway 'groundtruth/' ];

% Target
targetMiddlePoint =    round(targetFrames(1) + (targetFrames(2) - targetFrames(1)) *trainTestSplit);

config.target.trainFrames =    targetFrames(1)   :   targetMiddlePoint;
config.target.testFrames =    targetMiddlePoint+1   :   targetFrames(3);

config.target.inputPath =  [ config.pathToTarget 'input/' ];
% config.target.gtPath =  [ config.pathToTraffic 'groundtruth/' ];
% config.target.roiPath = [config.pathToTraffic 'ROI.png'];

config.highway.shadowParam = [0.05, 0.3, 0.2, 0.3]; %%alphaV, betaV, thresS, thresH
config.traffic.shadowParam = [0.15, 0.5, 0.2, 0.3]; %%alphaV, betaV, thresS, thresH
config.target.shadowParam = [0, 1, 0.05, 0.3]; %%alphaV, betaV, thresS, thresH
end