function [ groundTruth ] = LoadGroundTruth( cfg )
%LOADGROUNDTRUTH Summary of this function goes here
%   Detailed explanation goes here

resultsFilenames = dir([ cfg.train_gt_path, '*.png']);

groundTruth = cell(1,length(resultsFilenames));

for index = 1:length(resultsFilenames)
    filename = resultsFilenames(index).name;
    
    groundTruth{index} = imread( [cfg.train_gt_path filename] );
end


end

