function [vmY, vmX]=SearchAlgorithm3steps(reference, currentBlock, point, cfg)
% Design parameters
p=cfg.blockSize;
blockSize = cfg.blockSize;

L = floor(log10(p+1)/log10(2));
stepSize = 2^(L-1);

y = point.pointR1;
x = point.pointC1;
xRef = x;
yRef = y;
[sy, sx] = size(reference);

% cost matrix contains MSE value for the 9 points. [3, 3]
costMatrix = Inf*ones(3, 3);

% The value at the center point is stored in order to avoid calculating
% this value at each iteration. 
referenceBlock = reference(y:y+blockSize-1, x:x+blockSize-1) ;
costMatrix(2, 2) = immse(currentBlock, referenceBlock);

while stepSize >= 1
    % for each point (9-points)
    for m = -stepSize:stepSize:stepSize
        for n = -stepSize:stepSize:stepSize
            % coordinates in the reference image
            coordinateX = xRef + n;
            coordinateY = yRef + m;
            
            % If the point is outside the image
            if (coordinateX < 1 || coordinateY < 1 || coordinateX+blockSize-1 > sx ||coordinateY+blockSize-1 > sy)
                continue;
            end
            % position at the cost matrix [3, 3]
            posXcost = n/stepSize + 2;
            posYcost = m/stepSize + 2;
            % We do not recompute the value of the center point. It is stored
            % from the previous iteration
            if posXcost == 2 && posYcost == 2
                continue;
            end
            % Get the block [blockSize, blockSize] at this point
            referenceBlock = ...
                reference(coordinateY:coordinateY+blockSize-1,...
                coordinateX:coordinateX+blockSize-1);
            % Compare both blocks and save the result
            costMatrix(posYcost, posXcost) = immse(currentBlock, referenceBlock);
            
        end
    end
    
    % Find which macroblock in reference image gave us minimum cost
    [minVal, ind] = min(costMatrix(:));
    [dy, dx] = ind2sub(size(costMatrix), ind);
    
    % shift root coordinates to the minima point
    xRef = xRef + (dx-2)*stepSize;
    yRef = yRef + (dy-2)*stepSize;
    
    stepSize = stepSize/2;
    costMatrix = Inf*ones(3, 3);
    costMatrix(2, 2) = minVal;
end

vmX = xRef - x;
vmY = yRef - y;

