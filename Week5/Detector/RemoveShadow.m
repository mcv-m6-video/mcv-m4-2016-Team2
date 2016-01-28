function [ result ] = RemoveShadow( frame, masks, obj )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

I = rgb2hsv(frame);

Hgaussian = obj.shadow.Hgaussian; 
Sgaussian = obj.shadow.Sgaussian;
Vgaussian = obj.shadow.Vgaussian;

param = obj.shadow.param;
alphaV = param(1);
betaV = param(2);
thresS = param(3);
thresH = param(4);

mask = masks== 1;

result = masks;

Vdivision = I(:,:,3)./Vgaussian.mean;

maskV = alphaV< Vdivision & Vdivision<= betaV;
% maskV = bwconvhull(maskV, 'objects', 4);
%maskV = imfill(maskV, 'holes');

maskS = (I(:,:,2) - Sgaussian.mean) <= thresS;
%maskS = bwconvhull(maskS, 'objects', 8);
maskS = imfill(maskS, 'holes');

maskH = abs(I(:,:,1) - Hgaussian.mean) <= thresH;
%maskH = bwconvhull(maskH, 'objects', 8);
maskH = imfill(maskH, 'holes');

result(maskV & maskS & maskH & mask) = 0; 

% figure()
subplot(2,2,1), title('maskV'), imshow(maskV & mask)
subplot(2,2,2), title('maskS'), imshow(maskS & mask),
subplot(2,2,3), title('maskH'), imshow(maskH & mask),
subplot(2,2,4), title('result'), imshow(maskV & maskS & maskH & mask);

end

