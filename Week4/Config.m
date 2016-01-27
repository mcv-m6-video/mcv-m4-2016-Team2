function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here

config.pathToKitti = '../../Data/OpticalFlow/';
config.pathToTraffic = '../../Data/traffic/';

trafficFrames = [950  1050];
config.kittiSequences = [000045 000157];

trainTestSplit = 0.5;

trafficMiddlePoint =    round(trafficFrames(1) + (trafficFrames(2) - trafficFrames(1)) *trainTestSplit);

config.traffic.trainFrames =    trafficFrames(1)   :   trafficMiddlePoint;
config.traffic.testFrames =    trafficMiddlePoint+1   :   trafficFrames(2);

config.traffic.inputPath =  [ config.pathToTraffic 'input/' ];
config.traffic.gtPath =  [ config.pathToTraffic 'groundtruth/' ];

config.kitti.inputPath = [ config.pathToKitti 'input/' ];
config.kitti.gtPath = [ config.pathToKitti 'groundtruth/' ];
config.kitti.results = [ config.pathToKitti 'results/' ];


config.blockSize = 150;
config.p = config.blockSize;
config.methodBM = 'exhaustive'; %'exhaustive'; % '3steps'
%%
% Plotly
addpath(genpath('../MATLAB-api-master'))
plotlysetup('CatLovers2', 'vq3m7xvk89')

config.plotly.activate = 0
config.plotly.folder = 'M4/W4/'


end