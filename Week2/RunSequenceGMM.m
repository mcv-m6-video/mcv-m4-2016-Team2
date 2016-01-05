function [sequence] = RunSequenceGMM(sequence, cfg)

[bestLearningRate, bestNumGaus, bestMinBackgroundRate, sequence] = optimization(sequence);

[~, sequence.GMM.bestResult ] = EvaluateGMM(sequence, bestNumGaus, bestLearningRate, bestMinBackgroundRate);

    function [bestLearningRate, bestNumGaus, bestMinBackgroundRate, sequence] = optimization(sequence)
        % compute best inital alpha with non adaptative
        bestMinBackgroundRate = 0.7;%cfg.minBackgroundRate(1);
        bestLearningRate = 0.005;
        evaluation = EvaluateGMM(sequence, cfg.numGaussians, bestLearningRate, bestMinBackgroundRate);
        
        [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
        bestNumGaus = cfg.numGaussians(I(1))
        bestF = F(1)
        iterations = 0;
        fDiff = Inf;
        while (iterations < cfg.maxIterations && fDiff > cfg.minfDiff)
            oldBestF = bestF;
            % compute best learning rate with the best num. of gaussians
            % and minimum bacgkround rate
            evaluation = EvaluateGMM(sequence, bestNumGaus, cfg.learningRate, bestMinBackgroundRate);
            [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
            bestLearningRate = cfg.learningRate(I(1))
            F(1)
            
            % compute best minimum background rate with the best num. of gaussians
            % and learning rate
            evaluation = EvaluateGMM(sequence, bestNumGaus, bestLearningRate, cfg.minBackgroundRate);
            [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
            bestMinBackgroundRate = cfg.minBackgroundRate(I(1))
            F(1)
            
            % compute number of gaussians with the best learning rate and
            % minimum background rate
            evaluation = EvaluateGMM(sequence, cfg.numGaussians, bestLearningRate, bestMinBackgroundRate);
            [F,I] = sort(extractfield(cell2mat(evaluation), 'F'), 'descend');
            bestNumGaus = cfg.numGaussians(I(1));
            bestF = F(1)

            iterations = iterations+1
            fDiff = abs(oldBestF - bestF)
        end

        sequence.GMM.bestNumGaus   = bestNumGaus;
        sequence.GMM.F           = bestF;
        sequence.GMM.bestLearningRate     = bestLearningRate;
        sequence.GMM.bestMinBackgroundRate = bestMinBackgroundRate;
        sequence.GMM.evaluation = evaluation;
    end
end
