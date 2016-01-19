cfg = Config();

[kitti] = LoadKitti(cfg);

for i = 1:length(kitti)   
    display(['Sequence: ' num2str(i)])
    [kitti{i}.flowBM] = BlockMatching(kitti{i},cfg);
end


