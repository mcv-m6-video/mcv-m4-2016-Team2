function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here


%% MODIFY
path_highway = '../Highway';

path_flow = '../opticalFlow';


%%
train_gt_folder = 'groundtruth/';
results_folder = 'results/';

config.train_highway = [ path_highway '/' train_gt_folder ];
config.results_highway = [ path_highway '/' results_folder ];

config.gt_flow = [ path_flow '/' train_gt_folder ];
config.results_flow = [ path_flow '/' results_folder ];

%%
% Plotly
addpath(genpath('./MATLAB-api-master'))
plotlysetup('Catlovers', 'o0elqap0f0')

config.plotly.activate = 0
config.plotly.folder = 'M4/W1_T13/'


end

