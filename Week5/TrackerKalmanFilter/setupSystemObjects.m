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
obj.detector.alpha = 1.8;%cfg.alpha;
obj.detector.rho = 0.2;%cfg.rho;

% Connected groups of foreground pixels are likely to correspond to moving
% objects.  The blob analysis System object is used to find such groups
% (called 'blobs' or 'connected components'), and compute their
% characteristics, such as area, centroid, and the bounding box.

obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', true, 'CentroidOutputPort', true, ...
    'MinimumBlobArea',200);

    %'AreaOutputPort', true, 'MajorAxisLengthOutputPort', true,  'CentroidOutputPort', true, ...
    %'MinimumBlobArea', 400);%, 'MaximumBlobArea', 900);


% Configuration options of Kalman Filter
% switch from ConstantAcceleration to ConstantVelocity
% If MotionModel =='ConstantAcceleration' ('ConstantVelocity', initiEstiError and motionNoise must be a 3-element(2-elem)
% vectors specifying the variance of location, the variance of velocity, and the variance of acceleration.
obj.kalmanFilter.motionModel = 'ConstantAcceleration'; 
obj.kalmanFilter.initialEstimateError = [100, 50, 10];

% When you increase the motion noise, the Kalman filter 
% relies more heavily on the incoming measurements than on its internal state. 
obj.kalmanFilter.motionNoise = [100, 25, 10];

% Increasing the measurement noise causes the Kalman filter to rely 
% more on its internal state rather than the incoming measurements
obj.kalmanFilter.measurementNoise = 100;

obj.tracking.invisibleForTooLong = sequence.tracking.invisibleForTooLong; % 5 for traffic % default 20

% Speed estimation
obj.speedEstimation.previousLocation = [];