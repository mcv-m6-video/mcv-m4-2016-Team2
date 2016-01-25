function obj = setupSystemObjects(sequence)

% Initialize Video I/O
% Create objects for reading a video from a file, drawing the tracked
% objects in each frame, and playing the video.

% Create a video file reader.
obj.reader.frames = sequence.test;%vision.VideoFileReader('/Users/monica/CV_master/M4/Data/traffic/video.avi');
obj.reader.index = 1;
% Create two video players, one to display the video,
% and one to display the foreground mask.
obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

% Create System objects for foreground detection and blob analysis

% The foreground detector is used to segment moving objects from
% the background. It outputs a binary mask, where the pixel value
% of 1 corresponds to the foreground and the value of 0 corresponds
% to the background.

% obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
%     'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);
obj.detector.gaussian = GaussianPerPixel( sequence.train);
obj.detector.alpha = 2;
obj.detector.rho = 0.02;

% Connected groups of foreground pixels are likely to correspond to moving
% objects.  The blob analysis System object is used to find such groups
% (called 'blobs' or 'connected components'), and compute their
% characteristics, such as area, centroid, and the bounding box.

obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea', 400);

% Configuration options of Kalman Filter
% switch from ConstantAcceleration to ConstantVelocity
obj.kalmanFilter.motionModel = 'ConstantVelocity'; 
obj.kalmanFilter.initialEstimateError = [200, 50];
obj.kalmanFilter.motionNoise = [100, 25];
obj.kalmanFilter.measurementNoise = 100;

