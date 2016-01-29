% TASK 2: Comparison with Lucas-Kanade
cfg = Config();

[kitti] = LoadKitti(cfg);
cfg.p = 8;

%% Horn Schunck Optical Flow
% for i = 1:(length(kitti))
%     display(['Sequence: ' num2str(i)])
%     kitti{i}.LKPR.Levels = cfg.LKPR.Levels;
%     kitti{i}.LKPR.Window = cfg.LKPR.Window;
%     tstart = tic;
%     
%     image1 = kitti{i}.reference;
%     image2 = kitti{i}.current;
%     kitti{i}.HS.flow = HS(image1, image2);
%     kitti{i}.HS.time = toc(tstart);
%     [kitti{i}.HS.mmse, kitti{i}.HS.pepn] = MSEImages(kitti{i}.HS.flow, kitti{i}.gt);
% end

%% LKPR
for i = 1:(length(kitti))
    display(['Sequence: ' num2str(i)])
    kitti{i}.LKPR.Levels = cfg.LKPR.Levels;
    kitti{i}.LKPR.Window = cfg.LKPR.Window;
    tstart = tic;
    
    image1 = kitti{i}.reference;
    image2 = kitti{i}.current;
    kitti{i}.LKPR.flow = LKPR(image1, image2, cfg.LKPR.Levels, cfg.LKPR.Window);
    kitti{i}.LKPR.time = toc(tstart);
    [kitti{i}.LKPR.mmse, kitti{i}.LKPR.pepn] = MSEImages(kitti{i}.LKPR.flow, kitti{i}.gt);
end