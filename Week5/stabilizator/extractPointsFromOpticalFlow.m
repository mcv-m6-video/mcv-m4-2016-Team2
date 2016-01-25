function [pointsA, pointsB] = extractPointsFromOpticalFlow(u1, v1)

% Get the indices where the optical flow is not 0
nonZeroU1 = find(u1);
nonZeroV1 = find(v1);
nonZero = intersect(nonZeroU1, nonZeroV1);
[I, J] = ind2sub(size(u1), nonZero);

% Calculate the origen position of the optical flow vector
% It is the position in the current frame (backward compensation)
pointsA = zeros(2, length(I));
pointsA(1, :) = I;
pointsA(2, :) = J;
% Calculate the position where the optical flow is pointing
% It is the position of the correspondence point in the reference frame (backward
% compensation)
pointsB = zeros(2, length(I));
pointsB(1, :) = I + v1(nonZero);
pointsB(2, :) = J + u1(nonZero);