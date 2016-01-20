cfg = Config();
traffic = LoadTraffic(cfg);


% image.reference = traffic.test{1};
% image.current = traffic.test{2};
% flowBM = BlockMatching(image,cfg);
% 
% flowBM = {};
% image.reference = traffic.train{1};
% for ii = 2:length(traffic.train)
%     image.current = traffic.train{ii};
%     flowBM{ii-1} = BlockMatching(image, cfg);
%     image.reference = image.current;
% end
% 
% for ii=1:length(traffic.test)
%     image.current = traffic.test{ii};
%     flowBM{end+1} = BlockMatching(image, cfg);
%     image.reference = image.current;
% end

sequence = [traffic.train, traffic.test];
stabilizedSequence = StabilizedVideo_v2(sequence, cfg);
% stabilizedSequence = StabilizedVideo(sequence, flowBM);

figure;
for ii=1:length(stabilizedSequence)
    subplot(3, 1, 1);imshow(stabilizedSequence{ii}/255)
    subplot(3, 1, 2);imshow(sequence{ii}/255);
    subplot(3, 1, 3);imshow(abs(stabilizedSequence{ii}-sequence{ii})/255);
    
    pause(0.05)
end


