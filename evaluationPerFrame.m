function [TP, FN, FP, TN] = evaluationPerFrame(image, gt)

% image   = image > 0;
% gt      = gt > 0;

TP = sum(sum(image > 0 & gt == 255));
FP = sum(sum(image > 0 & gt == 0));
FN = sum(sum(image == 0 & gt == 255));
TN = sum(sum(image == 0 & gt == 0));