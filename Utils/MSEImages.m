function [ MSEResults, PEPNResults] = MSEImages(flow, groundTruth)


        %testI = testImages{index};
        gtI = groundTruth;
        
        
        gtIx = (double(gtI(:,:,1)) - 2^15)/ 64;
        gtIy = (double(gtI(:,:,2)) - 2^15)/ 64;
        
        %For Lucas Kanade:
%         testIxy = (double(flow(:,:,1:2)) - 2^15) ./ 64;
%         testIx = testIxy(:,:,1);
%         testIy = testIxy(:,:,2);

        %For our results:
        testIx = flow.Vx;
        testIy = flow.Vy;
        
        gtValid = min(gtI(:,:,3),1);
        gtIx(gtValid==0) = 0;
        gtIy(gtValid==0) = 0;
        
        E_dx = gtIx-testIx;
        E_dy = gtIy-testIy;
        E = sqrt(E_dx.*E_dx+E_dy.*E_dy);
        E(gtValid==0) = 0;
        
        MSEResults = sum(E(:))/ sum(sum(gtValid)) ;
        PEPNResults = sum(sum(E> 3)) / sum(sum(gtValid)) * 100;
 
end