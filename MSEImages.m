function [ MSEResults ] = MSEImages(testImages, groundTruth)


    for index = 1:length(testImages)
        [n, m, z] = size(testImages{index});
        MSEResults(index) = sum(sum(sum((testImages{index} - groundTruth{index}).^2)))/(m*n*z);
    end
end