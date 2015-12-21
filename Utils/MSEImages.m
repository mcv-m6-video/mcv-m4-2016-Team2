function [ MSEResults, PEPNResults] = MSEImages(testImages, groundTruth)


    for index = 1:length(testImages)
        testI = testImages{index};
        gtI = groundTruth{index};
        
        testIxy = (double(testI(:,:,1:2)) - 2^15) ./ 64;
        gtIxy = (double(gtI(:,:,1:2)) - 2^15) ./ 64;

        testIx = testIxy(:,:,1);
        testIy = testIxy(:,:,2);

        gtIx = gtIxy(:,:,1);
        gtIy = gtIxy(:,:,2);

        magnitude = sqrt( (testIx-gtIx).^2 + (testIy-gtIy).^2 );
        
        mask = gtI(:,:,3) > 0;
        validMagnitudes = magnitude(mask);
            
        MSEResults(index) = sum(validMagnitudes .^ 2) / length(validMagnitudes);
        PEPNResults(index) = sum(sum(validMagnitudes > 3)) / sum(sum(mask)) * 100;
    end
end