function [sequence] = RunSequenceNonAdaptiveMorphologicalFiltering(sequence, cfg)

[bestAlpha, sequence] = optimization(sequence);

[~, bestResult] = EvaluateAlphaFiltering(sequence, bestAlpha, false, 0, cfg);

if strcmp(cfg.morphologicalFiltering, 'imfill')
    sequence.nonAdaptiveImfill.bestResult = bestResult;
    
elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
    sequence.nonAdaptiveFiltering.bestResult = bestResult;
    
elseif strcmp(cfg.morphologicalFiltering, 'other')
    sequence.nonAdaptiveTask5.bestResult = bestResult;
end
    
function [bestAlpha, sequence] = optimization(sequence)
    
    % compute best inital alpha with non adaptative
    [alphaEvaluation] = EvaluateAlphaFiltering(sequence, cfg.alpha, false, 0, cfg);
    
    FValues = extractfield(cell2mat(alphaEvaluation), 'F');    
    FValues = FValues(~isnan(FValues));
    
    [F,I] = sort(FValues, 'descend');
    bestAlpha = cfg.alpha(I(1));
    bestF = F(1);
    
    if strcmp(cfg.morphologicalFiltering, 'imfill')
        sequence.nonAdaptiveImfill.bestAlpha = bestAlpha;
        sequence.nonAdaptiveImfill.bestF = bestF;
        sequence.nonAdaptiveImfill.alphaEvaluation = alphaEvaluation;
        
    elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
        sequence.nonAdaptiveFiltering.bestAlpha = bestAlpha;
        sequence.nonAdaptiveFiltering.bestF = bestF;
        sequence.nonAdaptiveFiltering.alphaEvaluation = alphaEvaluation;
        
    elseif strcmp(cfg.morphologicalFiltering, 'other')
        sequence.nonAdaptiveTask5.bestAlpha = bestAlpha;
        sequence.nonAdaptiveTask5.bestF = bestF;
        sequence.nonAdaptiveTask5.alphaEvaluation = alphaEvaluation;
    end
    
end

end