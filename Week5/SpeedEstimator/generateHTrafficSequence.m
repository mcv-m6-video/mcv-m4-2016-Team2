cfg = Config();

% Traffic
sequence = LoadTraffic(cfg);
load('HTraffic.mat');

for i = 1:length(sequence.all)
    Hframe = RemovePerspective(sequence.all{i}, H, [320 240]);
    imshow(Hframe)
    drawnow;
end