cfg = Config();
traffic = LoadTraffic(cfg);


% image.reference = traffic.test{1};
% image.current = traffic.test{2};
% flowBM = BlockMatching(image,cfg);

flowBM = {};
image.reference = traffic.train{1};
for ii = 2:length(traffic.train)
    image.current = traffic.train{ii};
    flowBM{ii-1} = BlockMatching(image, cfg);
    image.reference = image.current;
end

for ii=1:length(traffic.test)
    image.current = traffic.test{ii};
    flowBM{end+1} = BlockMatching(image, cfg);
    image.reference = image.current;
end

sequence = [traffic.train, traffic.test];

stabilizedSequence = StabilizedVideo(sequence, flowBM);

figure;
for ii=1:length(stabilizedSequence)
    imshow(stabilizedSequence{ii}/255)
    pause(0.05)
end


