function showSequence(sequence, field)

% images 
images = sequence.test;
% ground truth
gt = sequence.gt;
% labeled images
if nargin > 1 && strcmp(field, 'adaptive')
    labeledImg = sequence.adaptive.bestResult;
else
    labeledImg = sequence.nonAdaptive.bestResult;
end

subplot(2, 3, 1); imshow(sequence.gaussian.mean/255)
subplot(2, 3, 2); imshow(sequence.gaussian.variance/255)
subplot(2, 3, 3); imshow(sequence.gaussian.stdDev/255)
% show images
for index = 1:length(images)
    subplot(2, 3, 4); imshow(images{index}/255)
    subplot(2, 3, 5); imshow(gt{index})
    subplot(2, 3, 6); imshow(labeledImg{index})
    
    pause(0.07)
end

