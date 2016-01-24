%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Ix, Iy, It] = ComputeDerivatives(im1, im2);
%ComputeDerivatives	Compute horizontal, vertical and time derivative
%							between two gray-level images.

h = [-1 1; -1 1]/2;
g = [1 1; 1 1]/4; 

% Ix = ( imfilter(im1,h) + imfilter(im2,h) )/2; 
% Iy = ( imfilter(im1,h') + imfilter(im2,h') )/2;
% It = imfilter(im1,g) - imfilter(im2,g); 

Ix = imfilter(im1,h); 
Iy = imfilter(im1,h');
It = imfilter(im1,g) - imfilter(im2,g); 

