function stabilizedSequence = StabilizedVideo(sequence, flow)

opicalFlowX = zeros(size(flow{1}));
opicalFlowY = zeros(size(flow{1}));
dx = 0;
dy = 0;
stabilizedSequence = {sequence{1}};
for ii = 2:length(sequence)
    opticalFlowX = opicalFlowX + dx;%flow{ii-1}.Vx;
    opticalFlowY = opicalFlowY + dy;%flow{ii-1}.Vy;

    meanVx = mean(opticalFlowX(:));
    meanVy = mean(opticalFlowY(:));
    dx = ceil(abs(meanVx));
    dy = ceil(abs(meanVy));
    current = sequence{ii};
    stabilizedImage = stabilizedSequence{end};
    if meanVx <= 0 && meanVy > 0
        stabilizedImage(dy+1:end, 1:end-dx) = current(1:end-dy, dx+1:end);
       
    elseif meanVx <= 0 && meanVy <= 0
        stabilizedImage(1:end-dy, 1:end-dx) = current(dy+1:end, dx+1:end);
    elseif meanVx > 0  && meanVy > 0
        stabilizedImage(dy+1:end, dx+1:end) = current(1:end-dy, 1:end-dx);
    elseif meanVx > 0 && meanVy <= 0
        stabilizedImage(1:end-dy, dx+1:end) = current(dy+1:end, 1:end-dx);
    end
    imshowpair(stabilizedImage/255, stabilizedSequence{end}/255)
    pause(0.02)
    stabilizedSequence{end+1} = stabilizedImage;
      
end

