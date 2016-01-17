% function BlockMatching()
% Backward
% block size = 16x16
% area search = 32x32

blockSize = 16;
reference = Ttest{1};
current = Ttest{2};

[rows, cols] = size(current);
numBlocksPerRow = rows/blockSize;
numBlocksPerCol = cols/blockSize;

for rr = 0:numBlocksPerRow-1
    for cc = 0:numBlocksPerCol-1
        % Get block
        currentBlock = current((rr*blockSize)+1:(rr+1)*blockSize,...
                                (cc*blockSize)+1:(cc+1)*blockSize);
        % Search area
        [posX, posY] = searchAlgorithm(reference, currentBlock);
    end
end
