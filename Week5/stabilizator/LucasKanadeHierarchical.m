
function [u,v] = LucasKanadeHierarchical(im1, im2, windowSize, numLevels, numIter);

if (size(im1,1)~=size(im2,1)) | (size(im1,2)~=size(im2,2))
    error('images are not same size');
end;

if (size(im1,3) ~= 1) | (size(im2, 3) ~= 1)
    error('input should be gray level images');
end;

u = zeros(size(im1));
v = zeros(size(im1));


im1_abovetop = imresize(im1,(0.5)^(numLevels),'bilinear');

u_previous = zeros(size(im1_abovetop));
v_previous = zeros(size(im1_abovetop));

for k = numLevels:-1:1,
    im1_current = imresize(im1,(0.5)^(k-1),'bilinear');
    im2_current = imresize(im2,(0.5)^(k-1),'bilinear');

    [h,w] = size(im1_current);

    u_current = imresize(2*u_previous,[h w],'bilinear');
    v_current = imresize(2*v_previous,[h w],'bilinear');

    for i = 1:numIter,

        im1warped = ImageWarp(im1_current,u_current,v_current);
        [u_update, v_update] = LucasKanade(im1warped, im2_current, windowSize);

        u_current = u_current + u_update;
        v_current = v_current + v_update;

        u_previous = u_current;
        v_previous = v_current;

    end
end

u = u_previous;
v = v_previous;