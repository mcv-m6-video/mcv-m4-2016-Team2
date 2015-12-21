function [ sequenceEvaluation ] = EvaluateAlpha( sequence, alpha )
%EVALUATEALPHA Summary of this function goes here
%   Detailed explanation goes here

sequenceEvaluation = cell(1, length(alpha));
for alphaIndex = 1:length(alpha)
    for index = 1:length(sequence.test)
        sequence.result{index} = ClassifyGaussian(sequence.test{index}, sequence.gaussian.mean, sequence.gaussian.variance, alpha(alphaIndex));
%         imshow(highway.result{index}/255);
%         pause(0.01);
    end
    [ ~ , sequenceEvaluation{alphaIndex} ] = evaluation(sequence.result, sequence.gt);
end

end

