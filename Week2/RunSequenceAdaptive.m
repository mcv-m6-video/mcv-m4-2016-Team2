function [sequence] = RunSequenceAdaptive(sequence, cfg)

[bestRho, bestAlpha, sequence] = optimization(sequence);

[ ~, sequence.adaptive.bestResult ] = EvaluateAlpha(sequence, bestAlpha, true, bestRho);

    function [bestRho, bestAlpha, sequence] = optimization(sequence)
        % compute best inital alpha with non adaptative
        [alphaEvaluation] = EvaluateAlpha(sequence, cfg.alpha, false, 0);
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
            antes = sequence.gaussian.mean;
            [rhoEvaluation] = EvaluateRho(sequence, bestAlpha, true, cfg.rho);
            despues = sequence.gaussian.mean;
            isequal(antes, despues)
            FValues = extractfield(cell2mat(rhoEvaluation), 'F');    
            FValues = FValues(~isnan(FValues));
            [F,I] = sort(FValues, 'descend');
            bestRho = cfg.rho(I(1))
            bestF = F(1)
            % compute alpha with best rho
            antes = sequence.gaussian.mean;
            [alphaEvaluation] = EvaluateAlpha(sequence, cfg.alpha, true, bestRho);
            despues = sequence.gaussian.mean;
            isequal(antes, despues)
            FValues = extractfield(cell2mat(alphaEvaluation), 'F');    
            FValues = FValues(~isnan(FValues));
            [F,I] = sort(FValues, 'descend');
            bestAlpha = cfg.alpha(I(1))
            bestF = F(1)

            iterations = iterations+1
            fDiff = abs(oldBestF - bestF);
        end

        sequence.adaptive.bestAlpha   = bestAlpha;
        sequence.adaptive.F           = bestF;
        sequence.adaptive.bestRho     = bestRho;
        sequence.adaptive.alphaEvaluation = alphaEvaluation;
    end
end
