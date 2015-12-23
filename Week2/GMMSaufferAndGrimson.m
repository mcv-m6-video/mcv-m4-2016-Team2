
pathVideo = '../../Data/fall/video.avi';

%Create system objects to read file.
videoSource = vision.VideoFileReader( pathVideo,'ImageColorSpace','Intensity','VideoOutputDataType','uint8');

detector = vision.ForegroundDetector(...
       'AdaptLearningRate', true,...
       'NumTrainingFrames', 50,...
       'LearningRate', 0.005,...
       'MinimumBackgroundRatio', 0.7,...
       'NumGaussians', 4);

% detector = vision.ForegroundDetector(...
%        'AdaptLearningRate', false,...
%        'NumTrainingFrames', 150,...
%        'MinimumBackgroundRatio', 0.7,...
%        'NumGaussians', 3);

videoPlayer = vision.VideoPlayer();
ii= 1;
while ~isDone(videoSource)
     frame  = step(videoSource);
     fgMask = step(detector, frame);
     subplot(1, 2, 1); imshow(frame);
     subplot(1, 2, 2); imshow(fgMask==1)
     ii = ii + 1
     pause(0.1)
end
release(videoSource);