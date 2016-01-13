function [sequence] = RunSequenceAdaptiveMorphologicalFiltering(sequence, cfg, bestRho)


[ alphaEval, ~ ] = EvaluateAlphaFiltering(sequence, cfg.alpha, true, bestRho, cfg);

% Compute recall-precision and AUC
recall = extractfield(cell2mat(alphaEval), 'recall');    
precision = extractfield(cell2mat(alphaEval), 'precision');    
AUC = abs(trapz(recall, precision));

% Compute the best alpha and obtain the best results
FValues = extractfield(cell2mat(alphaEval), 'F');
FValues = FValues(~isnan(FValues));
[F,I] = sort(FValues, 'descend');
bestAlpha = cfg.alpha(I(1));
bestF = F(1);
[ ~, bestResult ] = EvaluateAlphaFiltering(sequence, bestAlpha, true, bestRho, cfg);



if strcmp(cfg.morphologicalFiltering, 'imfill')
    sequence.adaptiveImfill.bestResult  = bestResult;
    sequence.adaptiveImfill.AUC         = AUC;
    sequence.adaptiveImfill.bestAlpha   = bestAlpha;
    sequence.adaptiveImfill.F           = bestF;
    sequence.adaptiveImfill.bestRho     = bestRho;
    sequence.adaptiveImfill.recall     = recall;
    sequence.adaptiveImfill.precision     = precision;
    sequence.adaptiveImfill.alphaEvaluation = alphaEval;
elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
    sequence.adaptiveFiltering.bestResult = bestResult;
    sequence.adaptiveFiltering.AUC = AUC;
    sequence.adaptiveFiltering.bestAlpha   = bestAlpha;
    sequence.adaptiveFiltering.F           = bestF;
    sequence.adaptiveFiltering.bestRho     = bestRho;
    
    sequence.adaptiveFiltering.recall     = recall;
    sequence.adaptiveFiltering.precision     = precision;
    sequence.adaptiveFiltering.alphaEvaluation = alphaEval;
elseif strcmp(cfg.morphologicalFiltering, 'other')
    sequence.adaptiveTask4.bestResult   = bestResult;
    sequence.adaptiveTask4.AUC          = AUC;
    sequence.adaptiveTask4.bestAlpha    = bestAlpha;
    sequence.adaptiveTask4.F            = bestF;
    sequence.adaptiveTask4.bestRho      = bestRho;
    
    sequence.adaptiveTask4.recall     = recall;
    sequence.adaptiveTask4.precision     = precision;
    sequence.adaptiveTask4.alphaEvaluation = alphaEval;
    
else
    sequence.adaptiveBase.bestResult = bestResult;
    sequence.adaptiveBase.AUC = AUC;
    sequence.adaptiveBase.bestAlpha    = bestAlpha;
    sequence.adaptiveBase.F            = bestF;
    sequence.adaptiveBase.bestRho      = bestRho;
    sequence.adaptiveBase.recall     = recall;
    sequence.adaptiveBase.precision     = precision;
    sequence.adaptiveBase.alphaEvaluation = alphaEval;
end

        
end
