function compensatedImage = BackwardMotionCompensation(reference, flow)

[sy, sx] = size(reference);
compensatedImage = zeros(size(reference));
% testIxy = (double(flow(:,:,1:2)) - 2^15) ./ 64;
% testIx = floor(testIxy(:,:,1));
% testIy = floor(testIxy(:,:,2));
for yy = 1:sy
    for xx = 1:sx
%         dy = testIy(yy,xx);
%         dx = testIx(yy,xx);
        
        dy = floor(flow.Vy(yy, xx));
        dx = floor(flow.Vx(yy, xx));

        posX = xx+dx;
        posY = yy+dy;
        
        if posX > sx
            posX = sx;
        elseif posX <= 0
            posX = 1;
        end
        if posY > sy
            posY = sy;
        elseif posY <= 0
            posY = 1;
        end
        
        compensatedImage(yy, xx) = reference(posY, posX);
    end
end