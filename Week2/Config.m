function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here

pathToHighway = '../Data/highway/';
pathToFall = '../Data/fall/';
pathToTraffic = '../Data/traffic/';

config.highway.frames = 1050:1350;
config.fall.frames =    1460:1560;
config.traffic.frames = 950:1050;

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

