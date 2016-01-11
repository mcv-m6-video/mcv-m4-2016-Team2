function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here

config.pathToHighway = '../../Data/highway/';
config.pathToFall = '../../Data/fall/';
config.pathToTraffic = '../../Data/traffic/';

config.maxIterations = 20; %20
config.minfDiff = 0.01;
config.alpha = 1:0.1:7;
config.rho = 0:0.05:1;



config.nonAdaptive = true;
config.adaptive = true;
config.grayscale = true;

config.morphologicalFiltering = 'areaFilt';%'imfill'; %'areaFilt' % 'other'
config.areaFilteringSize = 3;
config.connectivity = 4; %8

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

config.highway.inputPath =  [ config.pathToHighway 'input/' ];
config.fall.inputPath =     [ config.pathToFall 'input/' ];
config.traffic.inputPath =  [ config.pathToTraffic 'input/' ];

config.highway.gtPath =  [ config.pathToHighway 'groundtruth/' ];
config.fall.gtPath =     [ config.pathToFall 'groundtruth/' ];
config.traffic.gtPath =  [ config.pathToTraffic 'groundtruth/' ];


%%
% Plotly
addpath(genpath('../MATLAB-api-master'))
plotlysetup('CatLovers2', 'vq3m7xvk89')

config.plotly.activate = 0
config.plotly.folder = 'M4/W3/'


end