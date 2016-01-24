function [u1Sequence, v1Sequence, x, y]=FindMotion(sequence)

numFrames = length(sequence);
x = zeros(numFrames-1,1);
y = zeros(numFrames-1,1);

u1Sequence = [];
v1Sequence = [];

image.reference = sequence{1};

% for each frame
for k = 2:length(sequence)

    tstart = tic;
    % reading frames to be processed
    image.current = sequence{k};
    
    % finding the motion vectors from (i)th to (i+1)th
    % im2 is the reference image
    % im1 is the input image
    [u1Frame, v1Frame] = LucasKanadeHierarchical(image.current, image.reference, 5, 5, 3);
    
    u1Sequence{end+1} = u1Frame;
    v1Sequence{end+1} = v1Frame;
    % making two matrices of correspondances
    [pointsCurrent, pointsReference] = extractPointsFromOpticalFlow(u1Frame, v1Frame);
    
    % Using RANSAC to find outliers
    [H, inliers] = ransacfithomography_v2(pointsReference, pointsCurrent, 0.01);

    if isequal(H, eye(3)) && inliers <= 1
        % Para control
%         if (inliers == 0)
%             countShitySituation1 = countShitySituation1 + 1;
%         else
%             countShitySituation11 = countShitySituation11 + 1;
%         end
        % If no correspondences have been found, assign the previous
        % average movement to the current frame.
        % We guess that the frame is moving as the previuos frame
        if (k==1)
            x(k)=0;
            y(k)=0;
        else
            x(k) = x(k-1);
            y(k) = y(k-1);
        end
    else
        numOfInliers = length(inliers);

        % Making two matrices for inliers in first and second images
        pointsReferenceInliers = pointsReference(:, inliers);
        pointsCurrentInliers = pointsCurrent(:, inliers);
        
    
        % calculating the average movement
        x(k-1) = x(k-1) + sum(pointsCurrentInliers(2, :) - pointsReferenceInliers(2, :))/numOfInliers;
        y(k-1) = y(k-1) + sum(pointsCurrentInliers(1, :) - pointsReferenceInliers(1, :))/numOfInliers;

    end
    image.reference = image.current;
    telapsed = toc(tstart);
    display(['Time ' num2str(k) ' frame: ' num2str(telapsed)])
end