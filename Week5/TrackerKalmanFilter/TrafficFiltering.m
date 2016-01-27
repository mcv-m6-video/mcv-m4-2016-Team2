function filteredMask = TrafficFiltering(mask)
filteredMask = imopen(mask, strel('square', 20));
% filteredMask = imreconstruct(imerode(mask, strel('rectangle', [17 17])), mask);
%         mask = bwconvhull(mask, 'objects', 8);
%         mask = imopen(mask, strel('disk', 10));
filteredMask = imclose(filteredMask, strel('disk', 30));
%         mask = imclose(mask, strel('rectangle', [10 40]));
%         mask = imfill(mask, 'holes');