function [H, S, V] = obtainHSV(sequence)

    H = cellfun(@(c) c(:,:,1), sequence, 'UniformOutput', false);
 
    S = cellfun(@(c) c(:,:,2), sequence, 'UniformOutput', false);

    V = cellfun(@(c) c(:,:,3), sequence, 'UniformOutput', false);

end