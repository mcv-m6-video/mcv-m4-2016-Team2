function [TP, FN, FP, TN, ForegroundPxperFrame] = evaluationPerFrame(image, gt)

% image   = image > 0;
% gt      = gt > 0;

TP = sum(sum(image > 0 & gt == 255));
FP = sum(sum(image > 0 & gt == 0));
FN = sum(sum(image == 0 & gt == 255));
TN = sum(sum(image == 0 & gt == 0));
ForegroundPxperFrame = sum(sum(gt == 255));
