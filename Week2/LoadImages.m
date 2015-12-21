function [ sequenceImages ] = LoadImages( path, sequenceIndices )
%LOADIMAGES Summary of this function goes here
%   Detailed explanation goes here

completePath  = arrayfun(@(c)sprintf('%s%s%06d.%s', path, '*' , c, '*') , sequenceIndices);
sequenceImages = cellfun(@imread, completePath);

end