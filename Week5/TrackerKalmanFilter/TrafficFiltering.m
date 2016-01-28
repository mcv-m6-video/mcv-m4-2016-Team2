function filteredMask = TrafficFiltering(mask)
filteredMask = imopen(mask, strel('square', 15));
filteredMask = imreconstruct(imerode(mask, strel('disk', 10)), filteredMask);
%         mask = bwconvhull(mask, 'objects', 8);
%         mask = imopen(mask, strel('disk', 10));
filteredMask = imclose(filteredMask, strel('disk', 50));
%         mask = imclose(mask, strel('rectangle', [10 40]));
%         mask = imfill(mask, 'holes');