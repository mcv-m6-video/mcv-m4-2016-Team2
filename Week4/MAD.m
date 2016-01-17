function [ mad ] = MAD(referenceBlock, currentBlock)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    error = 0;
    [rows, cols] = size(currentBlock);
    for i= 1:rows
        for j = 1: cols
            error = error + abs(currentBlock(i,j)- referenceBlock(i,j));
        end
    end
    
    mad = error/ (rows*cols);

end

