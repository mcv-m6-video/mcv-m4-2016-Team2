function [ PEPNResults ] = PEPN(testImages, groundTruth)

    for index = 1:length(testImages)
        [n, m, z] = size(testImages{index});
        ErrorPixel{index} = abs(testImages{index} - groundTruth{index});
        
        greaterPixels = find ( ErrorPixel{index} > 3 );
        
        PEPNResults(index) = length(greaterPixels) / (m*n*z);
    end

end

