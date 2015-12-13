function [ testAImages, testBImages ] = LoadTestATestBResults( cfg )
%LOADTESTATESTBRESULTS Summary of this function goes here
%   Detailed explanation goes here

resultsFilenames = dir([ cfg.results_path, '*.png']);

testAString = 'test_A';
testBString = 'test_B';

testAImages = {};
testBImages = {};

for index = 1:length(resultsFilenames)
    filename = resultsFilenames(index).name;
    image = imread( [cfg.results_path filename] );
    
    % if image name starts with test_A then its a testA image
    if strncmp( filename, testAString, length(testAString))
        testAImages{length(testAImages)+1} = image;
    
    elseif strncmp ( filename, testBString, length(testBString) )
        testBImages{length(testBImages)+1} = image;
        
    end
end



