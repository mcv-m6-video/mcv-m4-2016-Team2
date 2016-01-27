i=2;

figure;
%Lk{i}.compensatedImageLK/255
%kitti{i}.compensatedImageLK/255
subplot(2, 1, 1); imshow(Lk{i}.compensatedImageLK/255);
En = subplot(2, 1, 2);  colormap(En, jet);imshow(E{i}>3);

%%
gtPath = sprintf ( '%s%06d_%02d.%s', cfg.kitti.gtPath, cfg.kittiSequences(2), 10, 'png');
   kitti{2}.gt = imread(gtPath);

gtPath = sprintf ( '%s%06d_%02d.%s', cfg.kitti.gtPath, cfg.kittiSequences(1), 10, 'png');
   kitti{1}.gt = imread(gtPath);