function [ MSEResults ] = MSEImages(testImages, groundTruth)

    %cellfun(@immse, testImages, groundTruth, 'UniformOutput', false);

    for index = 1:length(testImages)
        MSEResults(index) = immse(testImages(1), groundTruth(1));
    end
end