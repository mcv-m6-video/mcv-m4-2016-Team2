% TASK 2: Comparison with Lucas-Kanade
cfg = Config();

[kitti] = LoadKitti(cfg);
cfg.p = 16;
%% BLOCK MATCHING
for i = 1:length(kitti)
    display(['Sequence: ' num2str(i)])
    kitti{i}.B = cfg.blockSize;
    kitti{i}.methodBM = cfg.methodBM;
    tstart = tic;
    kitti{i}.flowBM = BlockMatching(kitti{i},cfg);
    kitti{i}.telapsedBM = toc(tstart);
    kitti{i}.compensatedImageBM = BackwardMotionCompensation(kitti{i}.reference, kitti{i}.flowBM);
    kitti{i}.pepnBM = pepn(kitti{i}.compensatedImageBM, kitti{i}.current);
    kitti{i}.mmseBM = immse(kitti{i}.compensatedImageBM, im2double(kitti{i}.current));
end

%% LUCAS-KANADE
opticalFlow = opticalFlowLK('NoiseThreshold', 0.03);
for ii_seq = 1:length(kitti)
    sequence = kitti{ii_seq}.reference;
    sequence(:,:, end+1) = kitti{ii_seq}.current;
    for i = 1:size(sequence, 3)
        frame = sequence(:,:,i);
        tstart = tic;
        flowLK = estimateFlow(opticalFlow, frame);
        kitti{i}.telapsedLK = toc(tstart);
    end
    kitti{ii_seq}.flowLK = flowLK;
    kitti{ii_seq}.compensatedImageLK = ForwardMotionCompensation(kitti{ii_seq}.reference, kitti{ii_seq}.flowLK);
    kitti{ii_seq}.pepnLK = pepn(kitti{ii_seq}.compensatedImageLK, kitti{ii_seq}.current);
    kitti{ii_seq}.mmseLK = immse(kitti{ii_seq}.compensatedImageLK, im2double(kitti{ii_seq}.current));
    opticalFlow.reset();
    
end



%% Evaluation 

% figure;
% subplot(4, 1, 1); imshow(kitti{1}.reference);
% subplot(4, 1, 2); imshow(kitti{1}.current);
% subplot(4, 1, 3); imshow(compensatedImageBM/255);
% subplot(4, 1, 4); imshowpair(compensatedImageBM, kitti{1}.current)
%
% figure;
% subplot(4, 1, 1); imshow(kitti{1}.reference);
% subplot(4, 1, 2); imshow(kitti{1}.current);
% subplot(4, 1, 3); imshow(compensatedImageLK/255);
% subplot(4, 1, 4); imshowpair(compensatedImageLK, kitti{1}.current)
% 
