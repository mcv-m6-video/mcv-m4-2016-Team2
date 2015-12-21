function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here

pathToHighway = '../../Data/highway/';
pathToFall = '../../Data/fall/';
pathToTraffic = '../../Data/traffic/';

highwayFrames = [1050 1350];
fallFrames =    [1460 1560];
trafficFrames = [950  1050];

trainTestSplit = 0.5;

highwayMiddlePoint =    round(highwayFrames(1) + (highwayFrames(2) - highwayFrames(1)) *trainTestSplit);
fallMiddlePoint =       round(fallFrames(1) + (fallFrames(2)    - fallFrames(1))    *trainTestSplit);
trafficMiddlePoint =    round(trafficFrames(1) + (trafficFrames(2) - trafficFrames(1)) *trainTestSplit);

config.highway.trainFrames =    highwayFrames(1)   :   highwayMiddlePoint;
config.fall.trainFrames =       fallFrames(1)      :   fallMiddlePoint;
config.traffic.trainFrames =    trafficFrames(1)   :   trafficMiddlePoint;

config.highway.testFrames =    highwayMiddlePoint+1   :   highwayFrames(2);
config.fall.testFrames =       fallMiddlePoint+1      :   fallFrames(2);
config.traffic.testFrames =    trafficMiddlePoint+1   :   trafficFrames(2);

config.highway.inputPath =  [ pathToHighway 'input/' ];
config.fall.inputPath =     [ pathToFall 'input/' ];
config.traffic.inputPath =  [ pathToTraffic 'input/' ];

config.highway.gtPath =  [ pathToHighway 'groundtruth/' ];
config.fall.gtPath =     [ pathToFall 'groundtruth/' ];
config.traffic.gtPath =  [ pathToTraffic 'groundtruth/' ];


%%
% Plotly
addpath(genpath('./MATLAB-api-master'))
% plotlysetup('Catlovers', 'o0elqap0f0')

config.plotly.activate = 0
config.plotly.folder = 'M4/W2/'


end

