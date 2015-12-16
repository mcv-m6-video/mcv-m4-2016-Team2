function [ groundTruth, idImageGT ] = LoadGroundTruth( cfg, varargin )
%LOADGROUNDTRUTH Summary of this function goes here
%   Detailed explanation goes here

completePath = {};
% Load the GT for the given images, else load all images.
if nargin == 2
    names = varargin{1};
    ar_names = cell2mat(cellfun(@str2num,names,'un',0));
    ar_names = ar_names + cfg.delay;
    completePath  = arrayfun(@(c)sprintf('%sgt%06d.png', cfg.train_highway,c),...
                            ar_names,'UniformOutput',false);
    idImageGT = names;
else
    files = dir([ cfg.train_gt_path, '*.png']);
    completePath  = cellfun(@(c)[cfg.train_highway c],...
                            {files.name},'UniformOutput',false);
end

groundTruth = cellfun(@imread, completePath, 'UniformOutput', false);
% resultsFilenames = dir([ cfg.train_gt_path, '*.png']);
% 
% groundTruth = cell(1,length(resultsFilenames));
% 
% for index = 1:length(resultsFilenames)
%     filename = resultsFilenames(index).name;
%     
%     groundTruth{index} = imread( [cfg.train_gt_path filename] );
% end


end

