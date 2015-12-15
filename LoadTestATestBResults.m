function [ testAImages, testBImages, idImage ] = LoadTestATestBResults( cfg )
%LOADTESTATESTBRESULTS Load the results of Test A and Test B

[testAImages, idImageA] = getImagesFromPath([ cfg.results_path, 'test_A_*.png']);
[testBImages, idImageB] = getImagesFromPath([ cfg.results_path, 'test_B_*.png']);

idImage = unique([idImageA , idImageB]);

    function [images, idImage] = getImagesFromPath(path)
        files = dir(path);
        completePath  = cellfun(@(c)[cfg.results_path c],...
                            {files.name},'UniformOutput',false);
        images = cellfun(@imread, completePath, 'UniformOutput', false);
        idImage = cellfun(@(c) c(8:end-4), ...
                    {files.name},'UniformOutput',false);
    end
end


