
function plotOpticalFlow( real_img, map, result_img )
% plotOpticalFlow.m : display the motion vectors of the optical flow results
%   INPUTS:
%       * real_img : the real image of the database in RGB format
%       * result_img : the result after applying the Optical Flow
    
    % Real image information (rows & columns)
    rows = size(real_img, 1);
    cols = size(real_img, 2);
    
    % Create Optical Flow representation
    [x, y] = meshgrid(1:cols, 1:rows);
    % 'u' and 'v' are the horizontal and vertical optical flow vectors
    u = (double(result_img(:, :, 1)) - 32768) / 64.0;
    v = (double(result_img(:, :, 2)) - 32768) / 64.0;

    % Enhance the quiver plot visually by showing one vector per region
    % 'rSize' is the size of the region in which one vector is visible.
    rSize = 10;
    for i = 1:size(u, 1)
        for j = 1:size(u, 2)
            if floor(i / rSize) ~= i / rSize || floor(j / rSize) ~= j / rSize
                u(i, j) = 0;
                v(i, j) = 0;
            end
        end
    end
    
    % Show the real image with a 0.5 of transparency
    subplot(2, 1, 1), real_img_alpha = imshow(real_img, map);
    set(real_img_alpha, 'AlphaData', 0.5);
    title('REAL image + Motion vectors');
    hold on
    % Show also the motion vectors above
    quiver(x, y, v, u, 'r', 'linewidth', 15)
    
    subplot(2, 1, 2), quiver(x, y, v, u, 'b', 'linewidth', 15)
    title('Motion vectors PLOT');
    xlabel('x-axis pixels');
    ylabel('y-axis pixels');
    hold off
end
