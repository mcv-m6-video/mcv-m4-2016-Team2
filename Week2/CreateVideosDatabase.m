function CreateVideosDatabase()
config = Config();

% highwayFrames   = config.highway.testFrames;
% fallFrames      = config.fall.testFrames;
% trafficFrames   = config.traffic.testFrames;

highwayFrames = [1050: 1350];
fallFrames =    [1460 :1560];
trafficFrames = [950  :1050];

rootDir = '../../Data/';
createVideo(rootDir, 'Highway', highwayFrames);
createVideo(rootDir, 'fall', fallFrames);
createVideo(rootDir, 'traffic', trafficFrames);

function createVideo (workingDir, sequence, frames)
    workingDir = fullfile(rootDir, sequence, 'input/');
    images = LoadImages(workingDir, frames, 'in', 'jpg');

    % create new video object
    outputVideo = VideoWriter(fullfile(rootDir, sequence, 'video.avi'));
    open(outputVideo);

    for ii = 1:length(images)
       img = images{ii};
       writeVideo(outputVideo,img)
    end

    close(outputVideo)

end

end