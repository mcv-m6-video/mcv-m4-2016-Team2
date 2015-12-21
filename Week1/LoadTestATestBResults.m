function [ testAImages, testBImages, idImages ] = LoadTestATestBResults( cfg )
%LOADTESTATESTBRESULTS Load the results of Test A and Test B

[testAImages, idImageA] = getImagesFromPath([ cfg.results_highway, 'test_A_*.png']);
[testBImages, idImageB] = getImagesFromPath([ cfg.results_highway, 'test_B_*.png']);

idImages = idImageA;
    function [images, idImage] = getImagesFromPath(path)
        files = dir(path);
        completePath  = cellfun(@(c)[cfg.results_highway c],...
                            {files.name},'UniformOutput',false);
        images = cellfun(@imread, completePath, 'UniformOutput', false);
        idImage = cellfun(@(c) c(8:end-4), ...
                    {files.name},'UniformOutput',false);
    end
end


