cfg = Config();

[kitti] = LoadKitti(cfg);

for i = 1:1%length(kitti)
    display(['Sequence: ' num2str(i)])
    [kitti{i}.flowBM] = BlockMatching(kitti{i},cfg);
end
%% 
% flowBM.Vx = kitti{1}.vmC;
% flowBM.Vy = kitti{1}.vmR;
%%
reference = kitti{1}.reference;

compensatedImageBM = BackwardMotionCompensation(kitti{1}.reference, kitti{1}.flowBM);

pepnBM = pepn(compensatedImageBM, kitti{1}.current);
mmseBM = immse(compensatedImageBM, im2double(kitti{1}.current));

figure;
subplot(4, 1, 1); imshow(kitti{1}.reference);
subplot(4, 1, 2); imshow(kitti{1}.current);
subplot(4, 1, 3); imshow(compensatedImageBM/255);
subplot(4, 1, 4); imshowpair(compensatedImageBM, kitti{1}.current)

%%
opticalFlow = opticalFlowLK('NoiseThreshold', 0.03);
sequence = kitti{1}.reference;
sequence(:,:,end+1) = kitti{1}.current;
for ii=1:size(sequence, 3)
    frame = sequence(:,:,ii);
    flowLK = estimateFlow(opticalFlow, frame); 
end

compensatedImageLK = ForwardMotionCompensation(kitti{1}.reference, flowLK);

pepnLK = pepn(compensatedImageLK, kitti{1}.current);
mmseLK = immse(compensatedImageLK, im2double(kitti{1}.current));

figure;
subplot(4, 1, 1); imshow(kitti{1}.reference);
subplot(4, 1, 2); imshow(kitti{1}.current);
subplot(4, 1, 3); imshow(compensatedImageLK/255);
subplot(4, 1, 4); imshowpair(compensatedImageLK, kitti{1}.current)

