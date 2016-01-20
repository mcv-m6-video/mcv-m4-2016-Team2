function [ video ] = writeVideoSta( images )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

video = VideoWriter('videoSta.avi');
open(video);

for i= 1: lenght(images)
    
    imshow(image(i))
    writeVideo(video, getframe(gcf));
end

close(video)
end

