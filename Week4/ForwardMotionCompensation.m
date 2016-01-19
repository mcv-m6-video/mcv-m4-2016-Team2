function compensatedImage = ForwardMotionCompensation(reference, flow)

[sy, sx] = size(reference);
compensatedImage = zeros(size(reference));

for yy = 1:sy
    for xx = 1:sx
        dy = floor(flow.Vy(yy, xx));
        dx = floor(flow.Vx(yy, xx));
        compensatedImage(yy, xx) = reference(yy-dy, xx-dx);
    end
end