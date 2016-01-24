function [im1warped] = ImageWarp(im1, u, v);

[height, width] = size(im1);

im1warped = zeros(size(height,width));

for i = 1:height,
    for j = 1:width,
        ii = i + v(i,j);
        jj = j + u(i,j);
        
        ii(ii<1)=1; jj(jj<1)=1; ii(ii>height-1)=height-1; jj(jj>width-1)=width-1;
        
        ii_topleft = floor(ii);
        jj_topleft = floor(jj);
        
        y = ii - ii_topleft;
        x = jj - jj_topleft;
        
        Ix1 = (1-x)*im1(ii_topleft,jj_topleft) + x*im1(ii_topleft,jj_topleft+1);
        Ix2 = (1-x)*im1(ii_topleft+1,jj_topleft) + x*im1(ii_topleft+1,jj_topleft+1);
        
        im1warped(i,j) = (1-y)*Ix1 + y*Ix2;
    end
end

