function [sequenceEvaluation ] = EvaluateRho( sequence, alpha, adaptative, rho)
%EVALUATEROH Summary of this function goes here
%   Detailed explanation goes here

mean = sequence.gaussian.mean;
stdDev = sequence.gaussian.stdDev;
variance = sequence.gaussian.variance;

sequenceEvaluation = cell(1, length(rho));
result={};
for rhoIndex = 1:length(rho)
    for index = 1:length(sequence.test)
        result{index} = ClassifyGaussian(sequence.test{index}, mean, stdDev, alpha);

        if adaptative
            [mean, variance] = AdaptativeModel(mean, variance, result{index}, sequence.test{index}, rho(rhoIndex));
            stdDev = sqrt(variance);
        end
    end
    mean = sequence.gaussian.mean;
    stdDev = sequence.gaussian.stdDev;
    variance = sequence.gaussian.variance;
    % save the evaluation in the corresponding index of iteration
    [ ~ , sequenceEvaluation{rhoIndex} ] = evaluation(result, sequence.gt); 
end

end
