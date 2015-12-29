function [ outputSequence ] = joinChannels( sequence, numChannels )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    for index = 1:length(sequence.test)
        
        for chan = 1:numChannels
            nonAdaIma(index) = [sequence{chan}.nonAdaptive.bestResult{index};
            AdaIma{index,chan} = 
        end
        
        
    end
    
    outputSequence.gt = sequence{index}.gt;
    outputSequence.seqName = sequence{index}.seqName;

end

