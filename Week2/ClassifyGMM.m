function labeledImg = ClassifyGMM(sequence, numGaussians, learningRate)
% segment the foreground

% Create system objects to read file
videoSource = vision.VideoFileReader( sequence.pathVideo,'ImageColorSpace','Intensity','VideoOutputDataType','uint8');

% 
detector = vision.ForegroundDetector(...
       'AdaptLearningRate', true,...
       'NumTrainingFrames', sequence.numTrainingFrames,...
       'LearningRate', learningRate,...
       'MinimumBackgroundRatio', 0.7,...
       'NumGaussians', numGaussians, ...
       'InitialVariance', 30^2);
labeledImg = {};
while ~isDone(videoSource)
     frame  = step(videoSource);
     fgMask = step(detector, frame);
     labeledImg{end+1} = fgMask;
%      subplot(1, 2, 1); imshow(frame);
%      subplot(1, 2, 2); imshow(fgMask==1)
%      ii = ii + 1
%      pause(0.1)
end
release(videoSource);

% keep only test images
labeledImg = labeledImg(sequence.numTrainingFrames+1:end);

end