function [ sequenceEvaluation ] = EvaluateAlpha( sequence, alpha, adaptative, rho)
%EVALUATEALPHA Summary of this function goes here
%   Detailed explanation goes here

mean = sequence.gaussian.mean;
stdDev = sequence.gaussian.stdDev;
variance = sequence.gaussian.variance;

sequenceEvaluation = cell(1, length(alpha));

for alphaIndex = 1:length(alpha)
    for index = 1:length(sequence.test)
        sequence.result{index} = ClassifyGaussian(sequence.test{index}, mean, stdDev, alpha(alphaIndex));

        if adaptative
            [mean, variance] = AdaptativeModel(mean, variance, sequence.result{index}, sequence.test{index}, rho);
            stdDev = sqrt(variance);
        end
    end
    % save the evaluation in the corresponding index of iteration
    [ ~ , sequenceEvaluation{alphaIndex} ] = evaluation(sequence.result, sequence.gt);
end

end

