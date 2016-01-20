index = 1;

sequence = kitti{index};

figure;
subplot(4, 1, 1); imshow(sequence.reference);
subplot(4, 1, 2); imshow(sequence.current);
subplot(4, 1, 3); imshow(sequence.compensatedImageBM/255);
subplot(4, 1, 4); imshowpair(sequence.compensatedImageBM, sequence.current)

figure;
imshow(sequence.compensatedImageBM/255);
figure; 
imshowpair(sequence.compensatedImageBM, sequence.current)

figure;
subplot(4, 1, 1); imshow(sequence.reference);
subplot(4, 1, 2); imshow(sequence.current);
subplot(4, 1, 3); imshow(sequence.compensatedImageLK/255);
subplot(4, 1, 4); imshowpair(sequence.compensatedImageLK, sequence.current)