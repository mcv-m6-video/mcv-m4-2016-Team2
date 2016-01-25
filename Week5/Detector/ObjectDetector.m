function [mask, obj] = ObjectDetector(frame, obj)%alpha, adaptive, rho)

frame = double(rgb2gray(frame));

mean = obj.detector.gaussian.mean;
stdDev = obj.detector.gaussian.stdDev;
variance = obj.detector.gaussian.variance;

mask = ClassifyGaussian(frame, mean, stdDev, obj.detector.alpha);

[mean, variance] = AdaptiveModel(mean, variance, mask, frame, obj.detector.rho);
stdDev = sqrt(variance);

obj.detector.gaussian.mean = mean;
obj.detector.gaussian.stdDev = stdDev;
obj.detector.gaussian.variance = variance;

