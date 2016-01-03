function [ outputSequence ] = JoinChannels( sequence, numChannels, nonAdaptative, adaptative )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    for index = 1:length(sequence{1}.test)
              
        for chan = 1:numChannels
            if adaptative
                imageAdap(:,:,chan) = sequence{chan}.adaptive.bestResult{index};
                outputSequence.adaptive.bestAlpha(chan) = sequence{chan}.adaptive.bestAlpha;
            end
            if nonAdaptative
                imageNonAdap(:,:,chan) = sequence{chan}.nonAdaptive.bestResult{index};
                outputSequence.nonAdaptive.bestAlpha(chan) = sequence{chan}.nonAdaptive.bestAlpha;
            end
        end
        
         if adaptative
             outputSequence.adaptive.bestResult{index} = imageAdap(:,:,1) | imageAdap(:,:,2) | imageAdap(:,:,3);
         end
         if nonAdaptative    
             outputSequence.nonAdaptive.bestResult{index} = imageNonAdap(:,:,1) | imageNonAdap(:,:,2) | imageNonAdap(:,:,3);
        end
    end
    
    outputSequence.gt = sequence{1}.gt;
    outputSequence.seqName = sequence{1}.seqName;

    [ ~ , sequenceEvaluation ] = evaluation(outputSequence.adaptive.bestResult, outputSequence.gt);
    outputSequence.adaptive.bestF = sequenceEvaluation.F;
    [ ~ , sequenceEvaluation ] = evaluation(outputSequence.nonAdaptive.bestResult, outputSequence.gt);
    outputSequence.nonAdaptive.bestF = sequenceEvaluation.F;
end

