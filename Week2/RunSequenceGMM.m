function [sequence] = RunSequenceGMM(sequence, cfg)

[bestLearningRate, bestNumGaus, sequence] = optimization(sequence);

[~, sequence.GMM.bestResult ] = EvaluateGMM(sequence, bestNumGaus, bestLearningRate);

    function [bestLearningRate, bestNumGaus, sequence] = optimization(sequence)
        % compute best inital alpha with non adaptative
        evaluation = EvaluateGMM(sequence, cfg.numGaussians, cfg.learningRate(1));
        
        [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
        bestNumGaus = cfg.numGaussians(I(1));
        bestF = F(1)
        iterations = 0;
        fDiff = Inf;
        while (iterations < cfg.maxIterations && fDiff > cfg.minfDiff)
            oldBestF = bestF;
            % compute best rho with the best alpha
            evaluation = EvaluateGMM(sequence, bestNumGaus, cfg.learningRate);
            [~,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
            bestLearningRate = cfg.learningRate(I(1));

            % compute alpha with best rho
            evaluation = EvaluateGMM(sequence, cfg.numGaussians, bestLearningRate);
            [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
            bestNumGaus = cfg.numGaussians(I(1));
            bestF = F(1)

            iterations = iterations+1
            fDiff = abs(oldBestF - bestF)
        end

        sequence.GMM.bestNumGaus   = bestNumGaus;
        sequence.GMM.F           = bestF;
        sequence.GMM.bestLearningRate     = bestLearningRate;
        sequence.GMM.evaluation = evaluation;
    end
end
