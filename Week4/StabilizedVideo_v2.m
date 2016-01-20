function stabilizedSequence = StabilizedVideo_v2(sequence, cfg)

stabilizedSequence = {sequence{1}};
image.reference = sequence{1};
for ii = 2:length(sequence)
    image.current = sequence{ii};
    flow = BlockMatching(image, cfg);
    image.reference = image.current;

    meanVx = mean(flow.Vx(:));
    meanVy = mean(flow.Vy(:));
    dx = ceil(abs(meanVx));
    dy = ceil(abs(meanVy));

    stabilizedImage = stabilizedSequence{end};
    if meanVx <= 0 && meanVy > 0
        stabilizedImage(dy+1:end, 1:end-dx) = image.current(1:end-dy, dx+1:end);
       
    elseif meanVx <= 0 && meanVy <= 0
        stabilizedImage(1:end-dy, 1:end-dx) = image.current(dy+1:end, dx+1:end);
    elseif meanVx > 0  && meanVy > 0
        stabilizedImage(dy+1:end, dx+1:end) = image.current(1:end-dy, 1:end-dx);
    elseif meanVx > 0 && meanVy <= 0
        stabilizedImage(1:end-dy, dx+1:end) = image.current(dy+1:end, 1:end-dx);
    end
    imshowpair(stabilizedImage/255, stabilizedSequence{end}/255)
    pause(0.02)
    stabilizedSequence{end+1} = stabilizedImage;
      
end