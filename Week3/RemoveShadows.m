function [ sequence ] = RemoveShadows( sequence, cfg )

%inputImages need to be in HSV
if strcmp(cfg.morphologicalFiltering, 'imfill')
    masks = sequence.nonAdaptiveImfill.bestResult;
    
elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
    masks = sequence.nonAdaptiveFiltering.bestResult;
    
else
    masks = sequence.nonAdaptiveBase.bestResult;
end
images = sequence.hsv.test;

[Htrain, Strain, Vtrain] = obtainHSV(sequence.hsv.train);

Hgaussian = GaussianPerPixel( Htrain, cfg ); 
Sgaussian = GaussianPerPixel( Strain, cfg ); 
Vgaussian = GaussianPerPixel( Vtrain, cfg ); 

alphaV = 0.05;
betaV = 0.2;
thresS = 0.2;
thresH = 0.6;

for index = 1:length(images)
    mask = masks{index} == 255;
    
    result{index} = masks{index};
    I = images{index};
    
    Vdivision = I(:,:,3)./Vgaussian.mean;
    
    maskV = alphaV< Vdivision & Vdivision<= betaV;
    
    maskS = (I(:,:,2) - Sgaussian.mean) <= thresS;
    
    maskH = abs(I(:,:,1) - Hgaussian.mean) <= thresH;
    
    result{index}(maskV & maskS & maskH & mask) = 0; 
    
    
%     subplot(2,2,1), title('maskV'), imshow(maskV & mask)
%     subplot(2,2,2), title('maskS'), imshow(maskS & mask),
%     subplot(2,2,3), title('maskH'), imshow(maskH & mask),
%     subplot(2,2,4), title('result'), imshow(maskV & maskS & maskH & mask);
%     pause();
end



result = ImproveMask(result, cfg);
sequence.noShadows.results = result;
[ ~ , sequenceEvaluation] = evaluation(result, sequence.gt);

recall = sequenceEvaluation.recall;    
precision = sequenceEvaluation.precision;    
sequence.noShadows.F = sequenceEvaluation.F;
%sequence.noShadows.AUC = abs(trapz(recall, precision));

end




function [H, S, V] = obtainHSV(sequence)

    H = cellfun(@(c) c(:,:,1), sequence, 'UniformOutput', false);
 
    S = cellfun(@(c) c(:,:,2), sequence, 'UniformOutput', false);

    V = cellfun(@(c) c(:,:,3), sequence, 'UniformOutput', false);

end