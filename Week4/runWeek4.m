cfg = Config();

[kitti] = LoadKitti(cfg);

for i = 1:length(kitti)   
    [kitti{i}] = BlockMatching(kitti{i},cfg);
end
