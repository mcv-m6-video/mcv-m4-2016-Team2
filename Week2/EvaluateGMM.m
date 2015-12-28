function [ sequenceEvaluation, result] = EvaluateGMM(sequence, numGaussians, learningRate)
% pathVideo = '../../Data/highway/video.avi';
% pathVideo = config.highway.pathVideo

singleNumGaus = isscalar(numGaussians);
singleLearningRate = isscalar(learningRate);

if (singleLearningRate==0 && singleNumGaus==0)
   error('LearningRate and NumGaussians must not be an array') 
end


sequenceEvaluation = {};
for ii_numGauss = 1:length(numGaussians)
    for ii_LearningR =1:length(learningRate)
        
        numGaussValue = numGaussians(ii_numGauss);
        learningRateValue = learningRate(ii_LearningR);
        result = ClassifyGMM(sequence, numGaussValue, learningRateValue);

        % save the evaluation in the corresponding index of iteration
        [ ~ , sequenceEvaluation{end+1} ] = evaluation(result, sequence.gt);
    end
end