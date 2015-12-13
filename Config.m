function [ config ] = Config()
%CONFIG Summary of this function goes here
%   Detailed explanation goes here


%% MODIFY
train_base_path = '../Highway';
results_base_path = '../HighwayResults';





%%
train_gt_folder = 'groundtruth/';
results_folder = 'highway/';

config.train_gt_path = [ train_base_path '/' train_gt_folder ];
config.results_path = [ results_base_path '/' results_folder ];

end

