function [ sequenceImages ] = LoadImages( path, sequenceIndices, prefix, extension)
%LOADIMAGES Summary of this function goes here
%   Detailed explanation goes here

completePath  = arrayfun(@(c)sprintf('%s%s%06d.%s', path, prefix , c, extension) , sequenceIndices,...
                'UniformOutput', false);
sequenceImages = cellfun(@(x) (imread(x)), completePath, 'UniformOutput', false);
end