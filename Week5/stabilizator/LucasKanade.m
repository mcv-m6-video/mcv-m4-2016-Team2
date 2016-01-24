function [u, v] = LucasKanade(im1, im2, windowSize);
% Lucas-Kanade algorithm (one level)

% im2 is the reference image
% im1 is the input image
% u,v are the motion vectors from im2 to im1


if (size(im1,1) ~= size(im2,1)) | (size(im1,2) ~= size(im2,2))
    error('input images are not the same size');
end;
if (size(im1,3)~=1) | (size(im2,3)~=1)
    error('method only works for gray-level images');
end;

% Get height and width of the images
[height,width] = size(im1);

% Compute the derivatives
[Ix, Iy, It] = ComputeDerivatives(im1, im2);

% Blur the images
h = fspecial('gaussian');
im1 = imfilter(im1,h);
im2 = imfilter(im2,h);

% Initialize the motion vectors
u = zeros(height,width);
v = zeros(height,width);

% Get half the window size
halfWindow = floor(windowSize/2);

% For all pixels, find motion vector
for i = 1+halfWindow:height-halfWindow
    for j = 1+halfWindow:width-halfWindow
        % Get the current window
        curFx = Ix(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
        curFy = Iy(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
        curFt = It(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
        
        % Here I am doing spatial weighting
        sigma_d = 1.5;
        d = [-halfWindow:halfWindow]; d = d(:);     
        Weight_d = exp(-(d.^2)/(2*sigma_d*sigma_d));
        Weight_d = Weight_d*Weight_d';
        % Range weighting
        sigma_r = 5;
        curIm = im2(i-halfWindow:i+halfWindow, j-halfWindow:j+halfWindow);
        Weight_r = 0.1+exp(-((curIm-im2(i,j)).^2)/(2*sigma_r*sigma_r));
        %Weight_r = exp(-((curFx-curFx(1+halfWindow,1+halfWindow)).^2)/(2*sigma_r*sigma_r));
        Weight_d = Weight_r.*Weight_d;
        
        curFx = curFx.*Weight_d;
        curFy = curFy.*Weight_d;
        curFt = curFt.*Weight_d;
        
        curFx = curFx(:);
        curFy = curFy(:);
        curFt = -curFt(:);

        A = [curFx curFy];

        U = pinv(A)*curFt;

        u(i,j)=U(1);
        v(i,j)=U(2);
    end;
end;

u(isnan(u))=0;
v(isnan(v))=0;


