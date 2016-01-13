function [ sequenceEvaluation, result] = EvaluateAlphaFiltering( sequence, alpha, adaptative, rho, cfg)
%EVALUATEALPHA Summary of this function goes here
%   Detailed explanation goes here

mean = sequence.gaussian.mean;
stdDev = sequence.gaussian.stdDev;
variance = sequence.gaussian.variance;

sequenceEvaluation = cell(1, length(alpha));
sequenceEvaluation2 = cell(1, length(alpha));
result = {};
for alphaIndex = 1:length(alpha)
    for index = 1:length(sequence.test)
        result{index} = ClassifyGaussian(sequence.test{index}, mean, stdDev, alpha(alphaIndex));

        if adaptative
            [mean, variance] = AdaptativeModel(mean, variance, result{index}, sequence.test{index}, rho);
            stdDev = sqrt(variance); 
        end
        
        
    end
    
    subplot(2, 1, 1);imshow(result{1})
    result = ImproveMask(result, cfg);
    subplot(2, 1, 2);imshow(result{1})
    pause(0.1)
    % save the evaluation in the corresponding index of iteration
    [ ~ , sequenceEvaluation{alphaIndex} ] = evaluation(result, sequence.gt);
    
    for ii = 1:length(sequence.test)
    [TPw, FPw] = FWeightedMeasurePerFrame(FG, GT)
    
    
    mean = sequence.gaussian.mean;
    stdDev = sequence.gaussian.stdDev;
    variance = sequence.gaussian.variance;
end

end

