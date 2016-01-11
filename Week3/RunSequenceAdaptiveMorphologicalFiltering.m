function [sequence] = RunSequenceAdaptiveMorphologicalFiltering(sequence, cfg)

[bestRho, bestAlpha, sequence] = optimization(sequence);

[ ~, bestResult ] = EvaluateAlphaFiltering(sequence, bestAlpha, true, bestRho, cfg);

if strcmp(cfg.morphologicalFiltering, 'imfill')
    sequence.adaptiveImfill.bestResult = bestResult;
    
elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
    sequence.adaptiveFiltering.bestResult = bestResult;
    
elseif strcmp(cfg.morphologicalFiltering, 'other')
    sequence.adaptiveTask5.bestResult = bestResult;
end

    function [bestRho, bestAlpha, sequence] = optimization(sequence)
        % compute best inital alpha with non adaptative
        [alphaEvaluation] = EvaluateAlphaFiltering(sequence, cfg.alpha, false, 0, cfg);
        nonRecursiveResults = alphaEvaluation;
        % plotTask1(alphaEvaluation, cfg)
        
        FValues = extractfield(cell2mat(alphaEvaluation), 'F');    
        FValues = FValues(~isnan(FValues));

        [F,I] = sort(FValues, 'descend');
        bestAlpha = cfg.alpha(I(1));
        bestF = F(1);
        
        iterations = 0;
        fDiff = Inf;
        while (iterations < cfg.maxIterations && fDiff > cfg.minfDiff)
            oldBestF = bestF;
            % compute best rho with the best alpha
            [rhoEvaluation] = EvaluateRhoFiltering(sequence, bestAlpha, true, cfg.rho, cfg);
            
            FValues = extractfield(cell2mat(rhoEvaluation), 'F');    
            FValues = FValues(~isnan(FValues));
            [F,I] = sort(FValues, 'descend');
            bestRho = cfg.rho(I(1))
            bestF = F(1)
            
            % compute alpha with best rho
            [alphaEvaluation] = EvaluateAlphaFiltering(sequence, cfg.alpha, true, bestRho, cfg);
            
            FValues = extractfield(cell2mat(alphaEvaluation), 'F');    
            FValues = FValues(~isnan(FValues));
            [F,I] = sort(FValues, 'descend');
            bestAlpha = cfg.alpha(I(1))
            bestF = F(1)

            iterations = iterations+1
            fDiff = abs(oldBestF - bestF);
        end
        
        
        
        if strcmp(cfg.morphologicalFiltering, 'imfill')
            sequence.adaptiveImfill.bestAlpha = bestAlpha;
            sequence.adaptiveImfill.bestF = bestF;
            sequence.adaptiveImfill.alphaEvaluation = alphaEvaluation;
            
        elseif strcmp(cfg.morphologicalFiltering, 'areaFilt')
            sequence.adaptiveFiltering.bestAlpha = bestAlpha;
            sequence.adaptiveFiltering.bestF = bestF;
            sequence.adaptiveFiltering.alphaEvaluation = alphaEvaluation;
            
        elseif strcmp(cfg.morphologicalFiltering, 'other')
            sequence.adaptiveTask5.bestAlpha = bestAlpha;
            sequence.adaptiveTask5.bestF = bestF;
            sequence.adaptiveTask5.alphaEvaluation = alphaEvaluation;
        end
    end
end
