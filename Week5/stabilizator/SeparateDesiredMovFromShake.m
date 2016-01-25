function [finalConvexIMG, finalConvexGT] = ...
    SeparateDesiredMovFromShake(sequence, gtSequence, u1Sequence, v1Sequence, x, y)

numFrames = length(sequence);
[height, width] = size(sequence{1});
multiple = 0.5;
finalConvexIMG = zeros(round((1+(2*multiple))*(height)),...
    round((1+(2*multiple))*(width)) , numFrames);
finalConvexGT = zeros(round((1+(2*multiple))*(height)),...
    round((1+(2*multiple))*(width)) , numFrames);
% width son columnas
% height son filas
startPoint(2) = round((multiple)*(width)); 
startPoint(1) = round((multiple)*(height));
maxStartPointHeight = startPoint(1);
minStartPointHeight = startPoint(1);
maxStartPointWidth = startPoint(2);
minStartPointWidth = startPoint(2);

finalConvexIMG(minStartPointHeight+1:maxStartPointHeight+height, ...
            minStartPointWidth+1:maxStartPointWidth+width) = ...
            sequence{1};
finalConvexGT(minStartPointHeight+1:maxStartPointHeight+height, ...
            minStartPointWidth+1:maxStartPointWidth+width) = ...
            gtSequence{1};
        

% Compensate motion
% smooth the motion
xSmoothMotion = smooth(x,25);
ySmoothMotion = smooth(y,25);
u1SmoothSequence = [];
v1SmoothSequence = [];

display('Smooth....')
for k = 1:numFrames-1
    
    tstart = tic;
    % Smooth the motion 
    u1Smooth = u1Sequence{k} - xSmoothMotion(k);
    v1Smooth = v1Sequence{k} - ySmoothMotion(k);
    u1SmoothSequence{k+1} = u1Smooth;
    v1SmoothSequence{k+1} = v1Smooth;
    
    % Recalculate the correspondences
    [smoothPointsCurr, smoothPointsRef] = ...
        extractPointsFromOpticalFlow(u1Smooth, v1Smooth);
    
    
    % Using RANSAC to find outliers
    [H , inliers] = ransacfithomography_v2(smoothPointsCurr, smoothPointsRef, 0.01);

    if isequal(H, eye(3)) && inliers <= 1
%         % Para control
%         if (inliers == 0)
%             countShitySituation2 = countShitySituation2 + 1;
%         else
%             countShitySituation21 = countShitySituation21 + 1;
%         end
        % If no inliers have been found, there is not a motion
        xShakeMotion(k)=0;
        yShakeMotion(k)=0;
    else
        numOfInliers = length(inliers);

        % Making two matrices for inliers in first and second images
        smoothPointsReferenceInliers = smoothPointsRef(:, inliers);
        smoothPointsCurrentInliers = smoothPointsCurr(:, inliers);
    
        % calculating the average movement
        % xShakeMotion(k) = xShakeMotion(k) + sum(smoothPointsCurrentInliers(2, :) - smoothPointsReferenceInliers(2, :))/numOfInliers;
        % yShakeMotion(k) = yShakeMotion(k) + sum(smoothPointsCurrentInliers(1, :) - smoothPointsReferenceInliers(1, :))/numOfInliers;
        xShakeMotion(k) = mean(smoothPointsReferenceInliers(2, :) - smoothPointsCurrentInliers(2, :));
        yShakeMotion(k) = mean(smoothPointsReferenceInliers(1, :) - smoothPointsCurrentInliers(1, :));

    end

    % Compensate motion
    startPoint(1) = startPoint(1) - round(yShakeMotion(k));
    startPoint(2) = startPoint(2) - round(xShakeMotion(k));
    if (startPoint(1) > maxStartPointHeight)
        maxStartPointHeight = startPoint(1);
    else
        if (startPoint(1) < minStartPointHeight)
            minStartPointHeight = startPoint(1);
        end
    end
    if (startPoint(2) > maxStartPointWidth)
        maxStartPointWidth = startPoint(2);
    else
        if (startPoint(2) < minStartPointWidth)
            minStartPointWidth = startPoint(2);
        end
    end
    finalConvexIMG(startPoint(1)+1:startPoint(1)+height,...
                startPoint(2)+1:startPoint(2)+width , k+1) =...
                sequence{k+1};
    finalConvexGT(startPoint(1)+1:startPoint(1)+height,...
                startPoint(2)+1:startPoint(2)+width , k+1) =...
                gtSequence{k+1};    
    imshow(finalConvexIMG(:, :, k)/255)      
    pause(0.05)
    telapsed = toc(tstart);
    display(['Time ' num2str(k) ' frame: ' num2str(telapsed)])
end
