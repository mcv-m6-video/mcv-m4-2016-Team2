function filteredMask = TrafficFiltering(mask)
% filteredMask = imopen(mask, strel('square', 13));
mask2 = imreconstruct(imerode(mask, strel('disk', 7)), mask);
%         mask = bwconvhull(mask, 'objects', 8);
%         mask = imopen(mask, strel('disk', 10));
% mask1 = bwareaopen(mask, 50, 8);
% mask2 = imopen(mask, strel('disk', 7)); 
filteredMask = imclose(mask2, strel('disk', 30));
 filteredMask = bwconvhull(filteredMask, 'objects', 8);
% subplot(2, 2, 1); imshow(mask)
% subplot(2, 2, 2); imshow(mask1)
% subplot(2, 2, 3); imshow(filteredMask)
% filteredMask = imreconstruct(imerode(filteredMask, strel('square', 10)), filteredMask);
% filteredMask = imopen(filteredMask, strel('disk', 20));
%         mask = imclose(mask, strel('rectangle', [10 40]));
%         mask = imfill(mask, 'holes');