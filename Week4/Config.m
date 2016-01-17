function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here

config.pathToKitti = '';
config.pathToTraffic = '../../Data/traffic/';


highwayFrames = [1050 1350];
fallFrames =    [1460 1560];
trafficFrames = [950  1050];

trainTestSplit = 0.5;

trafficMiddlePoint =    round(trafficFrames(1) + (trafficFrames(2) - trafficFrames(1)) *trainTestSplit);

config.traffic.trainFrames =    trafficFrames(1)   :   trafficMiddlePoint;
config.traffic.testFrames =    trafficMiddlePoint+1   :   trafficFrames(2);

config.traffic.inputPath =  [ config.pathToTraffic 'input/' ];

config.traffic.gtPath =  [ config.pathToTraffic 'groundtruth/' ];


%%
% Plotly
addpath(genpath('../MATLAB-api-master'))
plotlysetup('CatLovers2', 'vq3m7xvk89')

config.plotly.activate = 0
config.plotly.folder = 'M4/W4/'


end