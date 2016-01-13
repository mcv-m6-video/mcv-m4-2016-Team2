function [ sequence ] = RemoveShadows( sequence, cfg )

%inputImages need to be in HSV
masks = sequence.nonAdaptiveImfill.bestResult;
images = sequence.hsv.test;

[Htrain, Strain, Vtrain] = obtainHSV(sequence.hsv.train);

Hgaussian = GaussianPerPixel( Htrain, cfg ); 
Sgaussian = GaussianPerPixel( Strain, cfg ); 
Vgaussian = GaussianPerPixel( Vtrain, cfg ); 

alphaV = 0.4;
betaV = 0.6;
thresS = 0.1;
thresH = 0.5;

for index = 1:length(images)
    mask = zeros(size(masks{index}));
    mask(masks{index} ==255) = 1; 
    result{index} = masks{index};
    I = images{index};
    
    result{index}(logical((alphaV< (I(:,:,3)./Vgaussian.mean) <= betaV & (I(:,:,2) - Sgaussian.mean) <= thresS & abs(I(:,:,1) - Hgaussian.mean) <= thresH).*mask)) = 0; 
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