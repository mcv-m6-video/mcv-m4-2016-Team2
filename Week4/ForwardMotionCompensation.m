function compensatedImage = ForwardMotionCompensation(reference, flow)

[sy, sx] = size(reference);
compensatedImage = zeros(size(reference));

for yy = 1:sy
    for xx = 1:sx
        
        dy = floor(flow.Vy(yy, xx));
        dx = floor(flow.Vx(yy, xx));
        posX = xx-dx;
        posY = yy-dy;

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