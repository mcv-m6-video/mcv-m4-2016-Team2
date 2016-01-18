function [image] = BlockMatching(image,cfg)
% Backward
% block size = 16x16
% area search = 32x32 (2n+1)*(2n+1)

current = image.current;
reference = image.reference;
blockSize = cfg.blockSize;
[rows, cols] = size(current);
%numBlocksPerRow = rows/blockSize;
%numBlocksPerCol = cols/blockSize;
vmR = zeros(rows, cols);
vmC = zeros(rows, cols);

for rr = 1: blockSize: rows-blockSize+1
    for cc = 1: blockSize: cols-blockSize+1
        % Get block
        point.pointR1 = rr;
        point.pointR2 = rr + blockSize -1;
        point.pointC1 = cc;
        point.pointC2 = cc + blockSize -1;
        
        currentBlock = current(point.pointR1:point.pointR2,...
                                point.pointC1:point.pointC2);
        % Search area
        [vmRBlock, vmCBlock] = SearchAlgorithm_moni(reference, currentBlock, point, cfg);
        vmR(point.pointR1:point.pointR2,...
            point.pointC1:point.pointC2) = vmRBlock;
        vmC(point.pointR1:point.pointR2,...
            point.pointC1:point.pointC2) = vmCBlock;
   
    end
end

image.vmR = vmR;
image.vmC = vmC;
end
