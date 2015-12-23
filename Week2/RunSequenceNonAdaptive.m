function [sequence] = RunSequenceAdaptive(sequence, cfg)

[bestAlpha, sequence] = optimization(sequence);

[~, sequence.nonAdaptive.bestResult] = EvaluateAlpha(sequence, bestAlpha, false, 0);

function [bestAlpha, sequence] = optimization(sequence)
    
    % compute best inital alpha with non adaptative
    [alphaEvaluation] = EvaluateAlpha(sequence, cfg.alpha, false, 0);

    [F,I] = sort(extractfield(cell2mat(alphaEvaluation), 'F'), 'descend');
    bestAlpha = cfg.alpha(I(1));
    bestF = F(1)
    
    sequence.nonAdaptive.bestAlpha = bestAlpha
    sequence.nonAdaptive.bestF = bestF
    sequence.nonAdaptive.alphaEvaluation = alphaEvaluation;
end

end